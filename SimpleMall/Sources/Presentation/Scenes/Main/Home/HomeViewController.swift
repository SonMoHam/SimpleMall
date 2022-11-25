//
//  HomeViewController.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/24.
//

import Foundation
import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
    // MARK: Constants
    
    private enum CollectionViewSection: Int {
        case banner
        case goods
        
        var columnCount: Int { return 1 }
        
        var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
            switch self {
            case .banner: return .groupPagingCentered
            case .goods: return .none
            }
        }
    }
    
    // MARK: Properties
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = .gray
        collectionView.register(
            BannerCell.self,
            forCellWithReuseIdentifier: BannerCell.reuseIdentifier)
        collectionView.register(
            ProductCell.self,
            forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        return collectionView
    }()
    
    private let services: UseCaseProdiver
    private var dataSource: UICollectionViewDiffableDataSource<CollectionViewSection, AnyHashable>!
    private var snapshot = NSDiffableDataSourceSnapshot<CollectionViewSection, AnyHashable>()
    private var disposeBag = DisposeBag()
    
    // MARK: Initializing
    
    init(services: UseCaseProdiver) {
        self.services = services
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .brown
        self.view.addSubview(collectionView)
        setupConstraints()

        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, element in
                if let _ = element as? Banner,
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: BannerCell.reuseIdentifier,
                        for: indexPath
                    ) as? BannerCell {
                    return cell
                }
                
                if let product = element as? Product,
                   let cell = collectionView.dequeueReusableCell(
                       withReuseIdentifier: ProductCell.reuseIdentifier,
                       for: indexPath
                   ) as? ProductCell {
                    cell.isNewLabel.text = product.name
                   return cell
               }
                return UICollectionViewCell()
            })
        
        services.makeBannerUseCase()
            .banners()
            .bind { [weak self] in
                self?.snapshot.appendSections([.banner])
                self?.snapshot.appendItems($0)
                self?.dataSource.apply(self!.snapshot, animatingDifferences: true)
            }.disposed(by: disposeBag)
        
        services.makeProductUseCase()
            .products()
            .bind { [weak self] in
                self?.snapshot.appendSections([.goods])
                self?.snapshot.appendItems($0)
                self?.dataSource.apply(self!.snapshot, animatingDifferences: true)
            }.disposed(by: disposeBag)

    }
    
    // MARK: Methods
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
    
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = CollectionViewSection(rawValue: sectionIndex) else {
                return nil
            }

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),  // group 내 item, width 꽉 채움
                heightDimension: .estimated(100))   // 동적 높이
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),  // width 꽉 채움
                heightDimension: .estimated(100))   // 동적 높이
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: section.columnCount)
            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.orthogonalScrollingBehavior = section.orthogonalScrollingBehavior
            return layoutSection
        }
        return layout
    }
}
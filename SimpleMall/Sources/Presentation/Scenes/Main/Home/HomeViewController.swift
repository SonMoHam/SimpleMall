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
        
        var itemHeightDimension: NSCollectionLayoutDimension {
            switch self {
            case .banner: return .fractionalHeight(1)
            case .goods: return .estimated(100)
            }
        }
        
        var groupHeightDimension: NSCollectionLayoutDimension {
            switch self {
            case .banner: return .fractionalWidth(2/3)
            case .goods: return .estimated(100)
            }
        }
    }
    
    // MARK: Properties
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.register(
            BannerViewCell.self,
            forCellWithReuseIdentifier: BannerViewCell.reuseIdentifier)

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
        self.title = "홈"
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(collectionView)
        setupConstraints()

        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, element in
                if let banner = element as? [Banner],
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: BannerViewCell.reuseIdentifier,
                        for: indexPath
                    ) as? BannerViewCell {
                    cell.configure(banner)
                    return cell
                }
                
                if let product = element as? Product,
                   let cell = collectionView.dequeueReusableCell(
                       withReuseIdentifier: ProductCell.reuseIdentifier,
                       for: indexPath
                   ) as? ProductCell {
                    cell.configure(product)
                    cell.delegate = self
                   return cell
               }
                return UICollectionViewCell()
            })
        snapshot.appendSections([.banner, .goods])
        dataSource.apply(snapshot)
//        snapshot.moveSection(.goods, afterSection: .banner)
        
        services.makeBannerUseCase()
            .banners()
            .bind { [weak self] in
                self?.snapshot.appendItems([$0], toSection: .banner)
                self?.dataSource.apply(self!.snapshot, animatingDifferences: true)
            }.disposed(by: disposeBag)
        
        services.makeProductUseCase()
            .products()
            .bind { [weak self] in
                self?.snapshot.appendItems($0, toSection: .goods)
                self?.dataSource.apply(self!.snapshot, animatingDifferences: true)
            }.disposed(by: disposeBag)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        services.makeBannerUseCase()
//            .banners()
//            .bind { [weak self] _ in
//                let items = self?.snapshot.itemIdentifiers(inSection: .banner) ?? []
//                self?.snapshot.deleteItems(items)
//                self?.snapshot.appendItems(
//                    [Banner(id: 3, imageURL: ""), Banner(id: 4, imageURL: "") ],
//                    toSection: .banner)
//                self?.dataSource.apply(self!.snapshot, animatingDifferences: true)
//            }.disposed(by: disposeBag)
    }
    
    
    // MARK: Methods
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = CollectionViewSection(rawValue: sectionIndex) else {
                return nil
            }

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),  // group 내 item, width 꽉 채움
                heightDimension: section.itemHeightDimension)   // 동적 높이
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),  // width 꽉 채움
                heightDimension: section.groupHeightDimension)   // 동적 높이
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

// MARK: - ProductCellDelegate

extension HomeViewController: ProductCellDelegate {
    func favoriteButtonDidTapped(_ isFavorite: Bool, id: Int) {
        print("isFavorite: \(isFavorite) id: \(id)")
    }
}

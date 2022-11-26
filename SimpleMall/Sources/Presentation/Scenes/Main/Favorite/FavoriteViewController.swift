//
//  FavoriteViewController.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/24.
//

import Foundation
import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class FavoriteViewController: UIViewController {
    
    // MARK: Properties
    
    private lazy var collectionView: UICollectionView = {
       let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.register(
            ProductCell.self,
            forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        return collectionView
    }()
    
    typealias DataSource = UICollectionViewDiffableDataSource
    private lazy var dataSource: DataSource<Int, Product> = DataSource(
        collectionView: collectionView,
        cellProvider: { [weak self] collectionView, indexPath, element in
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCell.reuseIdentifier,
                for: indexPath
            ) as? ProductCell {
                cell.configure(element)
                cell.favoriteButton.isHidden = true
                cell.delegate = self
                return cell
            } else {
                return UICollectionViewCell()
            }
        }
    )
    
    private var snapshot = NSDiffableDataSourceSnapshot<Int, Product>()
    var disposeBag = DisposeBag()
    
    // MARK: Initializing
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "좋아요"
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
        self.snapshot.deleteAllItems()
        
        let decoder = JSONDecoder()
        guard let data = UserDefaults.Favorite.object(forKey: .products) as? Data,
              let products = try? decoder.decode([Product].self, from: data)
        else { return }
        self.snapshot.appendSections([0])
        self.snapshot.appendItems(products)
        self.dataSource.apply(self.snapshot, animatingDifferences: true)
        
    }
    
    // MARK: Methods
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),  // group 내 item, width 꽉 채움
                heightDimension: .estimated(10))   // 동적 높이
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),  // width 꽉 채움
                heightDimension: .estimated(10))   // 동적 높이
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 1)
            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.orthogonalScrollingBehavior = .none
            return layoutSection
        }
        return layout
    }
}

// MARK: - ProductCellDelegate

extension FavoriteViewController: ProductCellDelegate {
    func favoriteButtonDidTapped(_ isFavorite: Bool, id: Int) {
        print(isFavorite,id)
    }
}

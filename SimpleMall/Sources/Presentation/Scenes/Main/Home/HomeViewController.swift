//
//  HomeViewController.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/24.
//

import Foundation
import UIKit

import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController, View {
    
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
    
    private let refreshControl = UIRefreshControl()
    
    typealias DataSource = UICollectionViewDiffableDataSource
    private lazy var dataSource: DataSource<CollectionViewSection, AnyHashable> = DataSource(
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
        }
    )
    private var snapshot = NSDiffableDataSourceSnapshot<CollectionViewSection, AnyHashable>()
    var disposeBag = DisposeBag()
    
    // MARK: Initializing
    
    init(reactor: HomeViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.title = "홈"
        self.reactor = reactor
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
        
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
    }
    
    // MARK: Methods
    
    func bind(reactor: HomeViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
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
        reactor?.action.onNext(.didTapFavorite(goodsID: id, isFavorite: isFavorite))
    }
}

// MARK: Bind

private extension HomeViewController {
    func bindAction(_ reactor: HomeViewReactor) {
        self.rx.viewDidLoad
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.didScroll
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .map { owner, _ in
                Reactor.Action.pagination(
                    contentHeight: owner.collectionView.contentSize.height,
                    contentOffsetY: owner.collectionView.contentOffset.y,
                    scrollViewHeight: owner.collectionView.frame.size.height)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: HomeViewReactor) {
        reactor.state
            .filter { $0.isRefresh }
            .asObservable()
            .withUnretained(self)
            .bind { owner, state in
                owner.snapshot.deleteAllItems()
                owner.snapshot.appendSections([.banner, .goods])
                owner.snapshot.appendItems([state.banners], toSection: .banner)
                owner.snapshot.appendItems(state.products, toSection: .goods)
                
                owner.dataSource.apply(owner.snapshot, animatingDifferences: true)
                owner.refreshControl.endRefreshing()
            }.disposed(by: disposeBag)
        
        reactor.state
            .filter { !$0.isRefresh }
            .map { $0.products }
            .asObservable()
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, products in
                owner.snapshot.deleteSections([.goods])
                owner.snapshot.appendSections([.goods])
                
                owner.snapshot.appendItems(products, toSection: .goods)
                owner.dataSource.apply(owner.snapshot, animatingDifferences: true)
            }.disposed(by: disposeBag)
    }
}

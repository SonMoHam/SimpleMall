//
//  BannerViewCell.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/26.
//

import Foundation
import UIKit

import RxSwift

/// 배너 스크롤에 영향 없는 banner pager 구현 위한 Banner Container
final class BannerViewCell: UICollectionViewCell {
    
    // MARK: Constants
    
    private struct Metric {
        static let pagerViewHeight: CGFloat = 30
        static let pagerViewMargin: CGFloat = 20
    }
    
    // MARK: Properties
    
    let pagerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.layer.cornerRadius = Metric.pagerViewHeight / 2
        return view
    }()
    
    let pagerLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = AppStyles.Font.medium
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout())
        collectionView.isScrollEnabled = false
        collectionView.register(
            BannerCell.self,
            forCellWithReuseIdentifier: BannerCell.reuseIdentifier)
        return collectionView
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Banner>!
    var snapshot = NSDiffableDataSourceSnapshot<Int, Banner>()
    
    private let currentPage = PublishSubject<Int>()
    
    private var disposeBag = DisposeBag()
    
    // MARK: Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
        self.addSubview(pagerView)
        pagerView.addSubview(pagerLabel)
        setupConstraints()
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, element in
                if let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BannerCell.reuseIdentifier,
                    for: indexPath
                ) as? BannerCell {
                    cell.configure(element)
                    return cell
                }
                return UICollectionViewCell()
            })
        snapshot.appendSections([0])
        dataSource.apply(snapshot)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setupConstraints() {
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.pagerView.snp.makeConstraints { make in
            make.height.equalTo(Metric.pagerViewHeight)
            make.width.equalTo(Metric.pagerViewHeight*2)
            make.bottom.right.equalToSuperview().inset(Metric.pagerViewMargin)
        }
        self.pagerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(_ banners: [Banner]) {
        disposeBag = DisposeBag()
        let target = self.snapshot.itemIdentifiers(inSection: 0)
        self.snapshot.deleteItems(target)
        self.snapshot.appendItems(banners)
        dataSource.apply(snapshot)
        pagerLabel.text = "1/\(banners.count)"
        currentPage
            .do { print("currentPage: \($0)")}
            .map { "\($0+1)/\(banners.count)" }
            .bind(to: pagerLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout() { sectionIndex, _ in
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 1)
                
                let layoutSection = NSCollectionLayoutSection(group: group)
                layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
                
                layoutSection
                    .visibleItemsInvalidationHandler = { [weak self] _, offset, env in
//                        print(offset)
//                        print("environment Width :", env.container.contentSize.width)
//                        print("environment Height :", env.container.contentSize.height)
                        let bannerIndex = Int(
                            max(0, round(offset.x / env.container.contentSize.width))
                        )
//                        print(bannerIndex)
                        // horizontal 스크롤이 끝나 offsetX % envWidth 가 0일 때만 onNext
                        if offset.x == env.container.contentSize.width * CGFloat(bannerIndex) {
                            self?.currentPage.onNext(bannerIndex)
                        }
                    }
                return layoutSection
            } else {
                return nil
            }
        }
        return layout
    }
}

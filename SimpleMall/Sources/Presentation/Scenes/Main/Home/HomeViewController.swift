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
            collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .gray
        return collectionView
    }()
    
    // MARK: Initializing
    
    init() {
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
    }
    
    // MARK: Methods
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
}

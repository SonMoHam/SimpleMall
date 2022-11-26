//
//  FavoriteViewController.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/24.
//

import Foundation
import UIKit

final class FavoriteViewController: UIViewController {
    
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
        self.view.backgroundColor = .yellow
    }
}

//
//  ProductCell.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/25.
//

import Foundation
import UIKit

import SnapKit

final class ProductCell: UICollectionViewCell {
    let container: UIView = UIView()
    let imageView: UIImageView = UIImageView()
    let detailContainer: UIView = UIView()
    let priceLabel: UILabel = UILabel()
    let descriptionLabel: UILabel = UILabel()
    let sellCountLabel: UILabel = UILabel()
    let isNewLabel: UILabel = {
       let label = UILabel()
        label.text = "NEW"
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(container)
        container.addSubview(isNewLabel)
        container.backgroundColor = .yellow
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(100)
        }
        
        isNewLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

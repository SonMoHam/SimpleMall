//
//  BannerCell.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/25.
//

import Foundation
import UIKit

import SnapKit
import SDWebImage

final class BannerCell: UICollectionViewCell {
    let imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        imageView.image = UIImage(systemName: "heart")
        self.backgroundColor = .red
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let imageHeight = self.bounds.width * 2 / 3
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(imageHeight)
        }
    }
    
    func configure(_ banner: Banner) {
        imageView.sd_setImage(with: URL(string: banner.imageURL))
    }
}

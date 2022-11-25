//
//  ProductCell.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/25.
//

import Foundation
import UIKit

import RxSwift
import SnapKit
import SDWebImage

final class ProductCell: UICollectionViewCell {
    
    // MARK: Constants
    
    private struct Metric {
        static let imageCornerRadius: CGFloat = 5
        static let favoriteButtonSize: CGFloat = 30
        static let favoriteButtonMargin: CGFloat = 3
        static let sellCountSpacing: CGFloat = 5
        static let isNewBorderWidth: CGFloat = 1

        static let padding: CGFloat = 15
        static let contentTopMargin: CGFloat = 10
        static let detailLeftMargin: CGFloat = 10
        static let priceTopMargin: CGFloat = 3
        static let descriptionTopMargin: CGFloat = 10
        static let sellCountTopMargin: CGFloat = 20
        static let isNewWidth: CGFloat = 40
    }
    
    private struct Font {
        static let title = UIFont.boldSystemFont(ofSize: 16)
        static let medium = UIFont.systemFont(ofSize: 14)
        static let small = UIFont.systemFont(ofSize: 12)
    }
    
    private struct Color {
        static let textPrimary = UIColor.black
        static let textSecondary = UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1)
        static let customPink = UIColor(red: 236/255, green: 94/255, blue: 101/255, alpha: 1)
    }
    
    private struct Image {
        static let heart = UIImage(systemName: "heart")
        static let heartFill = UIImage(systemName: "heart.fill")
    }
    
    // MARK: Properties
    
    weak var delegate: ProductCellDelegate?
    
    let container: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.layer.cornerRadius = Metric.imageCornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var isFavorite: Bool = false {
        didSet {
            let image = isFavorite ? Image.heartFill : Image.heart
            let tint = isFavorite ? Color.customPink : .white
            favoriteButton.tintColor = tint
            favoriteButton.setImage(image, for: .normal)
        }
    }
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let detailContainer: UIView = UIView()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Font.title
        return label
    }()
    
    let descriptionLabel: UILabel = {
       let label = UILabel()
        label.font = Font.medium
        label.numberOfLines = 0
        label.textColor = Color.textSecondary
        return label
    }()
    
    let sellCountHorizontalContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = Metric.sellCountSpacing
        return stackView
    }()
    
    let sellCountLabel: UILabel = {
       let label = UILabel()
        label.font = Font.small
        label.textColor = Color.textSecondary
        return label
    }()
    
    let isNewLabel: UILabel = {
       let label = UILabel()
        label.text = "NEW"
        label.font = Font.small
        label.textColor = Color.textSecondary
        label.layer.borderWidth = Metric.isNewBorderWidth
        label.layer.borderColor = Color.textSecondary.cgColor
        label.textAlignment = .center
        return label
    }()
    private var _productID: Int?
    private var disposeBag = DisposeBag()
    
    // MARK: Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(container)
        container.addSubview(imageView)
        container.addSubview(favoriteButton)
        container.addSubview(detailContainer)
        
        detailContainer.addSubview(priceLabel)
        detailContainer.addSubview(descriptionLabel)
        detailContainer.addSubview(sellCountHorizontalContainer)
        
        sellCountHorizontalContainer.addArrangedSubview(isNewLabel)
        sellCountHorizontalContainer.addArrangedSubview(sellCountLabel)
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setupConstraints() {
        let imageSize = self.bounds.width / 4
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Metric.padding)
        }

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metric.contentTopMargin)
            make.left.equalToSuperview()
            make.size.equalTo(imageSize)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.right.equalTo(imageView).inset(Metric.favoriteButtonMargin)
            make.size.equalTo(Metric.favoriteButtonSize)
        }
        
        detailContainer.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview().inset(Metric.contentTopMargin)
            make.left.equalTo(imageView.snp.right).offset(Metric.detailLeftMargin)
            make.height.greaterThanOrEqualTo(imageSize)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metric.priceTopMargin)
            make.left.right.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(Metric.descriptionTopMargin)
            make.left.right.equalToSuperview()
        }
        
        sellCountHorizontalContainer.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Metric.sellCountTopMargin)
            make.bottom.left.right.equalToSuperview()
        }
        
        isNewLabel.snp.makeConstraints { make in
            make.width.equalTo(Metric.isNewWidth)
        }
    }
    
    func configure(_ product: Product, isFavorite: Bool = false) {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        disposeBag = DisposeBag()
        imageView.sd_setImage(with: URL(string: product.imageURL))
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray6.cgColor

        let discount = round((1.0 - Double(product.price) / Double(product.actualPrice)) * 100)
        let discountString = "\(Int(discount))%"
        
        let priceString = nf.string(from: NSNumber(value: product.price)) ?? "\(product.price)"
        
        if discount > 0 {
            let priceText = "\(discountString) \(priceString)"
            priceLabel.attributedText = NSMutableAttributedString(string: priceText)
                .color(Color.customPink, string: discountString)
        } else {
            priceLabel.text = priceString
        }
        descriptionLabel.text = product.name
        isNewLabel.isHidden = !product.isNew
        
        if product.sellCount >= 10 {
            let sellCountString = nf.string(
                from: NSNumber(value: product.sellCount)
            ) ?? "\(product.sellCount)"
            sellCountLabel.text = "\(sellCountString)개 구매중"
        }

        self.isFavorite = isFavorite
        self._productID = product.id
        favoriteButton.rx
            .tap
            .bind { [weak self] _ in
                let newValue = !(self?.isFavorite ?? true)
                self?.isFavorite = newValue
                if let id = self?._productID {
                    self?.delegate?.favoriteButtonDidTapped(newValue, id: id)
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: - ProductCellDelegate

protocol ProductCellDelegate: AnyObject {
    func favoriteButtonDidTapped(_ isFavorite: Bool, id: Int)
}

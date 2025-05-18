//
//  BookCell.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/12/25.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class BookCell: UICollectionViewCell {

    static let id = "BookCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let horizontalItemsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        [thumbnailImageView, horizontalItemsStack]
            .forEach {contentView.addSubview($0)}

        [titleLabel, authorLabel, priceLabel]
            .forEach{horizontalItemsStack.addArrangedSubview($0)}

        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor


        titleLabel.snp.makeConstraints {
            $0.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-8)
        }

        horizontalItemsStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }

        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configure(with book: BookDocument, thumbnailOnly: Bool) {
        if let url = URL(string: book.thumbnail) {
            thumbnailImageView.kf.setImage(with: url)
        } else {
            thumbnailImageView.image = nil
        }

        if thumbnailOnly {
            thumbnailImageView.isHidden = false
            horizontalItemsStack.isHidden = true
            contentView.bringSubviewToFront(thumbnailImageView)
        } else {
            thumbnailImageView.isHidden = true
            horizontalItemsStack.isHidden = false

            titleLabel.text = book.title
            authorLabel.text = book.authors.first ?? "작가 없음"
            let price = NumberFormatter.localizedString(from: NSNumber(value: book.price), number: .decimal)
            priceLabel.text = "\(price)원"
        }
    }

}

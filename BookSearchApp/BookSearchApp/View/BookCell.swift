//
//  BookCell.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/12/25.
//

import Foundation
import UIKit
import SnapKit

class BookCell: UICollectionViewCell {

    static let id = "BookCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        //잘리면 안되게 만드는 속성
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let horizontalItemsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        contentView.addSubview(horizontalItemsStack)

        horizontalItemsStack.addArrangedSubview(titleLabel)
        horizontalItemsStack.addArrangedSubview(authorLabel)
        horizontalItemsStack.addArrangedSubview(priceLabel)

        [titleLabel, authorLabel, priceLabel]
            .forEach{horizontalItemsStack.addArrangedSubview($0)}

        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor

        horizontalItemsStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
    }

    func configure(with book: BookDocument) {
        titleLabel.text = book.title
        //작가 없음 출력안됨
        authorLabel.text = book.authors.first ?? "작가 없음"
        priceLabel.text = "\(book.price)원"
    }
}

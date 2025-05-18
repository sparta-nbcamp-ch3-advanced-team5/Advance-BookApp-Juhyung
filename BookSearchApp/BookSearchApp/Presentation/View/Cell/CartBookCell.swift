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

class CartBookCell: UITableViewCell {

    static let id = "CartBookCell"

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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        contentView.addSubview(horizontalItemsStack)

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
    }

    func configure(with book: BooksEntity) {
        titleLabel.text = book.title ?? "제목 없음"
        //작가 없음 출력안됨
        authorLabel.text = book.authors?.isEmpty == false ? book.authors : "작가 없음"

        let price = NumberFormatter.localizedString(from: NSNumber(value: book.price), number: .decimal)
        priceLabel.text = "\(price)원"
    }
}

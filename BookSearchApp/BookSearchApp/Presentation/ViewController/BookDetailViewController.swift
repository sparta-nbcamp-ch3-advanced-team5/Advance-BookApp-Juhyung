//
//  BookDetailView.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/12/25.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class BookDetailViewController: UIViewController {

    var bookDocument: BookDocument?


    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.4
        return imageView
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    private let scrollView = UIScrollView()
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        return stackView
    }()


    private let floatingView = UIView()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .gray
        config.cornerStyle = .medium
        config.image = UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.configuration = config
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
                    button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()

    private lazy var cartButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .darkGray
        config.cornerStyle = .medium
        button.setTitle("담기", for: .normal)
        button.tintColor = .white
        button.configuration = config
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
                    button.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
        return button
    }()

    private let bottomSpacer = UIView()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        configureView()
    }

    private func setupLayout() {

        [scrollView,floatingView]
            .forEach {view.addSubview($0)}

        scrollView.addSubview(contentStackView)

        [titleLabel, authorLabel, imageView, priceLabel, descriptionLabel]
            .forEach{contentStackView.addArrangedSubview($0)}

        [closeButton, cartButton]
            .forEach {floatingView.addSubview($0)}

        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(20)

        }

        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(floatingView.snp.top).offset(-12)
        }

        imageView.snp.makeConstraints {
            $0.height.equalTo(350)
        }

        closeButton.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(cartButton.snp.width).multipliedBy(0.3)
        }

        cartButton.snp.makeConstraints {
            $0.leading.equalTo(closeButton.snp.trailing).offset(12)
            $0.trailing.top.bottom.equalToSuperview()
        }

        floatingView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.height.equalTo(50)
        }
    }

    private func configureView() {
        guard let book = bookDocument else { return }

        titleLabel.text = book.title
        authorLabel.text = book.authors.first

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedPrice = formatter.string(from: NSNumber(value: book.price)) ?? "\(book.price)"
        priceLabel.text = "\(formattedPrice)원"
        descriptionLabel.text = book.contents
        imageView.kf.setImage(with: URL(string: book.thumbnail))
    }

    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func cartTapped() {
        guard let book = bookDocument else { return }


        CoreDataManager.shared.saveingBook(book)
        dismiss(animated: true, completion: nil)
    }


}

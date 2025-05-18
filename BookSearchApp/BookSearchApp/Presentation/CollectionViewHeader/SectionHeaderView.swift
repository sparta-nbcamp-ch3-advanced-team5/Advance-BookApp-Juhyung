//
//  File.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/12/25.
//

import Foundation
import UIKit
import SnapKit

class SectionHeaderView: UICollectionReusableView {

    static let id = "SectionHeaderView"

    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        configureUI()

    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setUpUI() {
        addSubview(label)
    }

    private func configureUI() {
        label.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(8)
        }
    }

    func configure(title: String) {
        label.text = title
    }
}

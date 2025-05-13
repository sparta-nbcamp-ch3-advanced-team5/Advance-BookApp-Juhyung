//
//  SearchViewController.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/11/25.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class SearchViewController: UIViewController {

    private let searchBar = UISearchBar()
    private var books: [BookDocument] = []
    private let disposeBag = DisposeBag()


    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.id)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchBar()
        setupLayout()

        collectionView.reloadData()
        searchBar.becomeFirstResponder()
    }

    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2.0/8.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(0.4)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]

        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension SearchViewController: UISearchBarDelegate {
    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.placeholder = "책 제목을 검색하세요"
        searchBar.delegate = self

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }

        NetworkManager.shared.searchBooks(query: query)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] books in
                    guard let self = self else { return }
                    self.books = books
                    self.collectionView.reloadData()
                    searchBar.resignFirstResponder()
                },
                onFailure: { error in
                    print("error: \(error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.id,
            for: indexPath
        ) as! SectionHeaderView

        header.configure(title: "검색 결과")
        return header
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        books.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.id, for: indexPath) as? BookCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: books[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = BookDetailViewController()
        detailVC.bookDocument = books[indexPath.row]
        detailVC.modalPresentationStyle = .automatic
        present(detailVC, animated: true, completion: nil)
    }

}



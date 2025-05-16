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
    private var recentlyViewedBooks: [BookDocument] = []


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
        loadRecentlyViewedBooks()
        collectionView.reloadData()
        searchBar.becomeFirstResponder()
    }

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

    private func setupLayout() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(100),
                    heightDimension: .absolute(150)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(120),
                    heightDimension: .absolute(150)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                group.interItemSpacing = .fixed(10)

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
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

                return section
            } else {
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

                return section
            }
        }
    }

    private func loadRecentlyViewedBooks() {
        recentlyViewedBooks = CoreDataManager.shared.fetchRecentViewedBooks().map {
            BookDocument(title: $0.title, authors: $0.authors, price: $0.price, thumbnail: $0.thumbnail, contents: $0.contents, isbn: $0.isbn)
        }
        collectionView.reloadSections(IndexSet(integer: 0))
    }

}

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }

        NetworkManager.shared.searchBooks(query: query)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] books in
                    guard let self = self else { return }
                    self.books = books
                    self.collectionView.reloadSections(IndexSet(integer: 1))
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


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? recentlyViewedBooks.count : books.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.id, for: indexPath) as? BookCell else {
            return UICollectionViewCell()
        }

        let isThumbnailOnly = indexPath.section == 0
        let book = isThumbnailOnly ? recentlyViewedBooks[indexPath.item] : books[indexPath.item]
        cell.configure(with: book, thumbnailOnly: isThumbnailOnly)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.id,
            for: indexPath
        ) as! SectionHeaderView

        let title = indexPath.section == 0 ? "최근 본 책" : "검색 결과"
        header.configure(title: title)
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = indexPath.section == 0 ? recentlyViewedBooks[indexPath.item] : books[indexPath.item]

        let detailVC = BookDetailViewController()
        detailVC.bookDocument = book
        detailVC.modalPresentationStyle = .automatic
        present(detailVC, animated: true, completion: nil)

        // ✅ 중복 방지 및 갱신
        if let index = recentlyViewedBooks.firstIndex(where: { $0.isbn == book.isbn }) {
            recentlyViewedBooks.remove(at: index)
        }
        recentlyViewedBooks.insert(book, at: 0)
        if recentlyViewedBooks.count > 10 {
            recentlyViewedBooks.removeLast()
        }

        // ✅ 화면 반영 먼저
        collectionView.reloadSections(IndexSet(integer: 0))

        // ✅ CoreData는 백그라운드처럼 쓰기
        CoreDataManager.shared.addRecentBook(book)
    }


}

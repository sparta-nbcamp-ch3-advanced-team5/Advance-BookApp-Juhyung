//
//  CartViewModel.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/18/25.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class CartViewModel {

    //초깃값 발행
    let BooksRelay = BehaviorRelay<[BooksEntity]>(value: [])


    //삭제 액션 구현
    let deleteAllTapped = PublishRelay<Void>()
    let deleteSwipeItem = PublishRelay<BooksEntity>()

    private let disposeBag = DisposeBag()

    init() {
        bindAction()
        fetchBooks()
    }

    private func bindAction() {
        deleteAllTapped
            .subscribe(onNext: { [weak self] in
                CoreDataManager.shared.deleteAllBooks(type: BooksEntity.self)
                self?.fetchBooks()
            }).disposed(by: disposeBag)

        deleteSwipeItem
            .subscribe(onNext: { [weak self] book in
                CoreDataManager.shared.delete(object: book)
                self?.fetchBooks()
            }).disposed(by: disposeBag)
    }

    func fetchBooks() {
        let fetchItem = CoreDataManager.shared.fetchSavedBooks()
        BooksRelay.accept(fetchItem)
    }
}

//
//  SearchViewModel.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/17/25.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {

    //사용자 input
    let query = PublishRelay<String>()

    let bookRelay = BehaviorRelay<[BookDocument]>(value: [])
    let errorMessage = PublishRelay<String>()
    let isLoding = BehaviorRelay<Bool>(value: false)

    private let disposebag = DisposeBag()


    init() {
        bind()
    }

    private func bind() {
        query
            .distinctUntilChanged()
            .filter{ !$0.isEmpty }
            .flatMapLatest { /*query -> Single<[BookDocument]>*/query in
                self.isLoding.accept(true)
                return NetworkManager.shared.searchBooks(query: query)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] books in
                    print("책 들어옴 \(books)")
                    self?.bookRelay.accept(books)
                    self?.isLoding.accept(false)
                },
                onError: {[weak self] error in
                    print("에러인 상황 \(error)")
                    self?.errorMessage.accept(error.localizedDescription)
                    self?.isLoding.accept(false)
                }
            ).disposed(by: disposebag)
    }
}



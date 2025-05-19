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
    let NextPageCreater = PublishRelay<Void>()


    let bookRelay = BehaviorRelay<[BookDocument]>(value: [])
    let errorMessage = PublishRelay<String>()
    let isLoading = BehaviorRelay<Bool>(value: false)

    private var currentPage = 1
    private var isEnd = false
    private var latestQuery = ""

    private let disposebag = DisposeBag()


    init() {
        bind()
    }

    private func bind() {
        query
            .distinctUntilChanged()
            .filter{ !$0.isEmpty }
            .flatMapLatest { /*query -> Single<[BookDocument]>*/query in
                self.isLoading.accept(true)
                self.currentPage = 1
                self.isEnd = false
                self.latestQuery = query
                return NetworkManager.shared.searchBooks(query: query)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] books in
                    self?.bookRelay.accept(books)
                    self?.isLoading.accept(false)
                },
                onError: {[weak self] error in
                    self?.errorMessage.accept(error.localizedDescription)
                    self?.isLoading.accept(false)
                }
            ).disposed(by: disposebag)

        NextPageCreater
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.isLoading.accept(true)
                self?.currentPage += 1
            })
            .flatMapLatest { [weak self] _ -> Observable<Result<([BookDocument], Bool), Error>> in
                guard let self = self else { return .empty() }
                return NetworkManager.shared.showNextPage(query: self.latestQuery, page: self.currentPage)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.isLoading.accept(false)

                switch result {
                case .success(let (newBooks, isEnd)):
                    self.bookRelay.accept(self.bookRelay.value + newBooks)
                    self.isEnd = isEnd
                case .failure(let error):
                    self.errorMessage.accept(error.localizedDescription)
                }
            })
            .disposed(by: disposebag)

    }
}




//
//  Network.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/12/25.
//

import Foundation
import Alamofire
import RxSwift

enum KakaoDB {
    case search
}

class NetworkManager {
    //이전 프로젝트에서는 욱현님이 network를 잘 만들어놓으셔서 되게 쓰기 편했음;;
    let apiKey = Bundle.main.infoDictionary?["APIKey"] as! String
    static let shared = NetworkManager()

    func searchBooks(query: String) -> Single<[BookDocument]> {

        let url = "https://dapi.kakao.com/v3/search/book?query=\(query)"

        let headers: HTTPHeaders = ["Authorization": "KakaoAK \(apiKey)"]

        let parameters: [String: Any] = [
            "query": query
        ]

        return Single.create { single in
            AF.request(url, parameters: parameters, headers: headers)
                .validate()
                .responseDecodable(of: ApiResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        single(.success(result.documents))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }

    func showNextPage(query: String, page: Int) -> Observable<Result<([BookDocument], Bool), Error>> {
        let url = "https://dapi.kakao.com/v3/search/book"
        let parameters: [String: Any] = [
            "query": query,
            "page": page
        ]
        let headers: HTTPHeaders = ["Authorization": "KakaoAK \(apiKey)"]

        return Observable.create { observer in
            AF.request(url, parameters: parameters, headers: headers)
                .validate()
                .responseDecodable(of: ApiResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        observer.onNext(.success((result.documents, result.meta.isEnd)))
                    case .failure(let error):
                        observer.onNext(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
}



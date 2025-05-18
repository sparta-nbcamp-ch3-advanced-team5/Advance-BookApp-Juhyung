
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

    
    static let shared = NetworkManager()

    func searchBooks(query: String) -> Single<[BookDocument]> {

        let url = "https://dapi.kakao.com/v3/search/book?query=\(query)"
        let apiKey = Bundle.main.infoDictionary?["APIKey"] as! String

        let headers: HTTPHeaders = ["Authorization": "KakaoAK \(apiKey)"]

        return Single.create { single in
            AF.request(url, headers: headers)
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
}



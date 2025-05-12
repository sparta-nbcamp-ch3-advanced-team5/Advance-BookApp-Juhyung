//
//  Network.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/12/25.
//

import Foundation

class NetworkManager {
    func searchBooks(query: String, completion: @escaping ([BookDocument]) -> Void) {

        let apiKey = "f80a80c44f07dbdb1050a27b0b7f9999"

        guard let url = URL(string: "https://dapi.kakao.com/v3/search/book?query=\(query)&size=20&page=1") else {
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion([])
                return
            }

            do {
                let response = try JSONDecoder().decode(ApiResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.documents)
                }
            } catch {
                print("실패: \(error.localizedDescription)")
                completion([])
            }
        }.resume()
    }
}

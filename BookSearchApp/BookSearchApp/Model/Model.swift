//
//  File.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/12/25.
//

import Foundation

//codable 과 decodable?
struct ApiResponse: Codable {
    let documents: [BookDocument]
}

struct BookDocument: Codable {
    let title: String
    let authors: [String]
    let price: Int
    let thumbnail: String
    //url    String    도서 상세 URL 로 바꿔야하나 고려
    let contents: String

}

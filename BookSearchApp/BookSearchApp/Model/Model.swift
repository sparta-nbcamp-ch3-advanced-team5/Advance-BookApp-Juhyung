//
//  File.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/12/25.
//

import Foundation

struct ApiResponse: Codable {
    let documents: [BookDocument]
}

struct BookDocument: Codable {
    let title: String
    let authors: [String]
    let price: Int
    let thumbnail: String
    let contents: String
    let isbn: String

}

extension BookDocument {
    init(from entity: Books) {
        self.title = entity.title ?? ""
        self.authors = entity.authors?.components(separatedBy: ",") ?? []
        self.price = Int(entity.price)
        self.thumbnail = entity.thumbnail ?? ""
        self.contents = entity.contents ?? ""
        self.isbn = entity.isbn ?? ""

    }
}


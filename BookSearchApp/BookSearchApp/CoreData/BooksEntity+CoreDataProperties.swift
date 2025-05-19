//
//  BooksEntity+CoreDataProperties.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/18/25.
//
//

import Foundation
import CoreData


extension BooksEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BooksEntity> {
        return NSFetchRequest<BooksEntity>(entityName: "BooksEntity")
    }

    @NSManaged public var authors: String?
    @NSManaged public var contents: String?
    @NSManaged public var date: Date?
    @NSManaged public var isbn: String?
    @NSManaged public var price: Int64
    @NSManaged public var thumbnail: String?
    @NSManaged public var title: String?
    @NSManaged public var recent: RecentViewEntity?
    @NSManaged public var saved: SavedBooksEntity?

}

extension BooksEntity : Identifiable {

}

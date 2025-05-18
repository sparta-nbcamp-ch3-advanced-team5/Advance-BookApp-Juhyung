//
//  Books+CoreDataProperties.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/18/25.
//
//

import Foundation
import CoreData


extension Books {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Books> {
        return NSFetchRequest<Books>(entityName: "Books")
    }

    @NSManaged public var authors: String?
    @NSManaged public var contents: String?
    @NSManaged public var date: Date?
    @NSManaged public var isbn: String?
    @NSManaged public var price: Int64
    @NSManaged public var thumbnail: String?
    @NSManaged public var title: String?
    @NSManaged public var recent: RecentView?
    @NSManaged public var saved: SavedBooks?

}

extension Books : Identifiable {

}

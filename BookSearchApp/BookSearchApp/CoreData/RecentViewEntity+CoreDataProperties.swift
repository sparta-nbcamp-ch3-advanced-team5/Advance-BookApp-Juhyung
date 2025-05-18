//
//  RecentViewEntity+CoreDataProperties.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/18/25.
//
//

import Foundation
import CoreData


extension RecentViewEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentViewEntity> {
        return NSFetchRequest<RecentViewEntity>(entityName: "RecentViewEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var book: BooksEntity?

}

extension RecentViewEntity : Identifiable {

}

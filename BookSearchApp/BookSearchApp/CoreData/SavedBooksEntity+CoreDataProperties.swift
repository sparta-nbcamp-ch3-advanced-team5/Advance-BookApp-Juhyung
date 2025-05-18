//
//  SavedBooksEntity+CoreDataProperties.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/18/25.
//
//

import Foundation
import CoreData


extension SavedBooksEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedBooksEntity> {
        return NSFetchRequest<SavedBooksEntity>(entityName: "SavedBooksEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var book: BooksEntity?

}

extension SavedBooksEntity : Identifiable {

}

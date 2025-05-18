//
//  SavedBooks+CoreDataProperties.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/18/25.
//
//

import Foundation
import CoreData


extension SavedBooks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedBooks> {
        return NSFetchRequest<SavedBooks>(entityName: "SavedBooks")
    }

    @NSManaged public var date: Date?
    @NSManaged public var book: Books?

}

extension SavedBooks : Identifiable {

}

//
//  RecentView+CoreDataProperties.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/18/25.
//
//

import Foundation
import CoreData


extension RecentView {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentView> {
        return NSFetchRequest<RecentView>(entityName: "RecentView")
    }

    @NSManaged public var date: Date?
    @NSManaged public var book: Books?

}

extension RecentView : Identifiable {

}

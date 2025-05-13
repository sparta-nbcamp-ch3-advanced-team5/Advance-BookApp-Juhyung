//
//  CoreDataManager.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/13/25.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "BooksCoreData")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData Load Error: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }

    func fetchBooks() -> [Books] {
        let request: NSFetchRequest<Books> = Books.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("error: \(error.localizedDescription)")
            return []
        }
    }


    func delete(object: NSManagedObject) {
        self.context.delete(object)
        do {
            try context.save()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }


    func deleteAllBooks<T: NSManagedObject>(type: T.Type) {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }

}

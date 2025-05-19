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
        persistentContainer = NSPersistentContainer(name: "BookSearchApp")
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

    func fetchBooks() -> [BooksEntity] {
        let request: NSFetchRequest<BooksEntity> = BooksEntity.fetchRequest()
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
            //NSBatchDeleteRequest에서는 영구 저장소에 직접 접근하여 삭제하는 방식이라 func save가 필요없다
            //서동환님 리뷰
//            saveContext()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }

    func fetchRecentViewedBooks() -> [BookDocument] {
        let request: NSFetchRequest<BooksEntity> = BooksEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = 10

        let results = (try? context.fetch(request)) ?? []

        return results.compactMap { $0 }.map { BookDocument(from: $0) }
    }

    func addRecentBook(_ document: BookDocument) {
        let book = getOrCreateBook(document)

        if let oldView = book.recent {
            context.delete(oldView)
        }

        let recent = RecentViewEntity(context: context)
        recent.date = Date()
        recent.book = book
        book.recent = recent

        trimRecentViews(10)
        saveContext()
    }



    func fetchSavedBooks() -> [BooksEntity] {
            let request: NSFetchRequest<SavedBooksEntity> = SavedBooksEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            let results = (try? context.fetch(request)) ?? []
            return results.compactMap { $0.book }
        }

    func saveingBook(_ document: BookDocument) {
        let book = getOrCreateBook(document)

        if let saved = book.saved {
            context.delete(saved)
            //연결 끊기
            book.recent = nil
        } else {
            let saved = SavedBooksEntity(context: context)
            saved.date = Date()
            saved.book = book
            book.saved = saved
        }

        saveContext()
    }

    func getOrCreateBook(_ document: BookDocument) -> BooksEntity {
        let request: NSFetchRequest<BooksEntity> = BooksEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isbn == %@", document.isbn)

        let fetchItem = try? context.fetch(request)
        let newBook: BooksEntity
        if let itemExist = fetchItem?.first {
            newBook = itemExist
        } else {
            newBook = BooksEntity(context: context)
        }

        newBook.title = document.title
        newBook.thumbnail = document.thumbnail
        newBook.isbn = document.isbn
        newBook.date = Date()
        newBook.authors = document.authors.first
        newBook.price = Int64(document.price)
        newBook.contents = document.contents


        return newBook
    }

    func  trimRecentViews(_ limit: Int) {
        let request: NSFetchRequest<RecentViewEntity> = RecentViewEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]


        do {
            let fetchBooks = try context.fetch(request)

            if fetchBooks.count > limit {
                let excessRecents = fetchBooks.suffix(from: limit)

                for recent in excessRecents {
                    //여기 관계를 끊어야한다는 게 잘 이해가 안간다
                    if let linkedBook = recent.book {
                        linkedBook.recent = nil
                    }

                    context.delete(recent)
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

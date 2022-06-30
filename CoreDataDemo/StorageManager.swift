//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Игорь Богданов on 16.06.2022.
//

import Foundation
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let context: NSManagedObjectContext
    
    private init() {
        context = persistentContainer.viewContext
    }
    
    func fetchData(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let tasks = try context.fetch(fetchRequest)
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension StorageManager {
   
    func save(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: context)
        task.title = taskName
        completion(task)
        saveContext()
    }
    
    func edit(_ task: Task, editedName: String) {
        task.title = editedName
        saveContext()
    }
    
    func delete(_ task: Task) {
        context.delete(task)
        saveContext()
    }
}


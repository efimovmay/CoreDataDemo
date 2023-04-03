//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Aleksey Efimov on 01.04.2023.
//

import UIKit
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchTask() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskList = try persistentContainer.viewContext.fetch(fetchRequest)
            return taskList
        } catch {
            print("Failed to fetch data", error)
            return []
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
    
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(newTask: String) -> Task {
        let task = persistentContainer.viewContext
        task.name = newTask
        
        if task.hasChanges {
            do {
                try task.save()
            } catch let error {
               print(error)
            }
        }
        let newTask = Task(context: task)
        return newTask
    }
    
    func delete(task: Task) {
        persistentContainer.viewContext.delete(task)
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    func update(task: Task, newName: String) {
        task.name = newName
        
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    init() {}
}

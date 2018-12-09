//
//  CoreDataProvider.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/4.
//  Copyright © 2018年 laalee. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataProvider {

    var category: CategoryMO!

    var task: TaskMO!

    let persistentContainer: NSPersistentContainer!

    init(container: NSPersistentContainer) {

        self.persistentContainer = container

        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    convenience init() {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {

            fatalError("Can not get shared app delegate")
        }

        self.init(container: appDelegate.persistentContainer)
    }

    lazy var backgroundContext: NSManagedObjectContext = {

        return self.persistentContainer.newBackgroundContext()
    }()

    func addCategory(id: Int, title: String, color: UIColor) {

        self.category = CategoryMO(context: persistentContainer.viewContext)

        self.category.id = Int64(id)

        self.category.title = title

        self.category.color = color

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

            appDelegate.saveContext()
        }
    }

    func addTask(task: Task) {

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

            self.task = TaskMO(context: persistentContainer.viewContext)

            self.task.title = task.title

            self.task.date = task.date as NSObject

            self.task.time = task.time

            self.task.note = task.note

            self.task.category = task.category

            if let startDate = task.startDate as NSObject? {

                self.task.startDate = startDate
            }

            if let endDate = task.endDate as NSObject? {

                self.task.endDate = endDate
            }

            if let consecutiveStatus = task.consecutiveStatus {

                self.task.consecutiveStatus = Int64(consecutiveStatus)
            }

            if let consecutiveId = task.consecutiveId {

                self.task.consecutiveId = Int64(consecutiveId)
            }

            if let consecutiveDay = task.consecutiveDay {

                self.task.consecutiveDay = Int64(consecutiveDay)
            }

            appDelegate.saveContext()
        }
    }

    func updateCategory(objectID: NSManagedObjectID, title: String, color: UIColor) {

        guard let object = backgroundContext.object(with: objectID) as? CategoryMO else { return }

        object.title = title

        object.color = color

        save()
    }

    func deleteObject(objectID: NSManagedObjectID) {

        let object = backgroundContext.object(with: objectID)

        backgroundContext.delete(object)

        save()
    }

    func save() {

        if backgroundContext.hasChanges {

            do {

                try backgroundContext.save()

            } catch {

                print("Save error \(error)")
            }
        }
    }

    func fetchTask(byCategory category: CategoryMO, date: Date) -> [TaskMO] {

        let request: NSFetchRequest<TaskMO> = TaskMO.fetchRequest()

        let categoryKeyPredicate = NSPredicate(format: "category == %@", category)

        let dateKeyPredicate = NSPredicate(format: "date == %@", date as CVarArg)

        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [categoryKeyPredicate, dateKeyPredicate])

        request.predicate = andPredicate

        let results = try? persistentContainer.viewContext.fetch(request)

        return results ?? [TaskMO]()
    }

    func fetchTask(byDate date: Date?, orCategory category: CategoryMO?) -> [TaskMO] {

        let request: NSFetchRequest<TaskMO> = TaskMO.fetchRequest()

        if let date = date {

            request.predicate = NSPredicate(format: "date == %@", date as CVarArg)

        } else if let category = category {

            request.predicate = NSPredicate(format: "category == %@", category)
        }

        let results = try? persistentContainer.viewContext.fetch(request)

        return results ?? [TaskMO]()
    }

    func deleteTask(taskMO: TaskMO) {

        deleteObject(objectID: taskMO.objectID)
    }

    func deleteTask(byConsecutiveId consecutiveId: Int) {

        let request: NSFetchRequest<TaskMO> = TaskMO.fetchRequest()

        request.predicate = NSPredicate(format: "consecutiveId == %i", consecutiveId)

        guard let results = try? persistentContainer.viewContext.fetch(request) else { return }

        for taskMO in results {

            deleteObject(objectID: taskMO.objectID)
        }
    }

    func fetchAllCategory() -> [CategoryMO] {

        let request: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)

        request.sortDescriptors = [sortDescriptor]

        let results = try? persistentContainer.viewContext.fetch(request)

        return results ?? [CategoryMO]()
    }

}

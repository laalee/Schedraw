//
//  TodayTaskManager.swift
//  ScheduleWidget
//
//  Created by HsinYuLi on 2018/10/13.
//  Copyright © 2018年 laalee. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TodayTaskManager {

    static let share = TodayTaskManager()

    var fetchResultController: NSFetchedResultsController<CategoryMO>!

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = SharePersistentContainer(name: "Schedule")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func getTodayTask(date: Date) -> [TaskMO]? {

        let newDate = transformDate(date: date)

        return getTodayTaskInCoreData(date: newDate)
    }

    func getTodayTaskInCoreData(date: Date) -> [TaskMO]? {

        let sortDescriptor = NSSortDescriptor(key: "time", ascending: true)

        let fetchRequest: NSFetchRequest<TaskMO> = TaskMO.fetchRequest()

        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchRequest.predicate = NSPredicate(format: "date == %@", date as CVarArg)

        let context = persistentContainer.viewContext

        let taskFetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil, cacheName: nil)

        taskFetchResultController.delegate = self as? NSFetchedResultsControllerDelegate

        do {
            try taskFetchResultController.performFetch()

            if let fetchedObjects = taskFetchResultController.fetchedObjects {

                return fetchedObjects
            }
        } catch {

            print("FetchTask Fail!!")

            return nil
        }

        return nil
    }

    func transformDate(date: Date) -> Date {

        var components = DateComponents()
        components.day = Calendar.current.component(.day, from: date)
        components.month = Calendar.current.component(.month, from: date)
        components.year = Calendar.current.component(.year, from: date)
        components.hour = 12
        components.minute = 00

        guard let newDate = Calendar.current.date(from: components) else { return date }

        return newDate
    }
}

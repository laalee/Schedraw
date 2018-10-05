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

    static let share = CoreDataProvider()

    var category: CategoryMO!

    var fetchResultController: NSFetchedResultsController<CategoryMO>!

    func addCategory(category: Category) {

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

            self.category = CategoryMO(context: appDelegate.persistentContainer.viewContext)

            self.category.id = Int64(category.id)

            self.category.title = category.title

            self.category.color = category.color

            appDelegate.saveContext()
        }
    }

    func updateCategory(categoryMO: CategoryMO, category: Category) {

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

            categoryMO.title = category.title

            categoryMO.color = category.color

            appDelegate.saveContext()
        }
    }

    func deleteCategory(categoryMO: CategoryMO) {

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

            let context = appDelegate.persistentContainer.viewContext

            context.delete(categoryMO)

            appDelegate.saveContext()
        }
    }

    func fetchAllCategory(
        success: ([CategoryMO]) -> Void,
        failure: () -> Void
        ) {

        let fetchRequest: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }

        let context = appDelegate.persistentContainer.viewContext

        fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil, cacheName: nil)

        fetchResultController.delegate = self as? NSFetchedResultsControllerDelegate

        do {
            try fetchResultController.performFetch()

            if let fetchedObjects = fetchResultController.fetchedObjects {

                success(fetchedObjects)
            }
        } catch {

            failure()
        }
    }

    func numberOfCategory() -> Int {

        let fetchRequest: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return 0 }

        let context = appDelegate.persistentContainer.viewContext

        fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil, cacheName: nil)

        fetchResultController.delegate = self as? NSFetchedResultsControllerDelegate

        do {
            try fetchResultController.performFetch()

            if let fetchedObjects = fetchResultController.fetchedObjects {

                return fetchedObjects.count
            }
        } catch {

            return 0
        }

        return 0
    }

}

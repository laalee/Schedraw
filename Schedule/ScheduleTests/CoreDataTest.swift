//
//  CoreDataTest.swift
//  ScheduleTests
//
//  Created by HsinYuLi on 2018/11/7.
//  Copyright © 2018 laalee. All rights reserved.
//

//swiftlint:disable variable_name

import XCTest
import CoreData

@testable import Schedule

class CoreDataTest: XCTestCase {

    var sut: CoreDataProvider!

    var saveNotificationCompleteHandler: ((Notification) -> Void)?

    let date = Date()

    override func setUp() {
        super.setUp()

        initStubs()

        sut = CoreDataProvider(container: mockPersistantContainer)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextSaved(notification:)),
            name: NSNotification.Name.NSManagedObjectContextDidSave ,
            object: nil)
    }

    override func tearDown() {

        flushData()

        super.tearDown()
    }

    lazy var managedObjectModel: NSManagedObjectModel = {

        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!

        return managedObjectModel
    }()

    lazy var mockPersistantContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Schedule", managedObjectModel: self.managedObjectModel)

        let description = NSPersistentStoreDescription()

        description.type = NSInMemoryStoreType

        description.shouldAddStoreAsynchronously = false

        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { (description, error) in

            precondition( description.type == NSInMemoryStoreType )

            if let error = error {

                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()

    func test_addCategory() {

        let id = 0
        let title = "test1"
        let color = UIColor.black

        sut.addCategory(id: id, title: title, color: color)

        XCTAssertEqual(sut.category.title, title)
    }

    func test_fetchAllCategory() {

        let results = sut.fetchAllCategory()

        XCTAssertEqual(results.count, 5)
    }

    func test_deleteObject() {

        let caregorys = sut.fetchAllCategory()
        let category = caregorys[0]

        let numberOfCategory = caregorys.count

        sut.deleteObject(objectID: category.objectID)

        XCTAssertEqual(numberOfItemsInPersistentStore(), numberOfCategory - 1)
    }

    func test_save() {

        let caregorys = sut.fetchAllCategory()
        let category = caregorys[0]

        _ = expectationForSaveNotification()

        sut.deleteObject(objectID: category.objectID)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_deleteCategory() {

        let caregorys = sut.fetchAllCategory()
        let category = caregorys[0]

        let numberOfCategory = caregorys.count

        sut.deleteCategory(categoryMO: category)

        XCTAssertEqual(numberOfItemsInPersistentStore(), numberOfCategory - 1)
    }

    func test_updateCategory() {

        let caregorys = sut.fetchAllCategory()
        let category = caregorys[0]

        let title = "test_updateCategory"
        let color = UIColor.black

        sut.updateCategory(categoryMO: category, title: title, color: color)

        XCTAssertEqual(category.title, title)
    }

    func test_addTask() {

        let caregorys = sut.fetchAllCategory()
        let category = caregorys[0]
        let date = Date()
        let title = "test_addTask"

        let task = Task(title: title, category: category, date: date, startDate: date, endDate: date, consecutiveDay: 1, consecutiveStatus: 0, consecutiveId: 1, time: "", note: "")

        sut.addTask(task: task)

        XCTAssertEqual(sut.task.title, title)
    }

}

extension CoreDataTest {

    func initStubs() {

        func addCategory(title: String, color: UIColor) {

            let obj = NSEntityDescription.insertNewObject(
                forEntityName: "Category",
                into: mockPersistantContainer.viewContext)

            obj.setValue(title, forKey: "title")
            obj.setValue(color, forKey: "color")
        }

        addCategory(title: "category1", color: UIColor.black)
        addCategory(title: "category2", color: UIColor.black)
        addCategory(title: "category3", color: UIColor.black)
        addCategory(title: "category4", color: UIColor.black)
        addCategory(title: "category5", color: UIColor.black)

        do {

            try mockPersistantContainer.viewContext.save()

        } catch {

            print("create fakes error \(error)")
        }
    }

    func flushData() {

        var fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")

        if let objs = try? mockPersistantContainer.viewContext.fetch(fetchRequest) {

            for case let obj as NSManagedObject in objs {

                mockPersistantContainer.viewContext.delete(obj)
            }
        }

        try? mockPersistantContainer.viewContext.save()
    }

    func numberOfItemsInPersistentStore() -> Int {

        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Category")

        let results = try? mockPersistantContainer.viewContext.fetch(request)

        return results?.count ?? 0
    }

    func expectationForSaveNotification() -> XCTestExpectation {

        let expect = expectation(description: "Context Saved")

        waitForSavedNotification { (_) in

            expect.fulfill()
        }

        return expect
    }

    func waitForSavedNotification(completeHandler: @escaping ((Notification) -> Void) ) {

        saveNotificationCompleteHandler = completeHandler
    }

    func contextSaved(notification: Notification) {

        saveNotificationCompleteHandler?(notification)
    }

}

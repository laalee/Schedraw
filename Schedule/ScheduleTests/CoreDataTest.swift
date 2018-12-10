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

    func test_addCategory_titleChanged() {

        let id = 0
        let title = "test1"
        let color = UIColor.black

        sut.addCategory(id: id, title: title, color: color)

        XCTAssertEqual(sut.category.title, title)
    }

    func test_addCategory_plusOne() {

        let caregorys = sut.fetchAllCategory()

        let numberOfCategory = caregorys.count

        sut.addCategory(id: 0, title: "test1", color: UIColor.black)

        XCTAssertEqual(numberOfItemsInPersistentStore(), numberOfCategory + 1)
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

        let expect = expectation(description: "Context Saved")

        waitForSavedNotification { (_) in

            expect.fulfill()
        }

        sut.deleteObject(objectID: category.objectID)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_updateCategory() {

        let categorys = sut.fetchAllCategory()
        let objectID = categorys[0].objectID

        let title = "test_updateCategory"
        let color = UIColor.black

        sut.updateCategory(objectID: objectID, title: title, color: color)

        let object = sut.backgroundContext.object(with: objectID)

        let titleDictionary = object.dictionaryWithValues(forKeys: ["title"])

        let objectTitle = titleDictionary["title"] as? String

        XCTAssertEqual(objectTitle, title)
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

        func addCategory(id: Int, title: String, color: UIColor) {

            let obj = NSEntityDescription.insertNewObject(
                forEntityName: "Category",
                into: mockPersistantContainer.viewContext)

            obj.setValue(id, forKey: "id")
            obj.setValue(title, forKey: "title")
            obj.setValue(color, forKey: "color")
        }

        addCategory(id: 1, title: "category1", color: UIColor.black)
        addCategory(id: 2, title: "category2", color: UIColor.black)
        addCategory(id: 3, title: "category3", color: UIColor.black)
        addCategory(id: 4, title: "category4", color: UIColor.black)
        addCategory(id: 5, title: "category5", color: UIColor.black)

        do {

            try mockPersistantContainer.viewContext.save()

        } catch {

            print("create fakes error \(error)")
        }
    }

    func flushData() {

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
            NSFetchRequest<NSFetchRequestResult>(entityName: "Category")

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

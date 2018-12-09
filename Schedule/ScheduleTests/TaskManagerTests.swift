//
//  TaskManagerTests.swift
//  ScheduleTests
//
//  Created by HsinYuLi on 2018/10/31.
//  Copyright © 2018 laalee. All rights reserved.
//

//swiftlint:disable variable_name

import XCTest
import CoreData

@testable import Schedule

class TaskManagerTests: XCTestCase {

    var sut: TaskManager!

    var stubCoreDataProvider: StubCoreDataProviderForTask!

    let currentDate = Date()

    let consecutiveIdForTest = 11

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

    override func setUp() {
        super.setUp()

        initStubs()

        stubCoreDataProvider = StubCoreDataProviderForTask(container: mockPersistantContainer)

        sut = TaskManager(dataProvider: stubCoreDataProvider)
    }

    override func tearDown() {

        sut = nil

        super.tearDown()
    }

    func test_addTask() {

        let title = "addTest"

        let category = stubCoreDataProvider.fetchAllCategory()[0]

        let task = Task(title: title, category: category, date: currentDate, startDate: nil, endDate: nil, consecutiveDay: nil, consecutiveStatus: nil, consecutiveId: nil, time: nil, note: nil)

        sut.addTask(task: task)

        XCTAssertEqual(stubCoreDataProvider.addTest, title)
    }

    func test_addTask_consecutive() {

        let title = "addTest"

        let category = stubCoreDataProvider.fetchAllCategory()[0]

        let task = Task(title: title, category: category, date: currentDate, startDate: nil, endDate: nil, consecutiveDay: 2, consecutiveStatus: nil, consecutiveId: nil, time: nil, note: nil)

        sut.addTask(task: task)

        XCTAssertEqual(stubCoreDataProvider.addTest, title)
    }

    func test_deleteTask() {

        let tasks = stubCoreDataProvider.fetchTask(byDate: currentDate, orCategory: nil)

        for task in tasks {

            sut.deleteTask(taskMO: task)
        }

        XCTAssertEqual(stubCoreDataProvider.deleteTest, String(consecutiveIdForTest))
    }

    func test_fetchTask_byCategory_nil() {

        let category = stubCoreDataProvider.fetchAllCategory()

        let tasks = sut.fetchTask(byCategory: category[0])

        XCTAssertEqual(tasks?.count, 0)
    }

}

extension TaskManagerTests {

    func initStubs() {

        func addTask(title: String, date: Date) {

            let obj = NSEntityDescription.insertNewObject(
                forEntityName: "Task",
                into: mockPersistantContainer.viewContext)

            obj.setValue(title, forKey: "title")
            obj.setValue(date, forKey: "date")

            if title == "task1" {

                obj.setValue(consecutiveIdForTest, forKey: "consecutiveId")
            }
        }

        addTask(title: "task1", date: currentDate)
        addTask(title: "task2", date: currentDate)
        addTask(title: "task3", date: currentDate)
        addTask(title: "task4", date: currentDate)
        addTask(title: "task5", date: currentDate)

        func addCategory(id: Int, title: String, color: UIColor) {

            let obj = NSEntityDescription.insertNewObject(
                forEntityName: "Category",
                into: mockPersistantContainer.viewContext)

            obj.setValue(id, forKey: "id")
            obj.setValue(title, forKey: "title")
            obj.setValue(color, forKey: "color")
        }

        addCategory(id: 1, title: "category1", color: UIColor.black)

        do {

            try mockPersistantContainer.viewContext.save()

        } catch {

            print("create fakes error \(error)")
        }
    }

    func flushData() {

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")

        if let objs = try? mockPersistantContainer.viewContext.fetch(fetchRequest) {

            for case let obj as NSManagedObject in objs {

                mockPersistantContainer.viewContext.delete(obj)
            }
        }

        try? mockPersistantContainer.viewContext.save()
    }

}

class StubCoreDataProviderForTask: CoreDataProvider {

    var addTest: String = ""

    var deleteObjectTest: String = ""

    var deleteTest: String = ""

    override func addTask(task: Task) {

        addTest = task.title
    }

    override func deleteObject(objectID: NSManagedObjectID) {

        self.deleteObjectTest = objectID.uriRepresentation().absoluteString
    }

    override func deleteTask(byConsecutiveId consecutiveId: Int) {

        self.deleteTest = String(consecutiveId)
    }
}

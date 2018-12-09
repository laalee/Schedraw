//
//  CategoryManagerTest.swift
//  ScheduleTests
//
//  Created by HsinYuLi on 2018/12/9.
//  Copyright © 2018 laalee. All rights reserved.
//

//swiftlint:disable variable_name

import XCTest
import CoreData

@testable import Schedule

class CategoryManagerTest: XCTestCase {

    var sut: CategoryManager!

    var stubCoreDataProvider: StubCoreDataProvider!

    override func setUp() {
        super.setUp()

        initStubs()

        stubCoreDataProvider = StubCoreDataProvider(container: mockPersistantContainer)

        sut = CategoryManager(dataProvider: stubCoreDataProvider)
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

        let title = "addCategoryTest"

        sut.addCategory(id: 1, title: title, color: UIColor.black)

        XCTAssertEqual(stubCoreDataProvider.addCategoryTest, title)
    }

    func test_updateCategory() {

        let categorys = stubCoreDataProvider.fetchAllCategory()

        let title = "updateCategoryTest"
        let color = UIColor.black

        sut.updateCategory(categoryMO: categorys[0], title: title, color: color)

        XCTAssertEqual(stubCoreDataProvider.updateCategoryTest, title)
    }

    func test_deleteCategory() {

        let categorys = stubCoreDataProvider.fetchAllCategory()

        let category = categorys[0]

        let str = category.objectID.uriRepresentation().absoluteString

        sut.deleteCategory(categoryMO: category)

        XCTAssertEqual(stubCoreDataProvider.deleteObjectTest, str)
    }

    func test_numberOfCategory() {

        let categorys = stubCoreDataProvider.fetchAllCategory()

        let numberOfCategory = sut.numberOfCategory()

        XCTAssertEqual(categorys.count, numberOfCategory)
    }

}

extension CategoryManagerTest {

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

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")

        if let objs = try? mockPersistantContainer.viewContext.fetch(fetchRequest) {

            for case let obj as NSManagedObject in objs {

                mockPersistantContainer.viewContext.delete(obj)
            }
        }

        try? mockPersistantContainer.viewContext.save()
    }

}

class StubCoreDataProvider: CoreDataProvider {

    var addCategoryTest: String = ""

    var updateCategoryTest: String = ""

    var deleteObjectTest: String = ""

    override func addCategory(id: Int, title: String, color: UIColor) {

        self.addCategoryTest = title
    }

    override func updateCategory(objectID: NSManagedObjectID, title: String, color: UIColor) {

        self.updateCategoryTest = title
    }

    override func deleteObject(objectID: NSManagedObjectID) {

        self.deleteObjectTest = objectID.uriRepresentation().absoluteString
    }

}

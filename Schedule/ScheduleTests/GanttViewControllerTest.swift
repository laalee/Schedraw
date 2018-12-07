//
//  GanttViewControllerTest.swift
//  ScheduleTests
//
//  Created by HsinYuLi on 2018/12/6.
//  Copyright © 2018 laalee. All rights reserved.
//

import XCTest

@testable import Schedule

class GanttViewControllerTest: XCTestCase {

    var controllerUnderTest: GanttViewController!

    override func setUp() {
        super.setUp()

        let categoryManagerStub = CategoryManagerStub()

        controllerUnderTest = GanttViewController(categoryManager: categoryManagerStub)
    }

    override func tearDown() {

        controllerUnderTest = nil
        
        super.tearDown()
    }

    func test_getCategorys_nil() {

        // arrange

        // act
        controllerUnderTest.getCategorys()

        // assert
        XCTAssertEqual(controllerUnderTest.categorys, [])
    }

}

class CategoryManagerStub: CategoryManager {

    override func getAllCategory() -> [CategoryMO]? {

        return nil
    }
}

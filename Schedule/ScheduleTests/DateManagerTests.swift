//
//  ScheduleTests.swift
//  ScheduleTests
//
//  Created by HsinYuLi on 2018/10/30.
//  Copyright © 2018 laalee. All rights reserved.
//

import XCTest

@testable import Schedule

class DateManagerTests: XCTestCase {

    var dateManagerTest: DateManager!

    override func setUp() {
        super.setUp()

        dateManagerTest = DateManager()
    }

    override func tearDown() {

        dateManagerTest = nil

        super.tearDown()
    }

    func test_numberOfDates() {

        // arrange
        dateManagerTest.dates = [Date(), Date(), Date()]

        // act
        let testCount = dateManagerTest.numberOfDates()

        // assert
        XCTAssertEqual(testCount, 3, "Count Dates Wrong")
    }

    func test_addDate() {

        // arrange
        dateManagerTest.dates = []
        let firsrDay = 1
        let lastDay = 10

        // act
        dateManagerTest.addDates(from: firsrDay, to: lastDay)

        // assert
        XCTAssertEqual(dateManagerTest.dates.count, 10, "Add Dates Wrong.")
    }

    func test_addEarlyDates() {

        // arrange
        dateManagerTest.dates = []
        let firsrDay = 1
        let lastDay = 10

        // act
        dateManagerTest.addEarlyDates(from: firsrDay, to: lastDay)

        // assert
        XCTAssertEqual(dateManagerTest.dates.count, 10, "Add Dates Wrong.")
    }

    func test_getDateByAddingDate() {

        // arrange
        let componentsDay = 0
        let date = dateManagerTest.transformDate(date: Date())

        // act
        let testDate = dateManagerTest.getDate(byAdding: componentsDay, to: date)

        // assert
        XCTAssertEqual(testDate, date, "Add Dates Wrong.")
    }

}

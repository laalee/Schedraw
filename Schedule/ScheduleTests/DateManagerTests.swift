//
//  ScheduleTests.swift
//  ScheduleTests
//
//  Created by HsinYuLi on 2018/10/30.
//  Copyright © 2018 laalee. All rights reserved.
//

//swiftlint:disable variable_name

import XCTest

@testable import Schedule

class DateManagerTests: XCTestCase {

    var sut: DateManager!

    override func setUp() {
        super.setUp()

        sut = DateManager()
    }

    override func tearDown() {

        sut = nil

        super.tearDown()
    }

    func test_numberOfDates() {

        sut.dates = [Date(), Date(), Date()]

        let testCount = sut.numberOfDates()

        XCTAssertEqual(testCount, 3, "Count Dates Wrong")
    }

    func test_addDate() {

        sut.dates = []
        let firsrDay = 1
        let lastDay = 10

        sut.addDates(from: firsrDay, to: lastDay)

        XCTAssertEqual(sut.dates.count, 10, "Add Dates Wrong.")
    }

    func test_addEarlyDates() {

        sut.dates = []
        let firsrDay = 1
        let lastDay = 10

        sut.addEarlyDates(from: firsrDay, to: lastDay)

        XCTAssertEqual(sut.dates.count, 10, "Add Dates Wrong.")
    }

    func test_getDateByAddingDate() {

        let componentsDay = 0
        let date = sut.transformDate(date: Date())

        let testDate = sut.getDate(byAdding: componentsDay, to: date)

        XCTAssertEqual(testDate, date, "Add Dates Wrong.")
    }

    func test_formatDate_forTaskPageAlert() {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        let dateString = "10 Dec 2018"
        let date = dateFormatter.date(from: dateString)

        let formatDate = sut.formatDate(forTaskPageAlert: date ?? Date())

        XCTAssertEqual(formatDate, dateString)
    }

}

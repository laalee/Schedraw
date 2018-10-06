//
//  DateManager.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/5.
//  Copyright © 2018年 laalee. All rights reserved.
//

import Foundation

class DateManager {

    static let share = DateManager()

    var dates: [Date] = []

    func numberOfDates() -> Int {

        return dates.count
    }

    func getDate(atIndex index: Int) -> Date {

        guard index < dates.count else { return Date() }

        return dates[index]
    }

    func addDates(from first: Int, to last: Int) {

        for theDay in first...last {

            var date = getDate(byAdding: theDay)

            date = transformDate(date: date)

            dates.append(date)
        }
    }

    func addEarlyDates(from first: Int, to last: Int) {

        for theDay in (first...last).reversed() {

            var date  = getDate(byAdding: theDay)

            date = transformDate(date: date)

            dates.insert(date, at: 0)
        }
    }

    func getDate(byAdding componentsDay: Int) -> Date {

        let currentDate = Date()

        var dateComponents = DateComponents()

        dateComponents.day = componentsDay

        guard let theDate = Calendar.current.date(
            byAdding: dateComponents, to: currentDate) else { return currentDate }

        return theDate
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

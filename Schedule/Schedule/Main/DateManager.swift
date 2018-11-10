//
//  DateManager.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/5.
//  Copyright © 2018年 laalee. All rights reserved.
//

import Foundation

class DateManager {

    static let shared = DateManager()

    var dates: [Date] = []

    func numberOfDates() -> Int {

        print(dates.count)

        return dates.count
    }

    func getDate(atIndex index: Int) -> Date {

        guard index < dates.count else { return Date() }

        return dates[index]
    }

    func addDates(from first: Int, to last: Int) {

        for theDay in first...last {

            let date = getDate(byAdding: theDay)

            dates.append(date)
        }
    }

    func addEarlyDates(from first: Int, to last: Int) {

        for theDay in (first...last).reversed() {

            let date  = getDate(byAdding: theDay)

            dates.insert(date, at: 0)
        }
    }

    func getDate(byAdding componentsDay: Int) -> Date {

        let currentDate = Date()

        var dateComponents = DateComponents()

        dateComponents.day = componentsDay

        guard let theDate = Calendar.current.date(
            byAdding: dateComponents, to: currentDate) else { return currentDate }

        let date = transformDate(date: theDate)

        return date
    }

    func getDate(byAdding componentsDay: Int, to currentDate: Date) -> Date {

        var dateComponents = DateComponents()

        dateComponents.day = componentsDay

        guard let theDate = Calendar.current.date(
            byAdding: dateComponents, to: currentDate) else { return currentDate }

        let date = transformDate(date: theDate)

        return date
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

    func formatDate(forTaskPage date: Date) -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "EEE, d MMM yyyy"

        return dateFormatter.string(from: date)
    }

    func formatDate(forTaskPageAlert date: Date) -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "d MMM yyyy"

        return dateFormatter.string(from: date)
    }

    func consecutiveDay(startDate: Date, lastDate: Date) -> Int {

        let dateComponentsFormatter = DateComponentsFormatter()

        dateComponentsFormatter.allowedUnits = [.day]

        guard let consecutiveDay = dateComponentsFormatter.string(from: startDate, to: lastDate) else { return 1 }

        let consecutive: Int = Int(consecutiveDay.dropLast()) ?? 1

        return consecutive
    }

}

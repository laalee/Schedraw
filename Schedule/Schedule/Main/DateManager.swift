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

            let date = DateManager.share.getDate(byAdding: theDay)

            dates.append(date)
        }
    }

    func addEarlyDates(from first: Int, to last: Int) {

        for theDay in (first...last).reversed() {

            let date  = DateManager.share.getDate(byAdding: theDay)

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

}

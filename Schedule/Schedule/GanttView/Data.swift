//
//  Data.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/27.
//  Copyright © 2018年 laalee. All rights reserved.
//

import Foundation

class Data {

    static let share = Data()

    var types: [EventType] = []

    var events: [Event] = []

    func getTypes() -> [EventType] {

        types = [
            EventType(title: "Home", color: .pink),
            EventType(title: "School", color: .blue)
        ]

        return types
    }

    func gatEvents() -> [Event] {

        let date11 = theDate(year: 2018, month: 10, days: 10, hour: 12, minute: 00)
        let date12 = theDate(year: 2018, month: 9, days: 28, hour: nil, minute: nil)
        let date13 = theDate(year: 2018, month: 9, days: 25, hour: 18, minute: 00)
        let date14 = theDate(year: 2018, month: 9, days: 27, hour: 19, minute: 00)

        events = [
            Event(title: "吃飯", type: types[0], date: date11, time: "12:00"),
            Event(title: "睡覺", type: types[0], date: date12, time: nil),
            Event(title: "寫扣", type: types[1], date: date13, time: nil),
            Event(title: "pizza", type: types[1], date: date14, time: "19:00")
        ]

        return events
    }

    func theDate(year: Int, month: Int, days: Int, hour: Int?, minute: Int?) -> Date {

        var components = DateComponents()

        components.year = year
        components.month = month
        components.day = days
        components.hour = hour
        components.minute = minute

        guard let date = Calendar.current.date(from: components) else { return Date() }

        return date
    }

}

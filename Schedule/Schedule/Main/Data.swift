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

    var events: [Task] = []

    func getTypes() -> [EventType] {

        types = [
            EventType(title: "Home", color: .pink),
            EventType(title: "School", color: .blue),
            EventType(title: "Haha", color: .orange),
            EventType(title: "Four", color: .yellow),
            EventType(title: "Five", color: .purple),
            EventType(title: "66", color: .green),
            EventType(title: "77", color: .green),
            EventType(title: "88", color: .green),
            EventType(title: "99", color: .green),
            EventType(title: "1010", color: .green)
        ]

        return types
    }

    func gatTasks() -> [Task] {

        let date1 = theDate(year: 2018, month: 10, days: 10, hour: 12, minute: 00)
        let date2 = theDate(year: 2018, month: 9, days: 28, hour: nil, minute: nil)
        let date31 = theDate(year: 2018, month: 9, days: 25, hour: nil, minute: nil)
        let date32 = theDate(year: 2018, month: 9, days: 26, hour: nil, minute: nil)
        let date33 = theDate(year: 2018, month: 9, days: 27, hour: nil, minute: nil)
        let date34 = theDate(year: 2018, month: 9, days: 28, hour: nil, minute: nil)
        let date5 = theDate(year: 2018, month: 9, days: 28, hour: 20, minute: 30)
        let date6 = theDate(year: 2018, month: 9, days: 26, hour: 20, minute: 30)
        let date7 = theDate(year: 2018, month: 9, days: 29, hour: 20, minute: 30)
        let date8 = theDate(year: 2018, month: 9, days: 30, hour: 20, minute: 30)
        let date9 = theDate(year: 2018, month: 9, days: 24, hour: 20, minute: 30)
        let date10 = theDate(year: 2018, month: 9, days: 23, hour: 20, minute: 30)

        events = [
            Task(title: "吃飯", type: types[0], date: date1, endDate: nil, consecutiveStatus: nil, time: "12:00"),
            Task(title: "睡覺", type: types[0], date: date2, endDate: nil, consecutiveStatus: nil, time: nil),
            Task(title: "寫扣寫扣", type: types[1], date: date31, endDate: nil, consecutiveStatus: .first, time: nil),
            Task(title: "寫扣寫扣", type: types[1], date: date32, endDate: nil, consecutiveStatus: .middle, time: nil),
            Task(title: "寫扣寫扣", type: types[1], date: date33, endDate: nil, consecutiveStatus: .middle, time: nil),
            Task(title: "寫扣寫扣", type: types[1], date: date34, endDate: nil, consecutiveStatus: .last, time: nil),
            Task(title: "y", type: types[2], date: date5, endDate: nil, consecutiveStatus: nil, time: "20:30"),
            Task(title: "yo", type: types[3], date: date6, endDate: nil, consecutiveStatus: nil, time: nil),
            Task(title: "yoo", type: types[2], date: date7, endDate: nil, consecutiveStatus: nil, time: "19:00"),
            Task(title: "yooo", type: types[4], date: date8, endDate: nil, consecutiveStatus: nil, time: nil),
            Task(title: "yoooo", type: types[5], date: date9, endDate: nil, consecutiveStatus: nil, time: nil),
            Task(title: "yooooo", type: types[3], date: date10, endDate: nil, consecutiveStatus: nil, time: "19:00")
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

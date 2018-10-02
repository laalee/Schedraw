//
//  TaskManager.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/2.
//  Copyright © 2018年 laalee. All rights reserved.
//

import Foundation

class TaskManager {

    static let share = TaskManager()

    func getTask(by date: Date) -> [Task] {

        let tasks = Data.share.gatTasks()

        let dateformatter = DateFormatter()

        dateformatter.dateFormat = "yyyyMMMdd"

        let targetDate = dateformatter.string(from: date)

        let task = tasks.filter { dateformatter.string(from: $0.date) == targetDate }

        return task
    }
}

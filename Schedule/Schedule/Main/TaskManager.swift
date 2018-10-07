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

    static let firstDay: Int = 1

    static let middleDay: Int = 2

    static let lastDay: Int = 3

    let dataProvider = CoreDataProvider()

    func addTask(task: Task) {

        dataProvider.addTask(task: task)
    }

    func updateTask(taskMO: TaskMO, task: Task) {

        dataProvider.updateTask(taskMO: taskMO, task: task)
    }

    func deleteTask(taskMO: TaskMO) {

        dataProvider.deleteTask(taskMO: taskMO)
    }

    func fetchTask(byCategory category: CategoryMO, date: Date) -> [TaskMO]? {

        return dataProvider.fetchTask(byCategory: category, date: date)
    }

    func fetchTask(byDate date: Date) -> [TaskMO]? {

        return dataProvider.fetchTask(byDate: date)
    }

//    func getTask(by date: Date) -> [Task] {
//
//        let tasks = Data.share.gatTasks()
//
//        let dateformatter = DateFormatter()
//
//        dateformatter.dateFormat = "yyyyMMMdd"
//
//        let targetDate = dateformatter.string(from: date)
//
//        let task = tasks.filter { dateformatter.string(from: $0.date) == targetDate }
//
//        return task
//
//
//    }
}

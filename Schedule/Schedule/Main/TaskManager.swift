//
//  TaskManager.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/2.
//  Copyright © 2018年 laalee. All rights reserved.
//

import Foundation

class TaskManager {

    static let shared = TaskManager()

    static let firstDay: Int = 1

    static let middleDay: Int = 2

    static let lastDay: Int = 3

    let dataProvider = CoreDataProvider()

    func addTask(task: Task) {

        dataProvider.addTask(task: task)
    }

//    func updateTask(taskMO: TaskMO, task: Task) {
//
//        dataProvider.updateTask(taskMO: taskMO, task: task)
//    }

    func deleteTask(taskMO: TaskMO) {

        dataProvider.deleteTask(taskMO: taskMO)
    }

    func deleteTask(byConsecutiveId consecutiveId: Int) {

        dataProvider.deleteTask(byConsecutiveId: consecutiveId)
    }

    func fetchTask(byCategory category: CategoryMO, andDate date: Date) -> [TaskMO]? {

        return dataProvider.fetchTask(byCategory: category, date: date)
    }

    func fetchTask(byDate date: Date) -> [TaskMO]? {

        return dataProvider.fetchTask(byDate: date, orCategory: nil)
    }

    func fetchTask(byCategory category: CategoryMO) -> [TaskMO]? {

        return dataProvider.fetchTask(byDate: nil, orCategory: category)
    }

}

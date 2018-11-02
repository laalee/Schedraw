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

    let dataProvider = CoreDataProvider.shared

    func addTask(task: Task) {

        guard let consecutiveDay = task.consecutiveDay, consecutiveDay != 0 else {

            dataProvider.addTask(task: task)

            return
        }

        var newTask = task

        newTask.consecutiveId = Int(Date().timeIntervalSince1970)

        for addingDay in 0...consecutiveDay {

            newTask.date = DateManager.shared.getDate(byAdding: addingDay, to: task.date)

            switch addingDay {

            case 0: newTask.consecutiveStatus = TaskManager.firstDay

            case consecutiveDay: newTask.consecutiveStatus = TaskManager.lastDay

            default: newTask.consecutiveStatus = TaskManager.middleDay
            }

            dataProvider.addTask(task: newTask)
        }
    }

    func deleteTask(taskMO: TaskMO) {

        let id = taskMO.consecutiveId.transformToInt()

        if id != 0 {

            dataProvider.deleteTask(byConsecutiveId: id)

        } else {

            dataProvider.deleteTask(taskMO: taskMO)
        }
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

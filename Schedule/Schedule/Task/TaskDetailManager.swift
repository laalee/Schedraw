//
//  TaskDetailManager.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/25.
//  Copyright © 2018 laalee. All rights reserved.
//

import UIKit

protocol TaskDetailDelegate: AnyObject {

    func taskDetailChanged(newTask: Task)
}

class TaskDetailManager {

    static let shared = TaskDetailManager()

    weak var taskDetailDelegate: TaskDetailDelegate?

    var task = Task(title: "",
                    category: CategoryMO(),
                    date: Date(),
                    startDate: nil,
                    endDate: nil,
                    consecutiveDay: nil,
                    consecutiveStatus: nil,
                    consecutiveId: nil,
                    time: nil,
                    note: nil) {

        didSet {

            taskDetailDelegate?.taskDetailChanged(newTask: task)
        }
    }

    func setCategory(category: CategoryMO) {

        task.category = category
    }

    func setTaskTiming(timing: Date) {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "HH : mm"

        let timing = dateFormatter.string(from: timing)

        task.time = timing
    }

    func setLastDate(endDate: Date,
                     taskMO: TaskMO?,
                     success: () -> Void,
                     failure: (String?, String?) -> Void) {

        let overlapTask = checkOverlapTask(endDate: endDate, taskMO: taskMO)

        if endDate < task.date {

            let alertTitle = "Failed"
            let alertMessage = "End date should be greater than start date."

            failure(alertTitle, alertMessage)

        } else if let date = overlapTask {

            let alertTitle = "Failed"
            let alertMessage = "Some tasks are overlapping in the same category on \(date)."

            failure(alertTitle, alertMessage)

        } else {

            task.endDate = endDate

            updateConsecutiveDay()

            success()
        }
    }

    func checkOverlapTask(endDate: Date, taskMO: TaskMO?) -> String? {

        let startDate = task.date

        let category = task.category

        let consecutiveDay = DateManager.shared.consecutiveDay(startDate: startDate, lastDate: endDate)

        for addingDay in 0...consecutiveDay {

            let date = DateManager.shared.getDate(byAdding: addingDay, to: startDate)

            let task = TaskManager.shared.fetchTask(byCategory: category, andDate: date)

            if task?.count != 0 && task?.first?.consecutiveId != taskMO?.consecutiveId {

                return DateManager.shared.formatDate(forTaskPageAlert: date)
            }
        }

        return nil
    }

    func updateConsecutiveDay() {

        guard let startDate = task.startDate else { return }

        guard let endDate = task.endDate else { return }

        let consecutive = DateManager.shared.consecutiveDay(startDate: startDate, lastDate: endDate)

        task.consecutiveDay = consecutive
    }

}

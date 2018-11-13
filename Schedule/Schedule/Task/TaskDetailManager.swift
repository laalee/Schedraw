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

    weak var taskDetailDelegate: TaskDetailDelegate?

    var taskMO: TaskMO?

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

    func setTask(category: CategoryMO, date: Date) {

        let tasks = TaskManager.shared.fetchTask(byCategory: category, andDate: date)

        if tasks?.count != 0 {

            taskMO = tasks?.first

            if let startDate = taskMO?.startDate as? Date {

                let startTask = TaskManager.shared.fetchTask(byCategory: category, andDate: startDate)

                taskMO = startTask?.first
            }
        }

        task.title = taskMO?.title ?? ""
        task.category = category
        task.date = date
        task.startDate = taskMO?.startDate as? Date
        task.endDate = taskMO?.endDate as? Date
        task.consecutiveDay = taskMO?.consecutiveDay.transformToInt()
        task.consecutiveStatus = nil
        task.consecutiveId = nil
        task.time = taskMO?.time
        task.note = taskMO?.note
    }

    func getTask() -> Task {

        return task
    }

    func setTaskTiming(timing: Date) {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "HH : mm"

        let timing = dateFormatter.string(from: timing)

        task.time = timing
    }

    func setStartDateend(startDate: Date,
                         failure: (String?, String?) -> Void) {

        if let endDate = task.endDate, task.consecutiveDay ?? 0 > 0 {

            guard startDate <= endDate else {

                let alertTitle = "Oops!"
                let alertMessage = "End date should be greater than start date."

                failure(alertTitle, alertMessage)

                return
            }

            let overlapTask = checkOverlapTask(startDate: startDate, endDate: endDate)

            if let date = overlapTask {

                let alertTitle = "Oops!"
                let alertMessage = "\(date) has a overlapping task."

                failure(alertTitle, alertMessage)

                return

            }
        }

        if task.consecutiveDay ?? 0 == 0 {

            task.endDate = nil
        }

        task.date = startDate

        task.startDate = startDate
        
        updateConsecutiveDay()
    }

    func setLastDate(endDate: Date,
                     failure: (String?, String?) -> Void) {

        guard endDate >= task.date else {

            let alertTitle = "Oops!"
            let alertMessage = "End date should be greater than start date."

            failure(alertTitle, alertMessage)

            return
        }

        let overlapTask = checkOverlapTask(endDate: endDate)

        if let date = overlapTask {

            let alertTitle = "Oops!"
            let alertMessage = "\(date) has a overlapping task."

            failure(alertTitle, alertMessage)

        } else {

            task.startDate = task.date

            task.endDate = endDate

            updateConsecutiveDay()
        }
    }

    func setconsecutiveDay(consecutiveDay: Int,
                           failure: (String?, String?) -> Void) {

        let endDate = DateManager.shared.getDate(byAdding: consecutiveDay, to: task.date)

        let overlapTask = checkOverlapTask(endDate: endDate)

        if let date = overlapTask {

            let alertTitle = "Oops!"
            let alertMessage = "\(date) has a overlapping task."

            failure(alertTitle, alertMessage)

        } else {

            task.startDate = task.date

            task.endDate = endDate

            updateConsecutiveDay()
        }
    }

    func checkOverlapTask(startDate: Date, endDate: Date) -> String? {

        let consecutiveDay = DateManager.shared.consecutiveDay(startDate: startDate, lastDate: endDate)

        for addingDay in (0...consecutiveDay).reversed() {

            let date = DateManager.shared.getDate(byAdding: addingDay, to: startDate)

            let task = TaskManager.shared.fetchTask(byCategory: self.task.category, andDate: date)

            if task?.count != 0 && task?.first?.consecutiveId != taskMO?.consecutiveId {

                return DateManager.shared.formatDate(forTaskPageAlert: date)
            }
        }

        return nil
    }

    func checkOverlapTask(endDate: Date) -> String? {

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

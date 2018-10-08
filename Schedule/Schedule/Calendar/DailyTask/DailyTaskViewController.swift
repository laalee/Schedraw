//
//  DailyTaskViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/3.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class DailyTaskViewController: UIViewController {

    @IBOutlet weak var taskTableView: UITableView!

    var tasks: [TaskMO] = []

    var titleString: String = ""

    let dailyMode: Int = 0

    let monthMode: Int = 1

    var currentMode: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        updateTask()

        updateMonthTask()
    }

    private func setupTableView() {

        taskTableView.dataSource = self
        
        taskTableView.delegate = self

        // task cell

        let identifier = String(describing: DailyTaskTableViewCell.self)

        let uiNib = UINib(nibName: identifier, bundle: nil)

        taskTableView.register(uiNib, forCellReuseIdentifier: identifier)

        // header cell

        let headerIdentifier = String(describing: DailyHeaderTableViewCell.self)

        let headerNib = UINib(nibName: headerIdentifier, bundle: nil)

        taskTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: headerIdentifier)
    }

    func updateTask() {

        let name = NSNotification.Name("DAILY_TASK_UPDATE")

        _ = NotificationCenter.default.addObserver(
        forName: name, object: nil, queue: nil) { (notification) in

            self.currentMode = self.dailyMode

            guard let userInfo = notification.userInfo else { return }

            guard let taskMOs = userInfo["task"] as? [TaskMO] else { return }

            var category: CategoryMO?

            if let selectedCategory = userInfo["selectedCategory"] as? CategoryMO {

                category = selectedCategory
            }

            self.tasks = []

            for taskMO in taskMOs {

                if category != nil {

                    if taskMO.category == category {

                        self.tasks.append(taskMO)
                    }
                } else {

                    self.tasks.append(taskMO)
                }
            }

            guard self.tasks.count > 0 else { return }

            guard let date = self.tasks[0].date as? Date else { return }

            self.titleString = self.formatDate(from: date)

            self.taskTableView.reloadData()
        }
    }

    func updateMonthTask() {

        let name = NSNotification.Name("MONYH_TASK_UPDATE")

        _ = NotificationCenter.default.addObserver(
        forName: name, object: nil, queue: nil) { (notification) in

            self.currentMode = self.monthMode

            guard let userInfo = notification.userInfo else { return }

            guard let taskMOs = userInfo["task"] as? [TaskMO] else { return }

            var category: CategoryMO?

            if let selectedCategory = userInfo["selectedCategory"] as? CategoryMO {

                category = selectedCategory
            }

            self.tasks = []

            for taskMO in taskMOs {

                if taskMO.consecutiveStatus == 0 || taskMO.consecutiveStatus == 1 {

                    if category != nil {

                        if taskMO.category == category {

                            self.tasks.append(taskMO)
                        }
                    } else {

                        self.tasks.append(taskMO)
                    }
                }
            }

//            for taskMO in taskMOs {
//
//                for task in self.tasks {
//
//                    if taskMO.consecutiveId == 0 {
//
//                        self.tasks.append(taskMO)
//
//                        continue
//
//                    } else if taskMO.consecutiveId == task.consecutiveId {
//
//                        continue
//                    }
//
//                    self.tasks.append(taskMO)
//                }
//            }

            self.titleString = "Upcoming"

            self.taskTableView.reloadData()
        }
    }

    func formatDate(from date: Date) -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.locale = Locale(identifier: "en_US")

        dateFormatter.dateFormat = "MMMM d, YYYY"

        return dateFormatter.string(from: date)
    }

}

extension DailyTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DailyTaskTableViewCell.self), for: indexPath)

        cell.selectionStyle = .none

        guard let taskCell = cell as? DailyTaskTableViewCell else {
            return cell
        }

        let task = tasks[indexPath.row]

        guard let title = task.title else { return cell }

        guard var subTitle = task.category?.title else { return cell }

        if currentMode == monthMode {

            guard let date = task.date as? Date else { return cell }

            subTitle = formatDate(from: date)
        }

        guard let categoryColor = task.category?.color as? UIColor else { return cell }

        taskCell.setView(
            title: title,
            subTitle: subTitle,
            time: task.time,
            color: categoryColor
        )

        return taskCell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: DailyHeaderTableViewCell.self))

        guard let headerView = view as? DailyHeaderTableViewCell else {
            return view
        }

        headerView.setTitle(title: titleString)

        return headerView
    }

}

extension DailyTaskViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 80
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let task = tasks[indexPath.row]

        let taskViewController = TaskViewController.detailViewControllerForTask(
            category: task.category,
            date: task.date as? Date
        )

        self.show(taskViewController, sender: nil)
    }
}

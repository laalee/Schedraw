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

    var titleDate: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        updateTask()
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

            guard let userInfo = notification.userInfo else { return }

            guard let task = userInfo["task"] as? [TaskMO] else { return }

            self.tasks = task

            let dateFormatter = DateFormatter()

            dateFormatter.locale = Locale(identifier: "en_US")

            dateFormatter.dateFormat = "MMMM d, YYYY"

            guard let date = task[0].date as? Date else { return }

            let titleDate = dateFormatter.string(from: date)

            self.titleDate = titleDate

            self.taskTableView.reloadData()
        }
    }

}

extension DailyTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DailyTaskTableViewCell.self), for: indexPath)

        guard let taskCell = cell as? DailyTaskTableViewCell else {
            return cell
        }

        let task = tasks[indexPath.row]

        guard let title = task.title else { return cell }

        guard let subTitle = task.category?.title else { return cell }

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

        headerView.setTitle(title: titleDate)

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
}

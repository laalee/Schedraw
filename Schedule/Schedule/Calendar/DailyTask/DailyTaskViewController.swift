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

    var tasks: [Task] = []

    var date: String = ""

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

            guard let task = userInfo["task"] as? [Task] else { return }

            self.tasks = task

            let dateFormatter = DateFormatter()

            dateFormatter.locale = Locale(identifier: "en_US")

            dateFormatter.dateFormat = "MMMM d, YYYY"

            let date = dateFormatter.string(from: task[0].date)

            self.date = date

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

        taskCell.setView(
            title: task.title,
            subTitle: task.type.title,
            time: task.time,
            color: task.type.color.getColor()
        )

        return taskCell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: DailyHeaderTableViewCell.self))

        guard let headerView = view as? DailyHeaderTableViewCell else {
            return view
        }

        headerView.setTitle(title: date)

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

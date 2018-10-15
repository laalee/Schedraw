//
//  TodayViewController.swift
//  ScheduleWidget
//
//  Created by HsinYuLi on 2018/10/12.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var noTaskLabel: UILabel!

    @IBOutlet weak var taskTableView: UITableView!

    var todayTask: [TaskMO] = []

    let heightForFullCell: CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()

        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded

        setupTableView()

        getTodayTask()
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {

        let numberOfTask = CGFloat(todayTask.count)

        if activeDisplayMode == .expanded {

            self.preferredContentSize = CGSize(width: maxSize.width, height: numberOfTask * heightForFullCell)

        } else {

            self.preferredContentSize = maxSize
        }

    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {

        completionHandler(NCUpdateResult.newData)
    }

    func setupTableView() {

        taskTableView.dataSource = self

        taskTableView.delegate = self

        taskTableView.register(
                UINib(nibName: String(describing: TodayTaskTableViewCell.self), bundle: nil),
                forCellReuseIdentifier: String(describing: TodayTaskTableViewCell.self)
        )
    }

    func getTodayTask() {

        guard let task = TodayTaskManager.share.getTodayTask(date: Date()) else { return }

        todayTask = task

        noTaskLabel.isHidden = todayTask.count != 0

        taskTableView.reloadData()
    }

    func openApp() {

        guard let scheduleUrl = URL(string: "myWidget://") else { return }

        self.extensionContext?.open(scheduleUrl, completionHandler: nil)
    }

    func formatDate(date: Date) -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MM/dd"

        return dateFormatter.string(from: date)
    }
    
}

extension TodayViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return todayTask.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TodayTaskTableViewCell.self),
            for: indexPath
        )

        guard let taskCell = cell as? TodayTaskTableViewCell else { return cell }

        let task = todayTask[indexPath.row]

        guard let color = task.category?.color as? UIColor else { return cell }

        var subTitle = ""

        if let startDate = task.startDate as? Date, let endDate = task.endDate as? Date {

            subTitle = formatDate(date: startDate) + " - " + formatDate(date: endDate)

        } else {

            if let timing = task.time {

                subTitle = timing
            }
        }

        taskCell.setView(title: task.title, subTitle: subTitle, color: color)

        return taskCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        openApp()
    }

}

extension TodayViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return heightForFullCell
    }

}

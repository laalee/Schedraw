//
//  GanttViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/20.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

protocol TheDelegate: class {

    func todayIndex() -> Int
}

class GanttViewController: UIViewController {

    @IBOutlet weak var ganttTableView: UITableView!

    var numberOfRows: Int = 20

    var types: [EventType] = []

    var datas: [[Event]] = []

    var header: HeaderTableViewCell?

    var emptyRows: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        getDatas()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.layoutIfNeeded()

        scrollToToday(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateEmptyCells()
    }

    private func setupTableView() {

        ganttTableView.dataSource = self

        ganttTableView.delegate = self

//        ganttTableView.bounces = false

        let identifier = String(describing: GanttTableViewCell.self)

        let uiNib = UINib(nibName: identifier, bundle: nil)

        ganttTableView.register(uiNib, forCellReuseIdentifier: identifier)

        let headerIdentifier = String(describing: HeaderTableViewCell.self)

        let headerNib = UINib(nibName: headerIdentifier, bundle: nil)

        ganttTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: headerIdentifier)
    }

    @IBAction func scrollToToday(_ sender: Any) {

        let name = NSNotification.Name("SCROLL_TO_TODAY")

        NotificationCenter.default.post(name: name, object: nil)
    }

    func getDatas() {

        types = Data.share.getTypes()

        let events = Data.share.gatEvents()

        for type in types {
            let array = events.filter { $0.type.title == type.title }
            datas.append(array)
        }
    }

    func updateEmptyCells() {

        let tableViewHeight = Int(ganttTableView.frame.size.height)

        self.emptyRows = (tableViewHeight / 50) - datas.count

        print(tableViewHeight, emptyRows)

        ganttTableView.reloadData()
    }

}

extension GanttViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return types.count + emptyRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: GanttTableViewCell.self), for: indexPath)

        guard let ganttCell = cell as? GanttTableViewCell else {
            return cell
        }

        if indexPath.row < types.count {

            ganttCell.setEventTitle(type: types[indexPath.row].title)
            ganttCell.events = datas[indexPath.row]

        } else {

            ganttCell.setEventTitle(type: "")
            ganttCell.events = []
        }

        ganttCell.theDelegate = self

        return ganttCell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: HeaderTableViewCell.self))

        guard let headerView = view as? HeaderTableViewCell else {
            return view
        }

        self.header = headerView

        return headerView
    }

}

extension GanttViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 51
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 51
    }

}

extension GanttViewController: TheDelegate {

    func todayIndex() -> Int {

        guard let header = header else { return 0 }

        return header.todayIndex
    }

}

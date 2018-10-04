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

    var firstFlag: Bool = true

    var types: [EventType] = []

    var datas: [[Task]] = []

    var header: HeaderTableViewCell?

    var emptyRows: Int = 0

    var categorys: [CategoryMO] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        getDatas()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.layoutIfNeeded()

        if firstFlag {

            scrollToToday(animated)

            firstFlag = false
        }

    }

    override func viewDidLayoutSubviews() {

        updateEmptyCells()
    }

    private func setupTableView() {

        ganttTableView.dataSource = self

        ganttTableView.delegate = self

        // task cell

        let identifier = String(describing: GanttTableViewCell.self)

        let uiNib = UINib(nibName: identifier, bundle: nil)

        ganttTableView.register(uiNib, forCellReuseIdentifier: identifier)

        // header cell

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

        let events = Data.share.gatTasks()

        for type in types {
            let array = events.filter { $0.type.title == type.title }
            datas.append(array)
        }

        CategoryManager.share.getAllCategory(
            success: { (categorys) in

                self.categorys = categorys

                for category in categorys {

                    print(category.title)
                }

            }, failure: {

            // TODO
        })
    }

    func updateEmptyCells() {

        let tableViewHeight = Int(ganttTableView.frame.size.height)

        self.emptyRows = (tableViewHeight / 50) - datas.count

        if emptyRows <= 0 {

            emptyRows = 1
        }

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

            ganttCell.setEventTitle(type: types[indexPath.row])
            ganttCell.events = datas[indexPath.row]
            ganttCell.addButton.isHidden = true
            ganttCell.tableViewTitleLabel.isHidden = false

        } else {

            ganttCell.setEventTitle(type: nil)
            ganttCell.events = []
            ganttCell.addButton.isHidden = indexPath.row != types.count
            ganttCell.tableViewTitleLabel.isHidden = indexPath.row != types.count
        }

        ganttCell.theDelegate = self

        ganttCell.tableViewTitleLabel.isUserInteractionEnabled = true

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

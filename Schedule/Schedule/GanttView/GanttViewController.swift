//
//  GanttViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/20.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class GanttViewController: UIViewController {

    @IBOutlet weak var ganttTableView: UITableView!
    
    @IBAction func plusItem(_ sender: UIButton) {
        print("plus +++++")

        let name = NSNotification.Name("ADD_ITEM")

        NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.layoutIfNeeded()

        let name = NSNotification.Name("SCROLL_TO_TODAY")

        NotificationCenter.default.post(name: name, object: nil)
    }

    private func setupTableView() {

        ganttTableView.dataSource = self

        ganttTableView.delegate = self

        let identifier = String(describing: GanttTableViewCell.self)

        let uiNib = UINib(nibName: identifier, bundle: nil)

        ganttTableView.register(uiNib, forCellReuseIdentifier: identifier)

        let headerIdentifier = String(describing: HeaderTableViewCell.self)

        let headerNib = UINib(nibName: headerIdentifier, bundle: nil)

        ganttTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: headerIdentifier)
    }
}

extension GanttViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: GanttTableViewCell.self), for: indexPath)

        guard let ganttCell = cell as? GanttTableViewCell else {
            return cell
        }

        return ganttCell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: HeaderTableViewCell.self))

        guard let headerView = view as? HeaderTableViewCell else {
            return view
        }

        return headerView
    }

}

extension GanttViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 50
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }

}
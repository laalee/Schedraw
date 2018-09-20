//
//  GanttViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/20.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

protocol TheDelegate: class {

    func didScroll(to position: CGFloat)
}

class GanttViewController: UIViewController {

    @IBOutlet weak var ganttTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    private func setupTableView() {

        ganttTableView.dataSource = self

        ganttTableView.delegate = self

        let identifier = String(describing: GanttTableViewCell.self)

        let uiNib = UINib(nibName: identifier, bundle: nil)

        ganttTableView.register(uiNib, forCellReuseIdentifier: identifier)
    }
}

extension GanttViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: GanttTableViewCell.self), for: indexPath)

        guard let ganttCell = cell as? GanttTableViewCell else {
            return cell
        }

        ganttCell.scrollDelegate = self

        return ganttCell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GanttTableViewCell.self))

        guard let ganttCell = cell as? GanttTableViewCell else {
            return cell
        }

        ganttCell.scrollDelegate = self

        return ganttCell
    }

}

extension GanttViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 40
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

}

extension GanttViewController: TheDelegate {

    func didScroll(to position: CGFloat) {

        for cell in ganttTableView.visibleCells {

            guard let ganttCell = cell as? GanttTableViewCell else { return }

            (ganttCell.itemCollectionView as UIScrollView).contentOffset.x = position
        }
    }

}

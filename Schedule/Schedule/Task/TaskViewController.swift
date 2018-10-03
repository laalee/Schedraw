//
//  EventViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/27.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var taskTableView: UITableView!

    @IBOutlet weak var categoryLabel: UILabel!

    @IBOutlet weak var dateButton: UIButton!

    var category: EventType?

    var date: Date?

    let identifiers = [
        String(describing: TaskTitleTableViewCell.self),
        String(describing: TimingTableViewCell.self),
        String(describing: ConsecutiveTableViewCell.self),
        String(describing: NotesTableViewCell.self),
        String(describing: DeleteTableViewCell.self)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        print(category!)
        print(date!)

        setupTableView()
    }

    // MARK: Initialization

    class func detailViewControllerForTask(category: EventType?, date: Date?) -> TaskViewController {

        let storyboard = UIStoryboard(name: "Task", bundle: nil)

        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: "TaskViewController")
            as? TaskViewController else {

                return TaskViewController()
        }

        viewController.category = category

        viewController.date = date

        return viewController
    }

    @IBAction func saveTask(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelPressed(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    func setupTableView() {

        taskTableView.dataSource = self

        taskTableView.delegate = self

        for identifier in identifiers {

            taskTableView.register(
                UINib(nibName: identifier, bundle: nil),
                forCellReuseIdentifier: identifier)
        }
    }

    @IBAction func dateButtonPressed(_ sender: Any) {

        print("hahaha")
    }

}

extension TaskViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: identifiers[indexPath.section], for: indexPath)

        switch indexPath.section {

        case 0:
            guard let titleCell = cell as? TaskTitleTableViewCell else { return cell }

            return titleCell

        case 1:
            guard let timingCell = cell as? TimingTableViewCell else { return cell }

            return timingCell

        case 2:
            guard let consecutiveCell = cell as? ConsecutiveTableViewCell else { return cell }

            return consecutiveCell

        case 3:
            guard let notesCell = cell as? NotesTableViewCell else { return cell }

            return notesCell

        default:
            guard let deleteCell = cell as? DeleteTableViewCell else { return cell }

            return deleteCell
        }
    }

}

extension TaskViewController: UITableViewDelegate {

}

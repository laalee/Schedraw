//
//  EventViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/27.
//  Copyright © 2018年 laalee. All rights reserved.
//

//swiftlint:disable variable_name

import UIKit

protocol TaskDelegate: AnyObject {

    func getContent<T>() -> T?
}

class TaskViewController: UIViewController {

    @IBOutlet weak var taskTableView: UITableView!

    @IBOutlet weak var categoryLabel: UILabel!

    @IBOutlet weak var dateButton: UIButton!

    var category: CategoryMO?

    var date: Date?

    var pickerView: UIPickerView!

    var datePicker: UIDatePicker!

    weak var titleDelegate: TaskDelegate?

    weak var timingDelegate: TaskDelegate?

    weak var consecutiveDelegate: TaskDelegate?

    weak var notesDelegate: TaskDelegate?

    let identifiers = [
        String(describing: TaskTitleTableViewCell.self),
        String(describing: TimingTableViewCell.self),
        String(describing: ConsecutiveTableViewCell.self),
        String(describing: NotesTableViewCell.self),
        String(describing: DeleteTableViewCell.self)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        let titleDate = DateManager.share.formatDate(forTaskPage: date ?? Date())

        dateButton.setTitle(titleDate, for: .normal)

        categoryLabel.text = category?.title
    }

    // MARK: Initialization

    class func detailViewControllerForTask(category: CategoryMO?, date: Date?) -> TaskViewController {

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

        guard let newTitle: String = titleDelegate?.getContent() else { return }

        guard let category = self.category else { return }

        guard let newDate: Date = self.date else { return }

        let timing: String? = timingDelegate?.getContent()

        let note: String? = notesDelegate?.getContent()

        if let consecutiveDay: Int = consecutiveDelegate?.getContent() {

            let endDate: Date? = DateManager.share.getDate(byAdding: consecutiveDay)

            let lastDay = consecutiveDay - 1

            for addingDay in 0...lastDay {

                let date = DateManager.share.getDate(byAdding: addingDay, to: newDate)

                var consecutiveStatus: Int?

                switch addingDay {

                case 0: consecutiveStatus = TaskManager.firstDay

                case lastDay: consecutiveStatus = TaskManager.lastDay

                default: consecutiveStatus = TaskManager.middleDay
                }

                let newTask = Task(title: newTitle,
                                   category: category,
                                   date: date,
                                   endDate: endDate,
                                   consecutiveStatus: consecutiveStatus,
                                   time: timing,
                                   note: note)

                TaskManager.share.addTask(task: newTask)
            }

        } else {

            let newTask = Task(title: newTitle,
                               category: category,
                               date: newDate,
                               endDate: nil,
                               consecutiveStatus: nil,
                               time: timing,
                               note: note)

            TaskManager.share.addTask(task: newTask)
        }

        NotificationCenter.default.post(name: NSNotification.Name("UPDATE_TASKS"), object: nil)

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

        datePicker = UIDatePicker(frame: CGRect(
            x: 0, y: 0,
            width: UIScreen.main.bounds.width - 5, height: 250))

        datePicker.datePickerMode = .date

        datePicker.date = Date()

        let alertController: UIAlertController = UIAlertController(
            title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(
        title: "OK", style: UIAlertAction.Style.default) { (_) -> Void in

            let pickerDate = DateManager.share.transformDate(date: self.datePicker.date)

            self.date = pickerDate

            print(pickerDate)

            let titleDate = DateManager.share.formatDate(forTaskPage: pickerDate)

            self.dateButton.setTitle(titleDate, for: .normal)
        })

        alertController.addAction(UIAlertAction(
            title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        alertController.view.addSubview(datePicker)

        self.show(alertController, sender: nil)
    }

    @objc func lastDateButtonPressed(_ sender: Any) {

        datePicker = UIDatePicker(frame: CGRect(
            x: 0, y: 0,
            width: UIScreen.main.bounds.width - 5, height: 250))

        datePicker.datePickerMode = .date

        datePicker.date = Date()

        let alertController: UIAlertController = UIAlertController(
            title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(
        title: "OK", style: UIAlertAction.Style.default) { (_) -> Void in

            guard let cell = self.taskTableView.cellForRow(at: IndexPath(row: 0, section: 2))
                as? ConsecutiveTableViewCell else { return }

            let pickerDate = DateManager.share.transformDate(date: self.datePicker.date)

            print(pickerDate)

            cell.updateView(byLastDate: pickerDate, from: self.date ?? Date())
        })

        alertController.addAction(UIAlertAction(
            title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        alertController.view.addSubview(datePicker)

        self.show(alertController, sender: nil)
    }

    @objc func showTimingPicker() {

        datePicker = UIDatePicker(frame: CGRect(
            x: 0, y: 0,
            width: UIScreen.main.bounds.width - 5, height: 250))

        datePicker.datePickerMode = .time

        datePicker.date = Date()

        let alertController: UIAlertController = UIAlertController(
            title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(
        title: "OK", style: UIAlertAction.Style.default) { (_) -> Void in

            print(self.datePicker.date)

            guard let cell = self.taskTableView.cellForRow(at: IndexPath(row: 0, section: 1))
                as? TimingTableViewCell else { return }

            let dateFormatter = DateFormatter()

            dateFormatter.dateFormat = "HH : mm"

            let timing = dateFormatter.string(from: self.datePicker.date)

            cell.updateView(timing: timing)
        })

        alertController.addAction(UIAlertAction(
            title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        alertController.view.addSubview(datePicker)

        self.show(alertController, sender: nil)
    }

    @objc func showConsecutivePicker() {

        pickerView = UIPickerView()

        pickerView.dataSource = self

        pickerView.delegate = self

        pickerView.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width - 50, height: 250)

        let alertController: UIAlertController = UIAlertController(
            title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(
        title: "OK", style: UIAlertAction.Style.default) { (_) -> Void in

            print("date select cd:", self.pickerView.selectedRow(inComponent: 0))

            let consecutiveDay = self.pickerView.selectedRow(inComponent: 0)

            guard let cell = self.taskTableView.cellForRow(at: IndexPath(row: 0, section: 2))
                as? ConsecutiveTableViewCell else { return }

            guard let date = self.date else { return }

            cell.updateView(byConsecutiveDay: consecutiveDay, to: date)
        })

        alertController.addAction(UIAlertAction(
            title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        alertController.view.addSubview(pickerView)

        self.show(alertController, sender: nil)
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

            self.titleDelegate = titleCell

            return titleCell

        case 1:
            guard let timingCell = cell as? TimingTableViewCell else { return cell }

            timingCell.timingButton.addTarget(self,
                action: #selector(showTimingPicker), for: .touchUpInside)

            self.timingDelegate = timingCell

            return timingCell

        case 2:
            guard let consecutiveCell = cell as? ConsecutiveTableViewCell else { return cell }

            consecutiveCell.consecutiveButton.addTarget(self,
                action: #selector(showConsecutivePicker), for: .touchUpInside)

            consecutiveCell.lastDateButton.addTarget(self,
                action: #selector(lastDateButtonPressed), for: .touchUpInside)

            guard let date = self.date else { return cell }

            consecutiveCell.updateView(byConsecutiveDay: 0, to: date)

            self.consecutiveDelegate = consecutiveCell

            return consecutiveCell

        case 3:
            guard let notesCell = cell as? NotesTableViewCell else { return cell }

            self.notesDelegate = notesCell

            return notesCell

        default:
            guard let deleteCell = cell as? DeleteTableViewCell else { return cell }

            deleteCell.delegate = self

            return deleteCell
        }
    }

}

extension TaskViewController: UITableViewDelegate {

}

extension TaskViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if component == 0 {

            return 999
            
        } else {

            return 1
        }
    }

}

extension TaskViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {

        if component == 0 {

            return String(format: "%d", row + 1)

        } else {

            return "Day"
        }
    }

}

extension TaskViewController: DeleteDelegate {

    func deleteObject() {

        print("DELETE!!!!!")
    }

}

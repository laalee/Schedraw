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

    var pickerType: PickerAlertType = .timing

    let identifiers = [
        String(describing: TaskTitleTableViewCell.self),
        String(describing: TimingTableViewCell.self),
        String(describing: ConsecutiveTableViewCell.self),
        String(describing: NotesTableViewCell.self),
        String(describing: DeleteTableViewCell.self)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

//        print(category!)
//        print(date!)

        setupTableView()
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

        datePicker.locale = Locale(identifier: "en_US")

        let alertController: UIAlertController = UIAlertController(
            title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(
        title: "OK", style: UIAlertAction.Style.default) { (_) -> Void in

            print(self.datePicker.date)
        })

        alertController.addAction(UIAlertAction(
            title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        alertController.view.addSubview(datePicker)

        self.show(alertController, sender: nil)
    }

    @objc func showTimingPicker() {

        pickerType = .timing

        pickerView = UIPickerView()

        pickerView.dataSource = self

        pickerView.delegate = self

        pickerView.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width - 50, height: 250)

        let alertController: UIAlertController = UIAlertController(
            title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(
        title: "OK", style: UIAlertAction.Style.default) { (_) -> Void in

            print("date select hh:" + String(self.pickerView.selectedRow(inComponent: 0)))
            print("date select mm:" + String(self.pickerView.selectedRow(inComponent: 1)))
        })

        alertController.addAction(UIAlertAction(
            title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        alertController.view.addSubview(pickerView)

        self.show(alertController, sender: nil)
    }

    @objc func showConsecutivePicker() {

        pickerType = .consecutive

        pickerView = UIPickerView()

        pickerView.dataSource = self

        pickerView.delegate = self

        pickerView.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width - 50, height: 250)

        let alertController: UIAlertController = UIAlertController(
            title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(
        title: "OK", style: UIAlertAction.Style.default) { (_) -> Void in

            print("date select cd:" + String(self.pickerView.selectedRow(inComponent: 0)))
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

            return titleCell

        case 1:
            guard let timingCell = cell as? TimingTableViewCell else { return cell }

            timingCell.timingButton.addTarget(self,
                action: #selector(showTimingPicker), for: .touchUpInside)

            return timingCell

        case 2:
            guard let consecutiveCell = cell as? ConsecutiveTableViewCell else { return cell }

            consecutiveCell.consecutiveButton.addTarget(self,
                action: #selector(showConsecutivePicker), for: .touchUpInside)

            consecutiveCell.lastDateButton.addTarget(self,
                action: #selector(dateButtonPressed), for: .touchUpInside)

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

extension TaskViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return pickerType.numberOfComponents()
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return pickerType.numberOfRowsInComponent(component: component)
    }

}

extension TaskViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {

        return pickerType.titleForRowFormat(row: row)
    }

}

enum PickerAlertType {
    case timing
    case consecutive

    func numberOfComponents() -> Int {

        switch self {

        case .timing: return 2

        case .consecutive: return 1
        }
    }

    func numberOfRowsInComponent(component: Int) -> Int {

        switch self {

        case .timing:

            if component == 0 {

                return 24

            } else {

                return 60
            }

        case .consecutive: return 999
        }
    }

    func titleForRowFormat(row: Int) -> String {

        switch self {

        case .timing: return String(format: "%02d", row)

        case .consecutive: return String(format: "%d", row + 1)
        }
    }

//    func plusRows() -> Int {
//
//        switch self {
//
//        case .timing: return 0
//
//        case .consecutive: return 1
//        }
//    }
}

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

    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!

    @IBOutlet weak var titlebarBackgroungView: UIView!
    
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    
    var category: CategoryMO?

    var task: TaskMO?

    var date: Date?

    var pickerView: UIPickerView!

    var datePicker: UIDatePicker!

    weak var titleDelegate: TaskDelegate?

    weak var timingDelegate: TaskDelegate?

    weak var consecutiveDelegate: TaskDelegate?

    weak var notesDelegate: TaskDelegate?

    var isNewTask: Bool = true

    var isTextViewEditing: Bool = false

    var identifiers = [
        String(describing: TaskTitleTableViewCell.self),
        String(describing: TimingTableViewCell.self),
        String(describing: ConsecutiveTableViewCell.self),
        String(describing: NotesTableViewCell.self)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        setupCategoryAndTask()

        addKeyboardObserver()

        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )

        self.view.addGestureRecognizer(tapGestureRecognizer)
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

    func setupTableView() {

        taskTableView.dataSource = self

        taskTableView.delegate = self

        for identifier in identifiers {

            taskTableView.register(
                UINib(nibName: identifier, bundle: nil),
                forCellReuseIdentifier: identifier)
        }
    }

    func setupCategoryAndTask() {

        guard let category = category else { return }

        guard let categoryColor = category.color as? UIColor else { return }

        guard let date = date else { return }

        let titleDate = DateManager.share.formatDate(forTaskPage: date)

        let tasks = TaskManager.share.fetchTask(byCategory: category, andDate: date)

        categoryLabel.text = category.title

        titlebarBackgroungView.backgroundColor = categoryColor

        dateButton.setTitle(titleDate, for: .normal)

        if tasks?.count != 0 {

            task = tasks?.first

            isNewTask = false

        } else {

            editButton.isHidden = true

            saveButton.isHidden = false
        }
    }

    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardNotification),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardNotification),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }

    @objc func handleKeyboardNotification(notification: Notification) {

        guard let userInfo = notification.userInfo else { return }

        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

            return
        }

        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification

        keyboardHeightConstraint.constant = isKeyboardShowing ? keyboardFrame.height : 0

        UIView.animate(withDuration: 0, animations: {

            self.view.layoutIfNeeded()

        }, completion: { (_) in

            if isKeyboardShowing && self.isTextViewEditing {

                let indexPath = IndexPath(item: 0, section: self.identifiers.count - 1)

                self.taskTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        })
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

            cell.updateView(timing: timing, enabled: true)
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

    @IBAction func editButtonPressed(_ sender: Any) {

        self.editButton.isHidden = true

        self.saveButton.isHidden = false

        identifiers.append(String(describing: DeleteTableViewCell.self))

        setupTableView()

        taskTableView.reloadData()
    }

    @IBAction func saveTask(_ sender: Any) {

        guard let newTitle: String = titleDelegate?.getContent() else {

            showToast()

            return
        }

        guard let category = self.category else { return }

        guard let newDate: Date = self.date else { return }

        let timing: String? = timingDelegate?.getContent()

        let note: String? = notesDelegate?.getContent()

        if let consecutiveDay: Int = consecutiveDelegate?.getContent() {

            let consecutiveId: Int = Int(Date().timeIntervalSince1970)

            let lastDay = consecutiveDay - 1

            let endDate: Date? = DateManager.share.getDate(byAdding: lastDay, to: newDate)

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
                                   startDate: newDate,
                                   endDate: endDate,
                                   consecutiveDay: consecutiveDay,
                                   consecutiveStatus: consecutiveStatus,
                                   consecutiveId: consecutiveId,
                                   time: timing,
                                   note: note)

                TaskManager.share.addTask(task: newTask)
            }
        } else {

            let newTask = Task(title: newTitle,
                               category: category,
                               date: newDate,
                               startDate: nil,
                               endDate: nil,
                               consecutiveDay: nil,
                               consecutiveStatus: nil,
                               consecutiveId: nil,
                               time: timing,
                               note: note)

            TaskManager.share.addTask(task: newTask)
        }

        if !isNewTask {

            guard let id = self.task?.consecutiveId else { return }

            guard let taskMO = self.task else { return }

            if id == 0 {

                TaskManager.share.deleteTask(taskMO: taskMO)

            } else {

                TaskManager.share.deleteTask(byConsecutiveId: Int(id))
            }
        }

        NotificationCenter.default.post(name: NSNotification.Name("UPDATE_TASKS"), object: nil)

        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelPressed(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    func showToast() {

        let alertToast = UIAlertController(
            title: "Save failed!",
            message: "Title should not be blank.",
            preferredStyle: .alert
        )

        present(alertToast, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            alertToast.dismiss(animated: false, completion: nil)
        }
    }

    @objc func dismissKeyboard() {

        self.view.endEditing(true)
    }

}

extension TaskViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return identifiers.count
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

            if editButton.isHidden && !saveButton.isHidden {

                titleCell.updateView(title: task?.title, enabled: true)

            } else {

                titleCell.updateView(title: task?.title, enabled: false)
            }

            return titleCell

        case 1:
            guard let timingCell = cell as? TimingTableViewCell else { return cell }

            timingCell.timingButton.addTarget(self,
                action: #selector(showTimingPicker), for: .touchUpInside)

            self.timingDelegate = timingCell

            if editButton.isHidden && !saveButton.isHidden {

                timingCell.updateView(timing: task?.time, enabled: true)

            } else {

                timingCell.updateView(timing: task?.time, enabled: false)
            }

            return timingCell

        case 2:
            guard let consecutiveCell = cell as? ConsecutiveTableViewCell else { return cell }

            consecutiveCell.consecutiveButton.addTarget(self,
                action: #selector(showConsecutivePicker), for: .touchUpInside)

            consecutiveCell.lastDateButton.addTarget(self,
                action: #selector(lastDateButtonPressed), for: .touchUpInside)

            guard let date = self.date else { return cell }

            if let endDate = self.task?.endDate as? Date {

                consecutiveCell.updateView(byLastDate: endDate, from: date)

                consecutiveCell.setupEnabled(enabled: false)

            } else {

                consecutiveCell.updateView(byConsecutiveDay: 0, to: date)

                consecutiveCell.setupEnabled(enabled: true)
            }

            if editButton.isHidden && !saveButton.isHidden {

                consecutiveCell.setupEnabled(enabled: true)

            } else {

                consecutiveCell.setupEnabled(enabled: false)
            }

            self.consecutiveDelegate = consecutiveCell

            return consecutiveCell

        case 3:
            guard let notesCell = cell as? NotesTableViewCell else { return cell }

            if editButton.isHidden && !saveButton.isHidden {

                notesCell.updateView(notes: task?.note, enabled: true)

            } else {

                notesCell.updateView(notes: task?.note, enabled: false)
            }

            self.notesDelegate = notesCell

            notesCell.notesTextView.delegate = self

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

        guard let task = self.task else { return }

        let alertController: UIAlertController = UIAlertController(
            title: "Delete this task?", message: nil, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(
        title: "OK", style: UIAlertAction.Style.default) { (_) -> Void in

            guard let id = self.task?.consecutiveId else { return }

            if id == 0 {

                TaskManager.share.deleteTask(taskMO: task)

            } else {

                TaskManager.share.deleteTask(byConsecutiveId: Int(id))
            }

            NotificationCenter.default.post(name: NSNotification.Name("UPDATE_TASKS"), object: nil)

            self.dismiss(animated: true, completion: nil)
        })

        alertController.addAction(UIAlertAction(
            title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        self.show(alertController, sender: nil)
    }

}

extension TaskViewController: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {

        self.isTextViewEditing = true

        return true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {

        self.isTextViewEditing = false

        return true
    }
}

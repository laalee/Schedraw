//
//  EventViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/27.
//  Copyright © 2018年 laalee. All rights reserved.
//

//swiftlint:disable variable_name

import UIKit
import Lottie
import DynamicColor

protocol TaskDelegate: AnyObject {

    func getContent<T>() -> T?
}

protocol TaskAnimationDelegate: AnyObject {

    func dismissTaskViewController()
}

class TaskViewController: UIViewController {

    @IBOutlet weak var taskTableView: UITableView!

    @IBOutlet weak var categoryLabel: UILabel!

    @IBOutlet weak var dateButton: UIButton!

    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!

    @IBOutlet weak var titlebarBackgroungView: UIView!
    
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!

    // alertPicker
    @IBOutlet weak var alertPickerBaseView: UIView!

    @IBOutlet weak var alertDatePickerTitleLabel: UILabel!

    @IBOutlet weak var alertDatePicker: UIDatePicker!

    @IBOutlet weak var alertPickerView: UIPickerView!

    @IBOutlet weak var alertOkButton: UIButton!

    @IBOutlet weak var alertCancelButton: UIButton!

    var alertPickerStatus: String = ""

    var category: CategoryMO?

    var taskMO: TaskMO?

    var task: Task?

    var date: Date?

    var pickerView: UIPickerView!

    var datePicker: UIDatePicker!

    weak var titleDelegate: TaskDelegate?

    weak var timingDelegate: TaskDelegate?

    weak var consecutiveDelegate: TaskDelegate?

    weak var notesDelegate: TaskDelegate?

    weak var taskAnimationDelegate: TaskAnimationDelegate?

    var isNewTask: Bool = true

    var isTextViewEditing: Bool = false

    weak var taskPageDelegate: TaskPageDelegate?

    var identifiers = [
        String(describing: TaskTitleTableViewCell.self),
        String(describing: TimingTableViewCell.self),
        String(describing: ConsecutiveTableViewCell.self),
        String(describing: NotesTableViewCell.self)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        alertPickerBaseView.alpha = 0.0

        setupTableView()

        setupCategoryAndTask()

        addKeyboardObserver()

        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )

        self.view.addGestureRecognizer(tapGestureRecognizer)

        titlebarBackgroungView.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        titlebarBackgroungView.layer.shadowOpacity = 0.5
        titlebarBackgroungView.layer.shadowRadius = 5.0
        titlebarBackgroungView.layer.shadowOffset = CGSize(width: 0, height: 0 )
        titlebarBackgroungView.layer.masksToBounds = false

        TaskDetailManager.shared.taskDetailDelegate = self
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

        alertDatePickerTitleLabel.backgroundColor = categoryColor

        alertOkButton.setTitleColor(categoryColor.darkened(), for: .normal)

        alertCancelButton.setTitleColor(categoryColor.darkened(), for: .normal)

        var titleDate = DateManager.shared.formatDate(forTaskPage: date)

        let tasks = TaskManager.shared.fetchTask(byCategory: category, andDate: date)

        if tasks?.count != 0 {

            taskMO = tasks?.first

            if let startDate = taskMO?.startDate as? Date {

                let startTask = TaskManager.shared.fetchTask(byCategory: category, andDate: startDate)

                taskMO = startTask?.first

                titleDate = DateManager.shared.formatDate(forTaskPage: startDate)

                self.date = startDate
            }

            isNewTask = false

        } else {

            editButton.isHidden = true

            saveButton.isHidden = false
        }
        
        task = Task(title: taskMO?.title ?? "",
                    category: taskMO?.category ?? category,
                    date: taskMO?.date as? Date ?? Date(),
                    startDate: taskMO?.startDate as? Date,
                    endDate: taskMO?.endDate as? Date,
                    consecutiveDay: transformInt(originInt: taskMO?.consecutiveDay),
                    consecutiveStatus: transformInt(originInt: taskMO?.consecutiveStatus),
                    consecutiveId: transformInt(originInt: taskMO?.consecutiveId),
                    time: taskMO?.time,
                    note: taskMO?.note)

        categoryLabel.text = category.title

        titlebarBackgroungView.backgroundColor = categoryColor

        dateButton.setTitle(titleDate, for: .normal)

        TaskDetailManager.shared.setCategory(category: category)
    }

    func transformInt(originInt: Int64?) -> Int? {

        guard let origin = originInt else {

            return nil
        }

        return Int(origin)
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

            let pickerDate = DateManager.shared.transformDate(date: self.datePicker.date)

            self.date = pickerDate

            let titleDate = DateManager.shared.formatDate(forTaskPage: pickerDate)

            self.dateButton.setTitle(titleDate, for: .normal)
        })

        alertController.addAction(UIAlertAction(
            title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        alertController.view.addSubview(datePicker)

        self.show(alertController, sender: nil)
    }

    @objc func lastDateButtonPressed(_ sender: Any) {

        datePicker = UIDatePicker()

        datePicker.datePickerMode = .date

        datePicker.date = Date()

        let alert = CustomAlertView(title: "Select end date", contentView: datePicker)

        alert.customAlertViewDelegate = self

        alert.show(animated: true)

        alertPickerStatus = "LastDate"

//        alertDatePicker.date = self.date ?? Date()
//
//        if let endDate = self.task?.endDate {
//
//            alertDatePicker.date = endDate
//
//        } else if let lastDate = taskMO?.endDate as? Date {
//
//            alertDatePicker.date = lastDate
//        }

        dismissKeyboard()
    }

    @objc func showTimingPicker() {

        datePicker = UIDatePicker()

        datePicker.datePickerMode = .time

        datePicker.date = Date()

        let alert = CustomAlertView(title: "Select timings", contentView: datePicker)

        alert.customAlertViewDelegate = self

        alert.show(animated: true)

        alertPickerStatus = "Timing"
    }

    @objc func showConsecutivePicker() {

        alertDatePicker.alpha = 0.0

        alertPickerView.alpha = 1.0

        alertDatePickerTitleLabel.text = "Select consecutive days"

        UIView.animate(withDuration: 0.2) { [weak self] in

            self?.alertPickerBaseView.alpha = 1.0
        }

        alertPickerStatus = "Consecutive"

        alertPickerView.dataSource = self

        alertPickerView.delegate = self

        if let consecutiveDay = self.task?.consecutiveDay {

            alertPickerView.selectRow(consecutiveDay, inComponent: 0, animated: true)

        } else if let consecutiveDay = taskMO?.consecutiveDay {

            alertPickerView.selectRow(Int(consecutiveDay) - 1, inComponent: 0, animated: true)
        }

        dismissKeyboard()

    }

    @IBAction func editButtonPressed(_ sender: Any) {

        self.editButton.isHidden = true

        self.saveButton.isHidden = false

        identifiers.append(String(describing: DeleteTableViewCell.self))

        setupTableView()

        taskTableView.reloadData()
    }

    func showToast(title: String?, message: String?) {

        let alertToast = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alertToast.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        present(alertToast, animated: true, completion: nil)
    }

    @IBAction func saveTask(_ sender: Any) {

        guard let newTitle: String = titleDelegate?.getContent() else {

            showToast(title: "Save failed!", message: "Title should not be blank.")

            return
        }

        guard let category = self.category else { return }

        guard let newDate: Date = self.date else { return }

        let timing: String? = timingDelegate?.getContent()

        let note: String? = notesDelegate?.getContent()

        if let consecutiveDay: Int = consecutiveDelegate?.getContent() {

            let consecutiveId: Int = Int(Date().timeIntervalSince1970)

            let lastDay = consecutiveDay - 1

            let endDate: Date? = DateManager.shared.getDate(byAdding: lastDay, to: newDate)

            for addingDay in 0...lastDay {

                let date = DateManager.shared.getDate(byAdding: addingDay, to: newDate)

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

                TaskManager.shared.addTask(task: newTask)
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

            TaskManager.shared.addTask(task: newTask)
        }

        if !isNewTask {

            guard let id = self.taskMO?.consecutiveId else { return }

            guard let taskMO = self.taskMO else { return }

            if id == 0 {

                TaskManager.shared.deleteTask(taskMO: taskMO)

            } else {

                TaskManager.shared.deleteTask(byConsecutiveId: Int(id))
            }

            let tasks = TaskManager.shared.fetchTask(byCategory: category, andDate: newDate)

            self.taskMO = tasks?.first

            self.editButton.isHidden = false

            self.editButton.isEnabled = false

            self.saveButton.isHidden = true

            identifiers.removeLast()

            setupTableView()

            taskTableView.reloadData()

            NotificationCenter.default.post(name: NSNotification.Name("UPDATE_TASKS"), object: nil)

            completeAnimation()

            taskPageDelegate?.updateTask(task: tasks?.first)

        } else {

            NotificationCenter.default.post(name: NSNotification.Name("UPDATE_TASKS"), object: nil)
            
            dismiss(animated: true, completion: nil)

            taskAnimationDelegate?.dismissTaskViewController()
        }
    }

    @IBAction func cancelPressed(_ sender: Any) {

        dismiss(animated: true, completion: nil)

        taskAnimationDelegate?.dismissTaskViewController()
    }

    @objc func dismissKeyboard() {

        self.view.endEditing(true)
    }

    func completeAnimation() {

        let animationView = LOTAnimationView(name: "check-4")

        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        animationView.center = self.view.center

        animationView.contentMode = .scaleAspectFill

        animationView.animationSpeed = 2

        self.view.addSubview(animationView)

        animationView.play { (_) in

            animationView.removeFromSuperview()

            self.editButton.isEnabled = true
        }
    }

    @IBAction func alertPickerClosed(_ sender: Any) {

        UIView.animate(withDuration: 0.2) { [weak self] in

            self?.alertPickerBaseView.alpha = 0.0
        }
    }

    @IBAction func alertPickerCancelPressed(_ sender: Any) {

        UIView.animate(withDuration: 0.2) { [weak self] in

            self?.alertPickerBaseView.alpha = 0.0
        }
    }

    @IBAction func alertPickerOkPressed(_ sender: Any) {

//        if alertPickerStatus == "LastDate" {
//
//            guard let cell = self.taskTableView.cellForRow(at: IndexPath(row: 0, section: 2))
//                as? ConsecutiveTableViewCell else { return }
//
//            let pickerDate = DateManager.shared.transformDate(date: self.alertDatePicker.date)
//
//            let overlapTask = self.checkOverlapTask(lastDate: pickerDate)
//
//            if pickerDate < self.date ?? Date() {
//
//                self.showToast(title: "Failed", message: "End date should be greater than start date.")
//
//            } else if let date = overlapTask {
//
//                self.showToast(title: "Failed",
//                               message: "Some tasks are overlapping in the same category on \(date)."
//                )
//
//            } else {
//
//                self.task?.endDate = pickerDate
//
//                cell.updateView(byLastDate: pickerDate, from: self.date ?? Date())
//            }
//        }
        if alertPickerStatus == "Consecutive" {

            let consecutiveDay = self.alertPickerView.selectedRow(inComponent: 0)

            guard let cell = self.taskTableView.cellForRow(at: IndexPath(row: 0, section: 2))
                as? ConsecutiveTableViewCell else { return }

            guard let date = self.date else { return }

            let lastDate = DateManager.shared.getDate(byAdding: consecutiveDay, to: date)

//            let overlapTask = self.checkOverlapTask(lastDate: lastDate)
//
//            if let date = overlapTask {
//
//                self.showToast(title: "Failed",
//                               message: "Some tasks are overlapping in the same category on \(date)."
//                )
//
//            } else {
//
//                self.task?.consecutiveDay = consecutiveDay
//
//                self.task?.endDate = lastDate
//
//                cell.updateView(byConsecutiveDay: consecutiveDay, to: date)
//            }
        }

        UIView.animate(withDuration: 0.2) { [weak self] in

            self?.alertPickerBaseView.alpha = 0.0
        }
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

        guard let categoryColor = self.category?.color as? UIColor else { return cell }

        switch indexPath.section {

        case 0:
            guard let titleCell = cell as? TaskTitleTableViewCell else { return cell }

            titleCell.titleLabel.textColor = categoryColor.darkened()

            self.titleDelegate = titleCell

            let enable = editButton.isHidden && !saveButton.isHidden

            titleCell.updateView(title: taskMO?.title, enabled: enable)

            return titleCell

        case 1:
            guard let timingCell = cell as? TimingTableViewCell else { return cell }

            timingCell.titleLabel.textColor = categoryColor.darkened()

            timingCell.timingButton.addTarget(self,
                action: #selector(showTimingPicker), for: .touchUpInside)

            self.timingDelegate = timingCell

            let enable = editButton.isHidden && !saveButton.isHidden

//            if timingCell.firstSetFlag {

                timingCell.updateView(timing: task?.time, enabled: enable)
//            }

            timingCell.setupEnabled(enabled: enable)

            timingCell.firstSetFlag = false

            return timingCell

        case 2:
            guard let consecutiveCell = cell as? ConsecutiveTableViewCell else { return cell }

            consecutiveCell.titleLabel.textColor = categoryColor.darkened()

            consecutiveCell.consecutiveButton.addTarget(self,
                action: #selector(showConsecutivePicker), for: .touchUpInside)

            consecutiveCell.lastDateButton.addTarget(self,
                action: #selector(lastDateButtonPressed), for: .touchUpInside)

            guard let date = self.date else { return cell }

            if let endDate = self.taskMO?.endDate as? Date {

                if consecutiveCell.firstSetFlag {

                    consecutiveCell.updateView(byLastDate: endDate, from: date)
                }

                consecutiveCell.setupEnabled(enabled: false)

            } else {

                if consecutiveCell.firstSetFlag {

                    consecutiveCell.updateView(byConsecutiveDay: 0, to: date)
                }

                consecutiveCell.setupEnabled(enabled: true)
            }

            if editButton.isHidden && !saveButton.isHidden {

                consecutiveCell.setupEnabled(enabled: true)

            } else {

                consecutiveCell.setupEnabled(enabled: false)
            }

            self.consecutiveDelegate = consecutiveCell

            consecutiveCell.firstSetFlag = false

            return consecutiveCell

        case 3:
            guard let notesCell = cell as? NotesTableViewCell else { return cell }

            notesCell.titleLabel.textColor = categoryColor.darkened()

            let enabled = editButton.isHidden && !saveButton.isHidden

            notesCell.updateView(notes: taskMO?.note, enabled: enabled)

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

        guard let task = self.taskMO else { return }

        let alertController: UIAlertController = UIAlertController(
            title: "Delete this task?", message: nil, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(
        title: "OK", style: UIAlertAction.Style.default) { (_) -> Void in

            guard let id = self.taskMO?.consecutiveId else { return }

            if id == 0 {

                TaskManager.shared.deleteTask(taskMO: task)

            } else {

                TaskManager.shared.deleteTask(byConsecutiveId: Int(id))
            }

            NotificationCenter.default.post(name: NSNotification.Name("UPDATE_TASKS"), object: nil)

            self.taskPageDelegate?.updateTask(task: nil)

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

extension TaskViewController: CustomAlertViewDelegate {

    func contentViewChanged() {

        alertPickerContentChanged()
    }

    func alertPickerContentChanged() {

        if alertPickerStatus == "Timing" {

            let selectedTiming = self.datePicker.date

            TaskDetailManager.shared.setTaskTiming(timing: selectedTiming)

        } else if alertPickerStatus == "LastDate" {

            let selectedDate = self.datePicker.date

            TaskDetailManager.shared.setLastDate(
                endDate: selectedDate,
                taskMO: self.taskMO,
                success: {

                    print("SUCCESS")
            },
                failure: { (title, message) in

                    self.showToast(title: title, message: message)
            })

        } else if alertPickerStatus == "Consecutive" {

        }
    }

}

extension TaskViewController: TaskDetailDelegate {

    func taskDetailChanged(newTask: Task) {

        task?.time = newTask.time

        task?.consecutiveDay = newTask.consecutiveDay

        task?.endDate = newTask.endDate

        taskTableView.reloadData()
    }

}

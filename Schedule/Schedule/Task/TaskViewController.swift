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

    weak var taskPageDelegate: TaskPageDelegate?

    weak var taskAnimationDelegate: TaskAnimationDelegate?

    var category: CategoryMO?

    var date: Date?

    var task: Task?

    var pickerView: UIPickerView!

    var datePicker: UIDatePicker!

    var alertPickerStatus: String = ""

    var isNewTask: Bool = true

    var isTextViewEditing: Bool = false

    let taskDetailManager = TaskDetailManager()

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

        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(dismissKeyboard))

        self.view.addGestureRecognizer(tapGestureRecognizer)

        taskDetailManager.taskDetailDelegate = self
    }

    // MARK: Initialization

    class func detailViewControllerForTask(category: CategoryMO?, date: Date?) -> TaskViewController {

        let storyboard = UIStoryboard(name: "Task", bundle: nil)

        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: "TaskViewController") as? TaskViewController else {

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

        guard let date = date else { return }

        taskDetailManager.setTask(category: category, date: date)

        self.task = taskDetailManager.getTask()

        setTitleViews()

        setEditButton()
    }

    func setTitleViews() {

        categoryLabel.text = category?.title

        guard let categoryColor = category?.color as? UIColor else { return }

        titlebarBackgroungView.backgroundColor = categoryColor

        titlebarBackgroungView.setTitlebarShadow()

        updateTitleDate()
    }

    func updateTitleDate() {

        guard let task = task else { return }

        let titleDate = DateManager.shared.formatDate(forTaskPage: task.startDate ?? task.date)

        dateButton.setTitle(titleDate, for: .normal)

        dateButton.isEnabled = editButton.isHidden && !saveButton.isHidden
    }

    func setEditButton() {

        isNewTask = taskDetailManager.taskMO == nil

        editButton.isHidden = isNewTask

        saveButton.isHidden = !isNewTask
    }

    @IBAction func editButtonPressed(_ sender: Any) {

        self.editButton.isHidden = true

        self.saveButton.isHidden = false

        identifiers.append(String(describing: DeleteTableViewCell.self))

        setupTableView()

        updateTitleDate()

        taskTableView.reloadData()
    }

    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardNotification),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardNotification(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func handleKeyboardNotification(notification: Notification) {

        guard let userInfo = notification.userInfo else { return }

        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            as? NSValue)?.cgRectValue else { return }

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

    @objc func dismissKeyboard() {

        self.view.endEditing(true)
    }

    @IBAction func showDatePicker(_ sender: Any) {

        alertPickerStatus = "FirstDate"

        showDateAlertPicker()
    }

    @objc func showTimingPicker() {

        alertPickerStatus = "Timing"

        showDateAlertPicker()
    }

    @objc func showLastDatePicker(_ sender: Any) {

        alertPickerStatus = "LastDate"

        showDateAlertPicker()
    }

    @objc func showConsecutivePicker() {

        alertPickerStatus = "Consecutive"

        showAlertPicker()
    }

    func showDateAlertPicker() {

        dismissKeyboard()

        datePicker = UIDatePicker()

        var alert: CustomAlertView?

        switch alertPickerStatus {

        case "Timing":

            datePicker.datePickerMode = .time

            datePicker.date = task?.date ?? Date()

            alert = CustomAlertView(title: "Select timing", contentView: datePicker)

        case "LastDate":

            datePicker.datePickerMode = .date

            datePicker.date = task?.endDate ?? task?.date ?? Date()

            alert = CustomAlertView(title: "Select end date", contentView: datePicker)

        case "FirstDate":

            datePicker.datePickerMode = .date

            datePicker.date = task?.date ?? Date()

            alert = CustomAlertView(title: "Select start date", contentView: datePicker)

        default:
            break
        }

        alert?.customAlertViewDelegate = self

        alert?.show(animated: true)

    }

    func showAlertPicker() {

        dismissKeyboard()

        pickerView = UIPickerView()

        pickerView.dataSource = self

        pickerView.delegate = self

        let alert = CustomAlertView(title: "Select consecutive days", contentView: pickerView)

        alert.customAlertViewDelegate = self

        alert.show(animated: true)
    }

    func showToast(title: String?, message: String?) {

        let alertToast = UIAlertController(title: title,
                                           message: message,
                                           preferredStyle: .alert)

        alertToast.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        present(alertToast, animated: true, completion: nil)
    }

    @IBAction func saveTask(_ sender: Any) {

        guard let newTask = self.task else { return }

        guard newTask.title != "" else {

            showToast(title: "Save failed!", message: "Title should not be blank.")

            return
        }

        TaskManager.shared.addTask(task: newTask)

        if !isNewTask {

            guard let taskMO = taskDetailManager.taskMO else { return }

            TaskManager.shared.deleteTask(taskMO: taskMO)

            setupCategoryAndTask()

            identifiers.removeLast()

            setupTableView()

            taskTableView.reloadData()

            completeAnimation()

            NotificationCenter.default.post(name: .updateTasks, object: nil)

            taskPageDelegate?.updateTask(task: taskMO)

        } else {

            NotificationCenter.default.post(name: .updateTasks, object: nil)

            dismiss(animated: true, completion: nil)

            taskAnimationDelegate?.dismissTaskViewController()
        }
    }

    @IBAction func cancelPressed(_ sender: Any) {

        dismiss(animated: true, completion: nil)

        taskAnimationDelegate?.dismissTaskViewController()
    }

    func completeAnimation() {

        self.editButton.isEnabled = false

        let animationView = CustomAnimationView(jsonFile: "check", speed: 2)

        self.view.addSubview(animationView)

        guard let lotAnimationView = animationView.lotAnimationView else { return }

        lotAnimationView.play { (_) in

            animationView.removeFromSuperview()

            self.editButton.isEnabled = true

            self.dismiss(animated: true, completion: nil)

            self.taskAnimationDelegate?.dismissTaskViewController()
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {

        if let title = textField.text {

            self.task?.title = title
        }
    }

    func getTitleColor() -> UIColor {

        guard let categoryColor = self.category?.color as? UIColor else { return UIColor.black }

        let titleColor = categoryColor.darkened()

        return titleColor
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

        let titleColor = getTitleColor()

        let enabled = editButton.isHidden && !saveButton.isHidden

        switch indexPath.section {

        case 0:
            guard let titleCell = cell as? TaskTitleTableViewCell else { return cell }

            titleCell.titleTextField.addTarget(self,
                action: #selector(textFieldDidChange(_:)), for: .editingChanged)

            titleCell.updateView(title: task?.title, enabled: enabled, titleColor: titleColor)

            return titleCell

        case 1:
            guard let timingCell = cell as? TimingTableViewCell else { return cell }

            timingCell.timingButton.addTarget(self,
                action: #selector(showTimingPicker), for: .touchUpInside)

            timingCell.updateView(timing: task?.time, enabled: enabled, titleColor: titleColor)

            return timingCell

        case 2:

            guard let consecutiveCell = cell as? ConsecutiveTableViewCell else { return cell }

            consecutiveCell.consecutiveButton.addTarget(self,
                action: #selector(showConsecutivePicker), for: .touchUpInside)

            consecutiveCell.lastDateButton.addTarget(self,
                action: #selector(showLastDatePicker), for: .touchUpInside)

            guard let date = task?.date else { return consecutiveCell }

            consecutiveCell.updateView(consecutiveDay: task?.consecutiveDay ?? 0,
                                       lastDate: task?.endDate ?? date,
                                       enabled: enabled,
                                       titleColor: titleColor)

            return consecutiveCell

        case 3:

            guard let notesCell = cell as? NotesTableViewCell else { return cell }

            notesCell.notesTextView.delegate = self

            notesCell.updateView(notes: task?.note, enabled: enabled, titleColor: titleColor)

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

        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return 366
    }

}

extension TaskViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {

        return String(format: "%d", row + 1)
    }

}

extension TaskViewController: DeleteDelegate {

    func deleteObject() {

        guard let task = taskDetailManager.taskMO else { return }

        let alertController: UIAlertController = UIAlertController(
            title: "Delete this task?", message: nil, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(
        title: "OK", style: UIAlertAction.Style.default) { (_) -> Void in

            TaskManager.shared.deleteTask(taskMO: task)

            NotificationCenter.default.post(name: .updateTasks, object: nil)

            self.taskPageDelegate?.updateTask(task: nil)

            self.dismiss(animated: true, completion: nil)

            self.taskAnimationDelegate?.dismissTaskViewController()
        })

        alertController.addAction(UIAlertAction(
            title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        self.show(alertController, sender: nil)
    }

}

extension TaskViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {

        self.isTextViewEditing = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {

        self.isTextViewEditing = false
    }

    func textViewDidChange(_ textView: UITextView) {

        self.task?.note = textView.text
    }
}

extension TaskViewController: CustomAlertViewDelegate {

    func contentViewChanged() {

        switch alertPickerStatus {

        case "Timing":

            let selectedTiming = self.datePicker.date

            taskDetailManager.setTaskTiming(timing: selectedTiming)

        case "LastDate":

            let selectedDate = self.datePicker.date

            taskDetailManager.setLastDate(
                endDate: selectedDate,
                failure: { (title, message) in

                    self.showToast(title: title, message: message)
            })

        case "Consecutive":

            let consecutiveDay = self.pickerView.selectedRow(inComponent: 0)

            taskDetailManager.setconsecutiveDay(
                consecutiveDay: consecutiveDay,
                failure: { (title, message) in

                    self.showToast(title: title, message: message)
            })

        case "FirstDate":

            let selectedDate = self.datePicker.date

            taskDetailManager.setStartDateend(
                startDate: selectedDate,
                failure: { (title, message) in

                    self.showToast(title: title, message: message)
            })

        default:
            break
        }
    }

}

extension TaskViewController: TaskDetailDelegate {

    func taskDetailChanged(newTask: Task) {

        task?.time = newTask.time

        task?.consecutiveDay = newTask.consecutiveDay

        task?.endDate = newTask.endDate

        task?.date = newTask.date

        task?.startDate = newTask.startDate

        taskTableView.reloadData()

        setTitleViews()
    }

}

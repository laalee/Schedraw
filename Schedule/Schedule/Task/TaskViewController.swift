//
//  EventViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/27.
//  Copyright © 2018年 laalee. All rights reserved.
//

//swiftlint:disable variable_name

import UIKit

class TaskViewController: UIViewController {

    var category: EventType?

    var date: Date?

    let timePicker: UIPickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        print(category)
        print(date)

        timePicker.delegate = self
        timePicker.dataSource = self
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

    @IBAction func addPickerView(_ sender: Any) {

        timePicker.frame = CGRect(x: 0, y: 150, width: self.view.frame.width, height: 200)
        timePicker.backgroundColor = .white

        self.view.addSubview(timePicker)
    }

    @IBAction func saveTask(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelPressed(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

}

extension TaskViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if component == 0 {
            return 24
        }

        return 60
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%02d", row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if component == 0 {

            let minute = row
            print("hour: \(minute)")

        } else {

            let second = row
            print("minute: \(second)")
        }
    }

}

extension TaskViewController: UIPickerViewDelegate {

}

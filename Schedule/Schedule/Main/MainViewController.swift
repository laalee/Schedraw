//
//  ViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/19.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var ganttView: UIView!

    @IBOutlet weak var calendarView: UIView!

    @IBOutlet weak var yearLabel: UILabel!

    @IBOutlet weak var modeButton: UIButton!

    @IBOutlet weak var modeBackgroundButton: UIButton!

    @IBOutlet weak var alertBackgroundView: UIView!

    @IBOutlet weak var alertPickerView: UIPickerView!

    var categorys: [Any] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        alertBackgroundView.alpha = 0.0

        yearLabel.text = String(Calendar.current.component(.year, from: Date()))

        changeYear()

        DisplayModeManager.shared.updateMode()

        setupAlertPicker()
    }

    func changeYear() {
        
        let name = NSNotification.Name("YEAR_CHANGED")

        _ = NotificationCenter.default.addObserver(
        forName: name, object: nil, queue: nil) { (notification) in

            guard let userInfo = notification.userInfo else { return }

            guard let year = userInfo["year"] as? String else { return }

            self.yearLabel.text = year
        }
    }

    @IBAction func showSetting(_ sender: Any) {

        let storyboard = UIStoryboard(name: "Setting", bundle: nil)

        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: "SettingViewController")
            as? SettingViewController
            else { return
        }

        self.show(viewController, sender: nil)
    }
    
    @IBAction func modeButtonPressed(_ sender: UIButton) {

        modeButton.isSelected = !modeButton.isSelected

        modeBackgroundButton.isSelected = !modeBackgroundButton.isSelected

        changeContentAnimated(showGanttPage: modeButton.isSelected)
    }

    private func changeContentAnimated(showGanttPage flag: Bool) {

        let scheduleAlpha: CGFloat = !flag ? 1.0 : 0.0

        let calendarAlpha: CGFloat = flag ? 1.0 : 0.0

        UIView.animate(withDuration: 0.2) { [weak self] in

            self?.ganttView.alpha = scheduleAlpha

            self?.calendarView.alpha = calendarAlpha

            self?.yearLabel.alpha = scheduleAlpha
        }
    }

    func setupAlertPicker() {

        alertPickerView.dataSource = self

        alertPickerView.delegate = self

        _ = NotificationCenter.default.addObserver(
        forName: NSNotification.Name("SETUP_PICKER_CATEGORYS"),
        object: nil, queue: nil) { (notification) in

            guard let userInfo = notification.userInfo else { return }

            guard let categorys = userInfo["categorys"] as? [CategoryMO] else { return }

            self.categorys = categorys

            self.categorys.insert("ALL", at: 0)
        }

        _ = NotificationCenter.default.addObserver(
        forName: NSNotification.Name("SHOW_ALERT_PICKER"),
        object: nil, queue: nil) { (_) in

            UIView.animate(withDuration: 0.2) { [weak self] in

                self?.alertBackgroundView.alpha = 1.0
            }
        }
    }

    @IBAction func alertOkButtonPressed(_ sender: Any) {

        let selectedRow = alertPickerView.selectedRow(inComponent: 0)

        let selectedCategory: CategoryMO?

        if let category = self.categorys[selectedRow] as? CategoryMO {

            selectedCategory = category

        } else {

            selectedCategory = nil
        }

        NotificationCenter.default.post(
            name: NSNotification.Name("DISMISS_ALERT_PICKER"),
            object: nil,
            userInfo: ["selectedCategory": selectedCategory as Any]
        )

        UIView.animate(withDuration: 0.2) { [weak self] in

            self?.alertBackgroundView.alpha = 0.0
        }
    }
    @IBAction func alertCancelButtonPressed(_ sender: Any) {

        UIView.animate(withDuration: 0.2) { [weak self] in

            self?.alertBackgroundView.alpha = 0.0
        }
    }
    @IBAction func alertBackgroungButtonPressed(_ sender: Any) {

        UIView.animate(withDuration: 0.2) { [weak self] in

            self?.alertBackgroundView.alpha = 0.0
        }
    }
}

extension MainViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return categorys.count

    }

}

extension MainViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {

        guard let category = categorys[row] as? CategoryMO else {

            return "ALL"
        }

        return category.title
    }

}

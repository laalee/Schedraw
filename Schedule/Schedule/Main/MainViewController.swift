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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yearLabel.text = String(Calendar.current.component(.year, from: Date()))

        changeYear()

        DisplayModeManager.shared.updateMode()
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

        sender.isSelected = !sender.isSelected

        changeContentAnimated(showGanttPage: sender.isSelected)
    }

    private func changeContentAnimated(showGanttPage flag: Bool) {

        let scheduleAlpha: CGFloat = !flag ? 1.0 : 0.0

        let calendarAlpha: CGFloat = flag ? 1.0 : 0.0

        UIView.animate(withDuration: 0.2) { [weak self] in

            self?.ganttView.alpha = scheduleAlpha

            self?.calendarView.alpha = calendarAlpha
        }
    }

}

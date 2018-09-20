//
//  ViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/19.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ganttView: UIView!

    @IBOutlet weak var calendarView: UIView!

    @IBOutlet weak var modeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        switchMode()
    }

    private func switchMode() {

        print(modeButton.isSelected)

        if modeButton.isSelected {

            changeContentAnimated(showGanttPage: false)

        } else {

            changeContentAnimated(showGanttPage: true)
        }
    }

    @IBAction func modeButtonPressed(_ sender: UIButton) {

        sender.isSelected = !sender.isSelected

        switchMode()
    }

    private func changeContentAnimated(showGanttPage flag: Bool) {

        let scheduleAlpha: CGFloat = flag ? 1.0 : 0.0

        let calendarAlpha: CGFloat = !flag ? 1.0 : 0.0

        UIView.animate(withDuration: 0.2) { [weak self] in

            self?.ganttView.alpha = scheduleAlpha

            self?.calendarView.alpha = calendarAlpha
        }
    }

}

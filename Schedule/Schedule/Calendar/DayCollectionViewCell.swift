//
//  DayCollectionViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/29.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var centerBackgroundView: UIView!

    @IBOutlet weak var secondCenterView: UIView!
    
    @IBOutlet weak var thirdCenterView: UIView!

    @IBOutlet weak var leftBackgroundView: UIView!

    @IBOutlet weak var rightBackgroundView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setBackgroundViews()
    }

    func setBackgroundViews() {

        if UIScreen.main.bounds.size.width < 350 {

            let smallSize: CGFloat = 37

            centerBackgroundView.widthAnchor.constraint(equalToConstant: smallSize).isActive = true
            centerBackgroundView.heightAnchor.constraint(equalToConstant: smallSize).isActive = true

            centerBackgroundView.setCornerRadius(value: smallSize / 2)

            secondCenterView.setCornerRadius(value: smallSize / 2)

            thirdCenterView.setCornerRadius(value: smallSize / 2)

        } else {

            let bigSize: CGFloat = 45

            centerBackgroundView.setCornerRadius(value: bigSize / 2)

            secondCenterView.setCornerRadius(value: bigSize / 2)

            thirdCenterView.setCornerRadius(value: bigSize / 2)
        }
    }

    func setDayLabel(date: Date?) {

        guard let theDate = date else {

            self.dayLabel.text = ""

            return
        }

        let theday = Calendar.current.component(.day, from: theDate)

        self.dayLabel.text = String(theday)
    }

    func clearBackgroundViews() {

        let backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)

        centerBackgroundView.backgroundColor = backgroundColor

        secondCenterView.backgroundColor = backgroundColor

        thirdCenterView.backgroundColor = backgroundColor

        leftBackgroundView.backgroundColor = backgroundColor

        rightBackgroundView.backgroundColor = backgroundColor

        dayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    func setTask(tasks: [TaskMO]?) {

        guard let tasks = tasks else { return }

        for index in 0..<tasks.count {

            if index == 0 {

                if let categoryColor = tasks[index].category?.color as? UIColor {

                    centerBackgroundView.backgroundColor = categoryColor
                }
            } else if index == 1 {

                if let categoryColor = tasks[index].category?.color as? UIColor {

                    secondCenterView.backgroundColor = categoryColor
                }

            } else if index == 2 {

                if let categoryColor = tasks[index].category?.color as? UIColor {

                    thirdCenterView.backgroundColor = categoryColor
                }
            }

            dayLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }

    func setCategoryTask(tasks: [TaskMO]?) {

        guard let task = tasks?.first else { return }

        dayLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        let status = Int(task.consecutiveStatus)

        guard status != 0 else {

            if let categoryColor = task.category?.color as? UIColor {

                centerBackgroundView.backgroundColor = categoryColor
            }

            return
        }

        guard let categoryColor = task.category?.color as? UIColor else { return }

        centerBackgroundView.backgroundColor = categoryColor

        switch status {

        case TaskManager.firstDay:

            rightBackgroundView.backgroundColor = categoryColor

        case TaskManager.middleDay:

            leftBackgroundView.backgroundColor = categoryColor

            rightBackgroundView.backgroundColor = categoryColor

        case TaskManager.lastDay:

            leftBackgroundView.backgroundColor = categoryColor

        default:

            break
        }
    }

}

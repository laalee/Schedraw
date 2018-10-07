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

    @IBOutlet weak var todayBackgroundView: UIView!

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

            todayBackgroundView.setCornerRadius(value: smallSize / 2)

        } else {

            let bigSize: CGFloat = 45

            centerBackgroundView.setCornerRadius(value: bigSize / 2)

            secondCenterView.setCornerRadius(value: bigSize / 2)

            thirdCenterView.setCornerRadius(value: bigSize / 2)

            todayBackgroundView.setCornerRadius(value: bigSize / 2)
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

    func setTask(tasks: [TaskMO]) {

        centerBackgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        secondCenterView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        thirdCenterView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        dayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

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

}

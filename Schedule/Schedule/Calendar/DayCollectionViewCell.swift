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

    var tasks: [Task] = []
    
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

    func setTask(tasks: [Task]) {

        self.tasks = tasks

        if tasks.count == 0 {

            centerBackgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

            secondCenterView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

            thirdCenterView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        } else if tasks.count == 1 {

            centerBackgroundView.backgroundColor = tasks.first?.type.color.getColor()

            secondCenterView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

            thirdCenterView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

            dayLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        } else {

            for index in 0..<tasks.count {

                if index == 0 {

                    centerBackgroundView.backgroundColor = tasks[index].type.color.getColor()

                    secondCenterView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

                    thirdCenterView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

                } else if index == 1 {
                    
                    secondCenterView.backgroundColor = tasks[index].type.color.getColor()

                } else if index == 2 {

                    thirdCenterView.backgroundColor = tasks[index].type.color.getColor()
                }

                dayLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }

}

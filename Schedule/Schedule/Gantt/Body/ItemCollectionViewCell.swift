//
//  ItemCollectionViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/20.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var centerBackgroundView: UIView!

    @IBOutlet weak var leftBackgroundView: UIView!

    @IBOutlet weak var rightBackgroundView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setTask(task: TaskMO?) {

        centerBackgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        leftBackgroundView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)

        rightBackgroundView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)

        guard let task = task else {

            titleLabel.text = ""

            timeLabel.text = ""

            return
        }

        let status = Int(task.consecutiveStatus)

        guard status != 0 else {

            titleLabel.text = task.title

            timeLabel.text = task.time

            if let categoryColor = task.category?.color as? UIColor {

                centerBackgroundView.backgroundColor = categoryColor
            }

            return
        }

        switch status {

        case TaskManager.firstDay:

            titleLabel.text = task.title

            timeLabel.text = ""

            if let categoryColor = task.category?.color as? UIColor {

                centerBackgroundView.backgroundColor = categoryColor

                rightBackgroundView.backgroundColor = categoryColor
            }

        case TaskManager.middleDay:

            titleLabel.text = ""

            timeLabel.text = ""

            if let categoryColor = task.category?.color as? UIColor {

                centerBackgroundView.backgroundColor = categoryColor

                leftBackgroundView.backgroundColor = categoryColor

                rightBackgroundView.backgroundColor = categoryColor
            }

        case TaskManager.lastDay:

            titleLabel.text = ""

            timeLabel.text = ""

            if let categoryColor = task.category?.color as? UIColor {

                centerBackgroundView.backgroundColor = categoryColor

                leftBackgroundView.backgroundColor = categoryColor
            }

        default:

            break
        }
    }

}

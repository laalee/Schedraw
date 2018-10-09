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

        centerBackgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)

        leftBackgroundView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)

        rightBackgroundView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)

        titleLabel.text = ""

        timeLabel.text = ""

        guard let task = task else { return }

        guard let categoryColor = task.category?.color as? UIColor else { return }

        centerBackgroundView.backgroundColor = categoryColor

        let status = Int(task.consecutiveStatus)

        switch status {

        case 0:

            titleLabel.text = task.title

            timeLabel.text = task.time

            return

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

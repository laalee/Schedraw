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

    func setEvent(event: Task?) {
        
        if let event = event {

            if let status = event.consecutiveStatus {

                switch status {
                case .first:
                    titleLabel.text = event.title
                    timeLabel.text = ""
                    centerBackgroundView.backgroundColor = event.type.color.getColor()
                    leftBackgroundView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
                    rightBackgroundView.backgroundColor = event.type.color.getColor()

                case .middle:
                    titleLabel.text = ""
                    timeLabel.text = ""
                    centerBackgroundView.backgroundColor = event.type.color.getColor()
                    leftBackgroundView.backgroundColor = event.type.color.getColor()
                    rightBackgroundView.backgroundColor = event.type.color.getColor()

                case .last:
                    titleLabel.text = ""
                    timeLabel.text = ""
                    centerBackgroundView.backgroundColor = event.type.color.getColor()
                    leftBackgroundView.backgroundColor = event.type.color.getColor()
                    rightBackgroundView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
                }
            } else {

                titleLabel.text = event.title
                timeLabel.text = event.time
                centerBackgroundView.backgroundColor = event.type.color.getColor()
                leftBackgroundView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
                rightBackgroundView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
            }

        } else {

            titleLabel.text = ""

            timeLabel.text = ""
            
            centerBackgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

            leftBackgroundView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)

            rightBackgroundView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        }
    }

    func setBackgroundViews(type: String, event: Task) {

        switch type {
        case "start":
            centerBackgroundView.backgroundColor = event.type.color.getColor()
            leftBackgroundView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
            rightBackgroundView.backgroundColor = event.type.color.getColor()
        case "mid":
            centerBackgroundView.backgroundColor = event.type.color.getColor()
            leftBackgroundView.backgroundColor = event.type.color.getColor()
            rightBackgroundView.backgroundColor = event.type.color.getColor()
        case "end":
            centerBackgroundView.backgroundColor = event.type.color.getColor()
            leftBackgroundView.backgroundColor = event.type.color.getColor()
            rightBackgroundView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        default:
            centerBackgroundView.backgroundColor = event.type.color.getColor()
            leftBackgroundView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
            rightBackgroundView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        }
    }

}

//
//  DailyTaskTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/3.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class DailyTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var pinView: UIView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var subTitleLabel: UILabel!

    @IBOutlet weak var timeView: UIView!

    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setView(title: String, subTitle: String, time: String?, color: UIColor) {

        titleLabel.text = title

        subTitleLabel.text = subTitle

        timeLabel.text = time

        if time == nil {
            
            timeLabel.text = ""
        }

        pinView.backgroundColor = color

        timeView.backgroundColor = color
    }

}

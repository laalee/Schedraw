//
//  TodayTaskTableViewCell.swift
//  ScheduleWidget
//
//  Created by HsinYuLi on 2018/10/12.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class TodayTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryColorView: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var subTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setView(title: String?, subTitle: String?, color: UIColor?) {

        titleLabel.text = title

        subTitleLabel.text = subTitle

        categoryColorView.backgroundColor = color
    }
    
}

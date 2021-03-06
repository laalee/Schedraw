//
//  ConsecutiveTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/3.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class ConsecutiveTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var consecutiveButton: UIButton!

    @IBOutlet weak var lastDateButton: UIButton!

    @IBOutlet weak var consecutiveLineView: UIView!

    @IBOutlet weak var lastDateLineView: UIView!

    @IBOutlet weak var consecutiveBackgroundView: UIView!
    
    var consecutiveDay: Int = 0

    var firstSetFlag: Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()

        consecutiveBackgroundView.setShadow()
    }

    func updateView(consecutiveDay: Int, lastDate: Date, enabled: Bool, titleColor: UIColor) {

        titleLabel.textColor = titleColor

        updateConsecutiveButton(consecutiveDay: consecutiveDay + 1)

        updateLastDateButton(date: lastDate)

        setupEnabled(enabled: enabled)
    }

    func updateConsecutiveButton(consecutiveDay: Int) {

        self.consecutiveDay = consecutiveDay

        if consecutiveDay < 2 {

            consecutiveButton.setTitle(String(consecutiveDay) + " Day", for: .normal)

        } else {

            consecutiveButton.setTitle(String(consecutiveDay) + " Days", for: .normal)
        }
    }

    func updateLastDateButton(date: Date) {

        let lastDateTitle = DateManager.shared.formatDate(forTaskPage: date)

        lastDateButton.setTitle(lastDateTitle, for: .normal)
    }

    func setupEnabled(enabled: Bool) {

        consecutiveButton.isEnabled = enabled

        lastDateButton.isEnabled = enabled

        consecutiveLineView.isHidden = !enabled

        lastDateLineView.isHidden = !enabled
    }

}

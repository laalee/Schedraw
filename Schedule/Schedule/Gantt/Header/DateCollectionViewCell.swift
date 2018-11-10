//
//  DateCollectionViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/21.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!

    @IBOutlet weak var weekLabel: UILabel!

    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        dateFormatter.locale = Locale(identifier: "en_US")
    }

    func setContent(date: Date) {

        dateFormatter.dateFormat = "d"

        dayLabel.text = dateFormatter.string(from: date)

        dateFormatter.dateFormat = "E"

        weekLabel.text = dateFormatter.string(from: date)

        if date == DateManager.shared.transformDate(date: Date()) {

            dayLabel.textColor = UIColor.red.lighter()

            weekLabel.textColor = UIColor.red.lighter()

        } else {

            dayLabel.textColor = UIColor.black

            weekLabel.textColor = UIColor.black
        }
    }

    func getMonth(date: Date) -> String {

        dateFormatter.dateFormat = "MMM"

        return dateFormatter.string(from: date)
    }

    func getYear(date: Date) -> String {

        dateFormatter.dateFormat = "YYYY"

        return dateFormatter.string(from: date)
    }

}

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

    var date = Date()

    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        dateFormatter.locale = Locale(identifier: "en_US")
    }

    func setContent() {

        dateFormatter.dateFormat = "d"

        dayLabel.text = dateFormatter.string(from: date)

        dateFormatter.dateFormat = "E"

        weekLabel.text = dateFormatter.string(from: date)
    }

    func getMonth() -> String {

        dateFormatter.dateFormat = "MMM"

        return dateFormatter.string(from: date)
    }

    func getYear() -> String {

        dateFormatter.dateFormat = "YYYY"

        return dateFormatter.string(from: date)
    }

}

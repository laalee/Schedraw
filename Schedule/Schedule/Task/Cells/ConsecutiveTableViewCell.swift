//
//  ConsecutiveTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/3.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class ConsecutiveTableViewCell: UITableViewCell {

    @IBOutlet weak var consecutiveButton: UIButton!

    @IBOutlet weak var lastDateButton: UIButton!

    var consecutiveDay: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupEnabled(enabled: Bool) {

        consecutiveButton.isEnabled = enabled

        lastDateButton.isEnabled = enabled
    }

    func updateView(byConsecutiveDay consecutiveDay: Int, to currentDate: Date) {

        updateConsecutiveButton(consecutiveDay: consecutiveDay + 1)

        let lastDate = DateManager.share.getDate(byAdding: consecutiveDay, to: currentDate)

        updateLastDateButton(date: lastDate)
    }

    func updateView(byLastDate lastDate: Date, from startDate: Date) {

        let dateComponentsFormatter = DateComponentsFormatter()

        dateComponentsFormatter.allowedUnits = [.day]

        guard let consecutiveDay = dateComponentsFormatter.string(from: startDate, to: lastDate) else { return }

        let consecutive: Int = Int(consecutiveDay.dropLast()) ?? 1

        updateConsecutiveButton(consecutiveDay: consecutive + 1)

        updateLastDateButton(date: lastDate)
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

        let lastDateTitle = DateManager.share.formatDate(forTaskPage: date)

        lastDateButton.setTitle(lastDateTitle, for: .normal)
    }

}

extension ConsecutiveTableViewCell: TaskDelegate {

    func getContent<T>() -> T? {

        if consecutiveDay < 2 {

            return nil
        }

        return self.consecutiveDay as? T
    }

}

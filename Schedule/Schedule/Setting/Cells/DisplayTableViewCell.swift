//
//  DisplayTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/14.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class DisplayTableViewCell: UITableViewCell {

    @IBOutlet weak var displayBackgroundView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        displayBackgroundView.setCornerRadius(value: 20)

        displayBackgroundView.setShadow()

        displayBackgroundView.backgroundColor = DisplayModeManager.shared.getMainColor()

        self.contentView.backgroundColor = DisplayModeManager.shared.getSubColor()
    }

    @IBAction func nightModeChanged(_ sender: UISwitch) {

        UserDefaults.standard.set(sender.isOn, forKey: "NIGHT_MODE")

        DisplayModeManager.shared.updateMode()
    }
    
}

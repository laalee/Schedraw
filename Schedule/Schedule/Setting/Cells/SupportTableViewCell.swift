//
//  SupportTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/14.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class SupportTableViewCell: UITableViewCell {

    @IBOutlet weak var supportBackgroundView: UIView!

    @IBOutlet weak var contactUsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        supportBackgroundView.setCornerRadius(value: 20)

        supportBackgroundView.setShadow()

        supportBackgroundView.backgroundColor = DisplayModeManager.shared.getMainColor()

        self.contentView.backgroundColor = DisplayModeManager.shared.getSubColor()
    }

}

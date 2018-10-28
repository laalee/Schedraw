//
//  TaskTitleTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/3.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class TaskTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleTextField: UITextField!

    @IBOutlet weak var titleLineView: UIView!

    @IBOutlet weak var titleBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        titleBackgroundView.setShadow()
    }

    func updateView(title: String?, enabled: Bool, titleColor: UIColor) {

        titleLabel.textColor = titleColor

        if titleTextField.text == "" {

            titleTextField.text = title
        }

        titleTextField.isEnabled = enabled

        titleLineView.isHidden = !enabled
    }
    
}

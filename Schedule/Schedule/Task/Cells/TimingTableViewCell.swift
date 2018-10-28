//
//  TimingTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/3.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class TimingTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timingTextField: UITextField!

    @IBOutlet weak var timingButton: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var timingLineView: UIView!

    @IBOutlet weak var timingBackgroundView: UIView!
    
    var firstSetFlag: Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()

        timingBackgroundView.setShadow()
    }

    func updateView(timing: String?, enabled: Bool, titleColor: UIColor) {

        titleLabel.textColor = titleColor

        timingTextField.text = timing

        setupEnabled(enabled: enabled)
    }

    func setupEnabled(enabled: Bool) {

        timingButton.isEnabled = enabled

        timingLineView.isHidden = !enabled

        if enabled && timingTextField.text != "" {

            clearButton.isHidden = false

        } else if !enabled {

            clearButton.isHidden = true
        }
    }

    @IBAction func clearButtonPressed(_ sender: Any) {

        timingTextField.text = ""

        clearButton.isHidden = true
    }
}

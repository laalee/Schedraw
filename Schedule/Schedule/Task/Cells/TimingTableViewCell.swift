//
//  TimingTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/3.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class TimingTableViewCell: UITableViewCell {

    @IBOutlet weak var timingTextField: UITextField!

    @IBOutlet weak var timingButton: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateView(timing: String?, enabled: Bool) {

        timingTextField.text = timing

        timingButton.isEnabled = enabled

        if enabled && timing != nil && timing != "" {

            clearButton.isHidden = false
        }
    }

    @IBAction func clearButtonPressed(_ sender: Any) {

        timingTextField.text = ""

        clearButton.isHidden = true
    }
}

extension TimingTableViewCell: TaskDelegate {

    func getContent<T>() -> T? {

        return timingTextField.text as? T
    }

}

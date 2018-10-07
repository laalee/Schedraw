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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateView(timing: String) {

        timingTextField.text = timing
    }

}

extension TimingTableViewCell: TaskDelegate {

    func getContent<T>() -> T? {

        return timingTextField.text as? T
    }

}

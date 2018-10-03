//
//  TaskTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/30.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var contentTextField: UITextField!

    @IBOutlet weak var timeButton: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

}

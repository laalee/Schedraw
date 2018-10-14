//
//  TaskTitleTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/3.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class TaskTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UITextField!

    @IBOutlet weak var titleLineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateView(title: String?, enabled: Bool) {

        if titleTextField.text == "" {

            titleTextField.text = title
        }

        titleTextField.isEnabled = enabled

        titleLineView.isHidden = !enabled
    }
    
}

extension TaskTitleTableViewCell: TaskDelegate {

    func getContent<T>() -> T? {

        var title = titleTextField.text

        title = title?.trimmingCharacters(in: .whitespaces)

        if title == "" {

            return nil
        }

        return title as? T
    }

}

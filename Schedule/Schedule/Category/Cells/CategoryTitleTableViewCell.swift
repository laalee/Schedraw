//
//  CategoryTitleTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/4.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class CategoryTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateView(title: String?, enabled: Bool) {

        titleTextField.text = title

        titleTextField.isEnabled = enabled
    }

}

extension CategoryTitleTableViewCell: CategoryDelegate {

    func getContent<T>() -> T? {

        var title = titleTextField.text

        title = title?.trimmingCharacters(in: .whitespaces)

        if title == "" {
            
            return nil
        }

        return title as? T
    }

}

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

}

extension CategoryTitleTableViewCell: CategoryDelegate {

    func getContent() -> Any? {

        var title = titleTextField.text

        title = title?.trimmingCharacters(in: .whitespaces)

        if title == "" {
            
            return nil
        }

        return title
    }

}

//
//  DeleteTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/3.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

protocol DeleteDelegate: AnyObject {

    func deleteObject()
}

class DeleteTableViewCell: UITableViewCell {

    weak var delegate: DeleteDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func deletePressed(_ sender: Any) {

        self.delegate?.deleteObject()
    }
}

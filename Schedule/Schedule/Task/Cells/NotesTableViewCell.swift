//
//  NotesTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/3.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var notesLineView: UIView!

    @IBOutlet weak var notesBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        notesBackgroundView.setShadow()
    }

    func updateView(notes: String?, enabled: Bool) {

        if notesTextView.text == "" {

            notesTextView.text = notes
        }

        notesTextView.isEditable = enabled

        notesLineView.isHidden = !enabled
    }

}

extension NotesTableViewCell: TaskDelegate {

    func getContent<T>() -> T? {

        return notesTextView?.text as? T
    }

}

//
//  ItemCollectionViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/20.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var centerBackgroundView: UIView!

    @IBOutlet weak var leftBackgroundView: UIView!

    @IBOutlet weak var rightBackgroundView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setEvent(event: Event?) {
        
        if let event = event {

            titleLabel.text = event.title

            timeLabel.text = event.time

            centerBackgroundView.backgroundColor = event.type.color.getColor()

        } else {

            titleLabel.text = ""

            timeLabel.text = ""
            
            centerBackgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }

}

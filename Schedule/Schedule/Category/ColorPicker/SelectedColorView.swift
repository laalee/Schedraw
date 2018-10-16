//
//  SelectedColorView.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/15.
//  Copyright © 2018年 laalee. All rights reserved.
//

//swiftlint:disable variable_name

import UIKit

class SelectedColorView: UIView {

    var color: UIColor!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)

        setViewColor(color)
    }

    func setViewColor(_ color: UIColor) {

        self.color = color

        setBackgroundColor()
    }

    func setBackgroundColor() {

        backgroundColor = color
    }

}

//
//  ColorPickerTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/15.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class ColorPickerTableViewCell: UITableViewCell {

    @IBOutlet weak var colorPicker: SwiftHSVColorPicker!

    var selectedColor: UIColor = UIColor.white

    override func awakeFromNib() {
        super.awakeFromNib()

        // Setup Color Picker
        colorPicker.setViewColor(selectedColor)
    }

    func updateView(color: UIColor, enabled: Bool) {

        colorPicker.setViewColor(color)
    }

}

extension ColorPickerTableViewCell: CategoryDelegate {

    func getContent<T>() -> T? {

        return colorPicker.color as? T
    }

}

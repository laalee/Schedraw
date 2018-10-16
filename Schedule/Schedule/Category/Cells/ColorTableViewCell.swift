//
//  ColorTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/4.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {

    @IBOutlet weak var colorPicker: SwiftHSVColorPicker!

    @IBOutlet weak var orangeButton: UIButton!

    @IBOutlet weak var pinkButton: UIButton!

    @IBOutlet weak var purpleButton: UIButton!

    @IBOutlet weak var blueButton: UIButton!

    @IBOutlet weak var yellowButton: UIButton!

    @IBOutlet weak var greenButton: UIButton!

    @IBOutlet weak var pickerButton: UIButton!

    @IBOutlet weak var editView: UIView!

    @IBOutlet weak var colorBackgroundView: UIView!

    var selectedColor: UIColor?

    var selectedButton: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()

        editView.isHidden = true

//        setSelectedButton(button: orangeButton, color: UIColor.ANColor.orange)

        setSelectedButton(button: pickerButton, color: UIColor.orange)

        colorBackgroundView.setShadow()

        colorPicker.setViewColor(UIColor.orange)
    }

    func updateView(color: UIColor, enabled: Bool) {

        editView.isHidden = enabled

        switch color {

        case UIColor.ANColor.pink:
            setSelectedButton(button: pinkButton, color: color)

        case UIColor.ANColor.purple:
            setSelectedButton(button: purpleButton, color: color)

        case UIColor.ANColor.blue:
            setSelectedButton(button: blueButton, color: color)

        case UIColor.ANColor.yellow:
            setSelectedButton(button: yellowButton, color: color)

        case UIColor.ANColor.green:
            setSelectedButton(button: greenButton, color: color)

        case UIColor.ANColor.orange:
            setSelectedButton(button: orangeButton, color: color)

        default:

            colorPicker.setViewColor(color)

            setSelectedButton(button: pickerButton, color: color)
        }
    }

    @IBAction func pickerButtonPressed(_ sender: Any) {

        setSelectedButton(button: pickerButton, color: nil)
    }

    @IBAction func orangeButtonPressed(_ sender: UIButton) {

        setSelectedButton(button: sender, color: UIColor.ANColor.orange)
    }

    @IBAction func pinkButtonPressed(_ sender: UIButton) {

        setSelectedButton(button: sender, color: UIColor.ANColor.pink)
    }

    @IBAction func purpleButtonPressed(_ sender: UIButton) {

        setSelectedButton(button: sender, color: UIColor.ANColor.purple)
    }

    @IBAction func blueButtonPressed(_ sender: UIButton) {

        setSelectedButton(button: sender, color: UIColor.ANColor.blue)
    }

    @IBAction func yellowButtonPressed(_ sender: UIButton) {

        setSelectedButton(button: sender, color: UIColor.ANColor.yellow)
    }

    @IBAction func greenButtonPressed(_ sender: UIButton) {

        setSelectedButton(button: sender, color: UIColor.ANColor.green)
    }

    func setSelectedButton(button: UIButton, color: UIColor?) {

        self.selectedColor = color

        selectedButton?.isSelected = false

        selectedButton = button

        selectedButton?.isSelected = true
    }

}

extension ColorTableViewCell: CategoryDelegate {

    func getContent<T>() -> T? {

        if let color = selectedColor {

            return color as? T

        }

        return colorPicker.color as? T

//        return selectedColor as? T
    }

}

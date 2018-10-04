//
//  ColorTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/4.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {

    @IBOutlet weak var orangeButton: UIButton!

    var selectedColor: UIColor?

    var selectedButton: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()

        setSelectedButton(button: orangeButton, color: UIColor.ANColor.orange)
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

    func setSelectedButton(button: UIButton, color: UIColor) {

        self.selectedColor = color

        selectedButton?.isSelected = false

        selectedButton = button

        selectedButton?.isSelected = true
    }

}

extension ColorTableViewCell: CategoryDelegate {

    func getContent() -> Any? {

        return selectedColor
    }

}

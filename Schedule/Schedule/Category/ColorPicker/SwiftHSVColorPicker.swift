//
//  SwiftHSVColorPicker.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/15.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

open class SwiftHSVColorPicker: UIView, ColorWheelDelegate {

    var colorWheel: ColorWheel!
    var selectedColorView: SelectedColorView!

    open var color: UIColor!
    var hue: CGFloat = 1.0
    var saturation: CGFloat = 1.0
    var brightness: CGFloat = 1.0

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.backgroundColor = UIColor.clear
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    open func setViewColor(_ color: UIColor) {

        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0

        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        if !ok {
            print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>")
        }

        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.color = color

        setup()
    }

    func setup() {

        // Remove all subviews
        let views = self.subviews

        for view in views {

            view.removeFromSuperview()
        }

        // let color wheel get the maximum size that is not overflow from the frame for both width and height
        let colorWheelSize = min(self.bounds.width, self.bounds.height)

        let selectedColorViewHeight: CGFloat = colorWheelSize * 0.5

        // let the all the subviews stay in the middle of universe horizontally
        let centeredX = (self.bounds.width - colorWheelSize) / 2.0

        // Init new ColorWheel subview
        colorWheel = ColorWheel(
            frame: CGRect(x: centeredX,
                          y: (self.bounds.height - colorWheelSize)/2,
                          width: colorWheelSize,
                          height: colorWheelSize),
            color: self.color,
            nonTouchedRadius: selectedColorViewHeight/2)

        colorWheel.delegate = self

        // Add colorWheel as a subview of this view
        self.addSubview(colorWheel)

        // Init SelectedColorView subview
        selectedColorView = SelectedColorView(
            frame: CGRect(x: (self.bounds.width - selectedColorViewHeight) / 2,
                          y:(self.bounds.height - selectedColorViewHeight) / 2,
                          width: selectedColorViewHeight,
                          height: selectedColorViewHeight),
            color: self.color)

        selectedColorView.layer.cornerRadius = selectedColorViewHeight / 2

        // Add selectedColorView as a subview of this view
        self.addSubview(selectedColorView)
    }

    func hueAndSaturationSelected(_ hue: CGFloat, saturation: CGFloat) {

        self.hue = hue

        self.saturation = saturation

        self.color = UIColor(hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0)

        selectedColorView.setViewColor(self.color)

        let selectColorNotification = Notification(
            name: Notification.Name("colorSelecting"),
            object: color,
            userInfo: nil)

        NotificationCenter.default.post(selectColorNotification)
    }

}

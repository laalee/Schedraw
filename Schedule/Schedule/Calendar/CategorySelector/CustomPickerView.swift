//
//  CustomPickerView.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/1.
//  Copyright © 2018年 laalee. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    class func displayPicker(onView: UIView) -> UIView {

        let size = CGSize(width: UIScreen.main.bounds.size.width,
                          height: UIScreen.main.bounds.size.height)

        let point = CGPoint(x: 0, y: 0)

        let pickerView = UIView.init(frame: CGRect(origin: point, size: size))

//        let pickerView = UIView.init(frame: onView.bounds)

        pickerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)

//        let size = CGSize(width: UIScreen.main.bounds.size.width,
//                          height: UIScreen.main.bounds.size.height / 3)
//
//        let point = CGPoint(x: 0,
//                            y: UIScreen.main.bounds.size.height * 2 / 3)
//
//        let frame = CGRect(origin: point, size: size)
//
//        let picker = UIPickerView.init(frame: frame)
//
//        picker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        DispatchQueue.main.async {

//            pickerView.addSubview(picker)

            onView.addSubview(pickerView)
        }

        return pickerView
    }

    class func removePicker(picker: UIView) {

        DispatchQueue.main.async {

            picker.removeFromSuperview()
        }
    }
}

//
//  UIView+AN.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/2.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

extension UIView {

    func setCornerRadius(value: CGFloat) {

        self.clipsToBounds = true
        
        self.layer.cornerRadius = value
    }

}

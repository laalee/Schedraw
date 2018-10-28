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

    func setShadow() {

        self.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.layer.masksToBounds = false
    }

    func setTitlebarShadow() {

        self.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0 )
        self.layer.masksToBounds = false
    }

}

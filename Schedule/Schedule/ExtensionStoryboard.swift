//
//  ExtensionStoryboard.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/20.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {

        get { return layer.cornerRadius }

        set {

            layer.cornerRadius = newValue

            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {

        get { return layer.borderWidth }

        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor? {

        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue?.cgColor }
    }

}

extension UILabel {

    @IBInspectable
    var letterSpace: CGFloat {

        set {

            let attributedString: NSMutableAttributedString!

            if let currentAttrString = attributedText {

                attributedString = NSMutableAttributedString(attributedString: currentAttrString)

            } else {

                attributedString = NSMutableAttributedString(string: text ?? "")

                text = nil
            }

            attributedString.addAttribute(NSAttributedString.Key.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))

            attributedText = attributedString
        }

        get {

            if let currentLetterSpace = attributedText?.attribute(
                NSAttributedString.Key.kern,
                at: 0,
                effectiveRange: .none
                ) as? CGFloat {

                return currentLetterSpace

            } else {

                return 0
            }
        }
    }
}

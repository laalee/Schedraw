//
//  CustomAlertView.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/23.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

protocol CustomAlertViewDelegate: AnyObject {

    func contentViewChanged()
}

class CustomAlertView: UIView {

    var backgroundView = UIView()

    var dialogView = UIView()

    weak var customAlertViewDelegate: CustomAlertViewDelegate?

    convenience init(title: String, contentView: UIView) {
        self.init(frame: UIScreen.main.bounds)

        initialize(title: title, contentView: contentView)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    func initialize(title: String, contentView: UIView) {

        let dialogViewWidth = frame.width - 64

        setBackgroundView()

        let titleLabel = customTitleLabel(title: title, width: dialogViewWidth - 16)

        let separatorLineView = customSeparatorLineView(
                separatorLineY: titleLabel.frame.height + 8,
                width: dialogViewWidth)

        let contentViewY = separatorLineView.frame.origin.y
                         + separatorLineView.frame.height + 8
        setContentView(contentViewY: contentViewY,
                       width: dialogViewWidth - 16,
                       contentView: contentView)

        let secondSeparatorLineViewY = contentView.frame.origin.y
                                     + contentView.frame.height + 8
        let secondSeparatorLineView = customSeparatorLineView(
                separatorLineY: secondSeparatorLineViewY,
                width: dialogViewWidth)

        let okButtonY = secondSeparatorLineView.frame.origin.y
                      + secondSeparatorLineView.frame.height + 8
        let okButton = customOkButton(okButtonY: okButtonY,
                                      width: dialogViewWidth)

        let dialogViewHeight = titleLabel.frame.height
                             + separatorLineView.frame.height
                             + contentView.frame.height
                             + secondSeparatorLineView.frame.height
                             + okButton.frame.height
                             + 40
        setDialogView(dialogViewHeight: dialogViewHeight)

        addSubview(backgroundView)
        dialogView.addSubview(titleLabel)
        dialogView.addSubview(separatorLineView)
        dialogView.addSubview(contentView)
        dialogView.addSubview(secondSeparatorLineView)
        dialogView.addSubview(okButton)
        addSubview(dialogView)
    }

    @objc func didTappedOnBackgroundView() {

        dismiss(animated: true)
    }

    func setBackgroundView() {

        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(didTappedOnBackgroundView)))
    }

    func setContentView(contentViewY: CGFloat, width: CGFloat, contentView: UIView) {

        contentView.frame.origin = CGPoint(x: 8,
                                           y: contentViewY)
        contentView.frame.size = CGSize(width: width,
                                        height: width)
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
    }

    func setDialogView(dialogViewHeight: CGFloat) {

        dialogView.clipsToBounds = true
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-64,
                                       height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
    }

    func customTitleLabel(title: String, width: CGFloat) -> UILabel {

        let titleLabel = UILabel()

        titleLabel.frame.origin = CGPoint(x: 8, y: 8)
        titleLabel.frame.size = CGSize(width: width, height: 30)

        titleLabel.text = title
        titleLabel.textAlignment = .center

        return titleLabel
    }

    func customSeparatorLineView(separatorLineY: CGFloat, width: CGFloat) -> UIView {

        let separatorLineView = UIView()

        separatorLineView.frame.origin = CGPoint(x: 0, y: separatorLineY)
        separatorLineView.frame.size = CGSize(width: width, height: 1)

        separatorLineView.backgroundColor = UIColor.groupTableViewBackground

        return separatorLineView
    }

    func customOkButton(okButtonY: CGFloat, width: CGFloat) -> UIButton {

        let okButton = UIButton()

        okButton.frame.origin = CGPoint(x: 0, y: okButtonY)
        okButton.frame.size = CGSize(width: width, height: 30)

        okButton.setTitle("OK", for: .normal)
        okButton.setTitleColor(UIColor.black, for: .normal)
        okButton.setTitleColor(UIColor.darkGray, for: .highlighted)

        okButton.addTarget(self, action: #selector(contentViewChanged), for: .touchUpInside)

        return okButton
    }

    @objc func contentViewChanged() {

        customAlertViewDelegate?.contentViewChanged()

        dismiss(animated: true)
    }

}

extension CustomAlertView: Modal {
    
}

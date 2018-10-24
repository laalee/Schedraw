//
//  CustomAlertView.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/23.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class CustomAlertView: UIView {

    var backgroundView = UIView()

    var dialogView = UIView()

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
        addSubview(backgroundView)

        let titleLabel = customTitleLabel(title: title, width: dialogViewWidth)
        dialogView.addSubview(titleLabel)

        let separatorLineView = customSeparatorLineView(
            separatorLineY: titleLabel.frame.height + 8,
            width: dialogViewWidth)
        dialogView.addSubview(separatorLineView)

        let contentViewY = separatorLineView.frame.height + separatorLineView.frame.origin.y + 8
        setContentView(contentViewY: contentViewY,
                       width: dialogViewWidth - 16,
                       contentView: contentView)
        dialogView.addSubview(contentView)

//        let imageView = customImageView(
//            imageViewY: separatorLineView.frame.height + separatorLineView.frame.origin.y + 8,
//            width: dialogViewWidth - 16,
//            image: image)
//        dialogView.addSubview(imageView)

//        let contentView =

        let titleHeight = titleLabel.frame.height
        let separatorHeight = separatorLineView.frame.height
//        let imageHeight = imageView.frame.height
        let contentViewHeight = contentView.frame.height
        let blank: CGFloat = 24
        let dialogViewHeight = titleHeight + separatorHeight + contentViewHeight + blank
        setDialogView(dialogViewHeight: dialogViewHeight)
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

        let titleLabel = UILabel(frame: CGRect(x: 8,
                                               y: 8,
                                               width: width - 16,
                                               height: 30))
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

    func customImageView(imageViewY: CGFloat, width: CGFloat, image: UIImage) -> UIImageView {

        let imageView = UIImageView()

        imageView.frame.origin = CGPoint(x: 8,
                                         y: imageViewY)
        imageView.frame.size = CGSize(width: width,
                                      height: width)
        imageView.image = image
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true

        return imageView
    }

}

extension CustomAlertView: Modal {
    
}

//
//  CustomAnimationView.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/27.
//  Copyright © 2018 laalee. All rights reserved.
//

import UIKit
import Lottie

class CustomAnimationView: UIView {

    var lotAnimationView: LOTAnimationView?

    convenience init(jsonFile: String) {
        self.init(frame: UIScreen.main.bounds)

        initialize(jsonFile: jsonFile)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    func initialize(jsonFile: String) {

        lotAnimationView = LOTAnimationView(name: jsonFile)

        let screenSize = UIScreen.main.bounds.size

        let baseView = UIView(frame: CGRect(x: 0, y: 0,
                                            width: screenSize.width, height: screenSize.height))

        baseView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)

        lotAnimationView?.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        lotAnimationView?.center = baseView.center

        lotAnimationView?.contentMode = .scaleAspectFill

        lotAnimationView?.animationSpeed = 2

        if let lotAnimationView = lotAnimationView {

            baseView.addSubview(lotAnimationView)
        }

        addSubview(baseView)
    }

}

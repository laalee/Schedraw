//
//  GlobalConstants.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/24.
//  Copyright © 2018 laalee. All rights reserved.
//

import UIKit

enum GlobalConstants {
    static let cardHighlightedFactor: CGFloat = 0.96
    static let statusBarAnimationDuration: TimeInterval = 0.4
    static let cardCornerRadius: CGFloat = 16
    static let dismissalAnimationDuration = 0.6

    static let cardVerticalExpandingStyle: CardVerticalExpandingStyle = .fromTop

    static let isEnabledWeirdTopInsetsFix = true

    static let isEnabledDebugAnimatingViews = false

    static let isEnabledTopSafeAreaInsetsFixOnCardDetailViewController = false

    static let isEnabledAllowsUserInteractionWhileHighlightingCard = true

    static let isEnabledDebugShowTimeTouch = true
}

extension GlobalConstants {
    enum CardVerticalExpandingStyle {

        case fromTop

        case fromCenter
    }
}

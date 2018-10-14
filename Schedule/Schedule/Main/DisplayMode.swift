//
//  DisplayMode.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/14.
//  Copyright © 2018年 laalee. All rights reserved.
//

import Foundation
import UIKit

class DisplayModeManager {

    static var shared = DisplayModeManager()

    var displayMode: DisplayMode = .dayMode

    func getCurrentMode() -> DisplayMode {

        return displayMode
    }

    func updateMode() {

        let nightMode = UserDefaults.standard.bool(forKey: "NIGHT_MODE")

        displayMode = nightMode ? .nightMode: .dayMode
    }

    func getMainColor() -> UIColor {

        return displayMode.mainColor()
    }

    func getSubColor() -> UIColor {

        return displayMode.subColor()
    }

    func getTextColor() -> UIColor {

        return displayMode.textColor()
    }
}

enum DisplayMode {

    case dayMode

    case nightMode

    func mainColor() -> UIColor {

        switch self {

        case .dayMode: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        case .nightMode: return #colorLiteral(red: 0.2549019608, green: 0.231372549, blue: 0.3725490196, alpha: 1)
        }
    }

    func subColor() -> UIColor {

        switch self {

        case .dayMode: return #colorLiteral(red: 0.9725490196, green: 0.9803921569, blue: 0.9803921569, alpha: 1)

        case .nightMode: return #colorLiteral(red: 0.2196078431, green: 0.2, blue: 0.3058823529, alpha: 1)
        }
    }

    func textColor() -> UIColor {

        switch self {

        case .dayMode: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        case .nightMode: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }

}

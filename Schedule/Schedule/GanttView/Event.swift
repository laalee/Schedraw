//
//  Event.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/27.
//  Copyright © 2018年 laalee. All rights reserved.
//

import Foundation
import UIKit

struct Event {

    var title: String

    var type: EventType

    var date: Date

    var time: String?
}

struct EventType {

    var title: String

    var color: TypeColor
}

enum TypeColor {

    case orange
    case pink
    case purple
    case blue
    case yellow

    func getColor() -> UIColor {

        switch self {

        case .pink: return #colorLiteral(red: 0.9098039216, green: 0.2980392157, blue: 0.5215686275, alpha: 1)

        case .blue: return #colorLiteral(red: 0.3019607843, green: 0.7725490196, blue: 0.9450980392, alpha: 1)

        case .orange: return #colorLiteral(red: 0.9882352941, green: 0.5882352941, blue: 0.3490196078, alpha: 1)

        case .purple: return #colorLiteral(red: 0.5098039216, green: 0.3725490196, blue: 0.7254901961, alpha: 1)

        case .yellow: return #colorLiteral(red: 0.9921568627, green: 0.7137254902, blue: 0.2431372549, alpha: 1)
        }
    }
}
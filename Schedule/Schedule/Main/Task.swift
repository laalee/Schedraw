//
//  Task.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/27.
//  Copyright © 2018年 laalee. All rights reserved.
//

import Foundation
import UIKit

struct Task {

    var title: String

    var category: CategoryMO

    var date: Date

    var startDate: Date?

    var endDate: Date?

    var consecutiveStatus: Int?

    var consecutiveId: Int?

    var time: String?

    var note: String?
}

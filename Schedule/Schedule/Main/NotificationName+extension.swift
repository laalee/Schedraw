//
//  NotificationName+extension.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/11/16.
//  Copyright © 2018 laalee. All rights reserved.
//

import Foundation

extension Notification.Name {

    static let dismissAlertPicker = Notification.Name("DISMISS_ALERT_PICKER")

    static let updateDailyConstraint = Notification.Name("UPDATE_DAILY_CONSTRAINT")

    static let yearChanged = Notification.Name("YEAR_CHANGED")

    static let setupPickerCategorys = Notification.Name("SETUP_PICKER_CATEGORYS")

    static let showAlertPicker = Notification.Name("SHOW_ALERT_PICKER")

    static let updateCategorys = Notification.Name("UPDATE_CATEGORYS")

    static let updateTasks = Notification.Name("UPDATE_TASKS")

    static let dailyTaskUpdate = Notification.Name("DAILY_TASK_UPDATE")

    static let monthTaskUpdate = Notification.Name("MONYH_TASK_UPDATE")

    static let scrollToToday = Notification.Name("SCROLL_TO_TODAY")
}

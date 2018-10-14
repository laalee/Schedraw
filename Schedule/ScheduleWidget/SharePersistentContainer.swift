//
//  SharePersistentContainer.swift
//  ScheduleWidget
//
//  Created by HsinYuLi on 2018/10/14.
//  Copyright © 2018年 laalee. All rights reserved.
//

import Foundation
import CoreData

class SharePersistentContainer: NSPersistentContainer {

    override class func defaultDirectoryURL() -> URL {

        return FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.laalee.Schedule")!
    }

    override init(name: String, managedObjectModel model: NSManagedObjectModel) {
        super.init(name: name, managedObjectModel: model)
    }
}

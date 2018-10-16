//
//  AppDelegate.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/19.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit
import CoreData
import Firebase
//import Fabric
//import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {

        FirebaseApp.configure()

//        Fabric.with([Crashlytics.self])

        window?.tintColor = #colorLiteral(red: 0.9921568627, green: 0.4156862745, blue: 0.4431372549, alpha: 1)
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = SharePersistentContainer(name: "Schedule")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

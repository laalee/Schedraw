//
//  CategoryManager.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/4.
//  Copyright © 2018年 laalee. All rights reserved.
//

import Foundation
import UIKit

class CategoryManager {

    static let shared = CategoryManager()

    var dataProvider: CoreDataProvider!

    init(dataProvider: CoreDataProvider) {

        self.dataProvider = dataProvider
    }

    convenience init() {

        self.init(dataProvider: CoreDataProvider())
    }

    func addCategory(id: Int, title: String, color: UIColor) {

        dataProvider.addCategory(id: id, title: title, color: color)
    }

    func updateCategory(categoryMO: CategoryMO, title: String, color: UIColor) {

        dataProvider.updateCategory(objectID: categoryMO.objectID, title: title, color: color)
    }

    func deleteCategory(categoryMO: CategoryMO) {

        dataProvider.deleteObject(objectID: categoryMO.objectID)
    }

    func getAllCategory() -> [CategoryMO]? {

        return dataProvider.fetchAllCategory()
    }

    func numberOfCategory() -> Int {

        return dataProvider.fetchAllCategory().count
    }
}

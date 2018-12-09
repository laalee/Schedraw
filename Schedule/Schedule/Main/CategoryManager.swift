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

    let dataProvider = CoreDataProvider()

    func addCategory(id: Int, title: String, color: UIColor) {

        dataProvider.addCategory(id: id, title: title, color: color)
    }

    func updateCategory(categoryMO: CategoryMO, title: String, color: UIColor) {

        dataProvider.updateCategory(categoryMO: categoryMO, title: title, color: color)
    }

    func deleteCategory(categoryMO: CategoryMO) {

        dataProvider.deleteCategory(categoryMO: categoryMO)
    }

    func getAllCategory() -> [CategoryMO]? {

        return dataProvider.fetchAllCategory()
    }

    func numberOfCategory() -> Int {

        return dataProvider.fetchAllCategory().count
    }
}

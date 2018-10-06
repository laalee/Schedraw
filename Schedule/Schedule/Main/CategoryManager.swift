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

    static let share = CategoryManager()

    let dataProvider = CoreDataProvider()

    func addCategory(id: Int, title: String, color: UIColor) {

        let category = Category(id: id, title: title, color: color)

        dataProvider.addCategory(category: category)
    }

    func updateCategory(categoryMO: CategoryMO, title: String, color: UIColor) {

        let category = Category(id: Int(categoryMO.id), title: title, color: color)

        dataProvider.updateCategory(categoryMO: categoryMO, category: category)
    }

    func deleteCategory(categoryMO: CategoryMO) {

        dataProvider.deleteCategory(categoryMO: categoryMO)
    }

    func getAllCategory() -> [CategoryMO]? {

        return dataProvider.fetchAllCategory()
    }

    func numberOfCategory() -> Int {

        return dataProvider.numberOfCategory()
    }
}

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

    func setCategory(id: Int, title: String, color: UIColor) {

        let category = Category(id: id, title: title, color: color)

        dataProvider.addCategory(category: category)
    }

    func getAllCategory(
        success: ([CategoryMO]) -> Void,
        failure: () -> Void
        ) {

        dataProvider.fetchAllCategory(success: { (result) in

            success(result)

        }, failure: {

            print("ERROR!! Get all category Fail!")
        })
    }

    func numberOfCategory() -> Int {

        return dataProvider.numberOfCategory()
    }
}

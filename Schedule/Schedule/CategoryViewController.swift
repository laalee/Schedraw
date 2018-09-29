//
//  CategoryViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/29.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    var eventType: EventType?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: Initialization

    class func detailViewControllerForCategory(eventType: EventType?) -> CategoryViewController {

        let storyboard = UIStoryboard(name: "Category", bundle: nil)

        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: "CategoryViewController")
            as? CategoryViewController else {

                return CategoryViewController()
        }

        viewController.eventType = eventType

        return viewController
    }

    @IBAction func saveCategory(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelPressed(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

}

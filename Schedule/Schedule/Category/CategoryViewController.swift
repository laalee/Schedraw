//
//  CategoryViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/29.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryTableView: UITableView!

    let identifiers = [
        String(describing: CategoryTitleTableViewCell.self),
        String(describing: ColorTableViewCell.self),
        String(describing: DeleteTableViewCell.self)
    ]
    
    var eventType: EventType?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
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

    func setupTableView() {

        categoryTableView.dataSource = self

        categoryTableView.delegate = self

        for identifier in identifiers {

            categoryTableView.register(
                UINib(nibName: identifier, bundle: nil),
                forCellReuseIdentifier: identifier)
        }
    }

    @IBAction func saveCategory(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelPressed(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

}

extension CategoryViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return identifiers.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: identifiers[indexPath.section], for: indexPath)

        switch indexPath.section {

        case 0:
            guard let titleCell = cell as? CategoryTitleTableViewCell else { return cell }

            return titleCell

        case 1:
            guard let colorCell = cell as? ColorTableViewCell else { return cell }

            return colorCell

        default:
            guard let deleteCell = cell as? DeleteTableViewCell else { return cell }

            return deleteCell
        }
    }

}

extension CategoryViewController: UITableViewDelegate {

}

//
//  CategoryViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/29.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

protocol CategoryDelegate: AnyObject {

    func getContent() -> Any?
}

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryTableView: UITableView!

    @IBOutlet weak var pageTitleLabel: UILabel!

    @IBOutlet weak var editButton: UIButton!

    var identifiers = [
        String(describing: CategoryTitleTableViewCell.self),
        String(describing: ColorTableViewCell.self)
    ]

    weak var titleDelegate: CategoryDelegate?

    weak var colorDelegate: CategoryDelegate?

    var category: CategoryMO?

    var newCategory: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    // MARK: Initialization

    class func detailViewControllerForCategory(category: CategoryMO?) -> CategoryViewController {

        let storyboard = UIStoryboard(name: "Category", bundle: nil)

        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: "CategoryViewController")
            as? CategoryViewController else {

                return CategoryViewController()
        }

        viewController.category = category

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

        guard let newTitle = titleDelegate?.getContent() as? String else {

            showToast()

            return
        }

        guard let newColor = colorDelegate?.getContent() as? UIColor else { return }

        if newCategory {

            let newId = CategoryManager.share.numberOfCategory() + 1

            CategoryManager.share.addCategory(id: newId, title: newTitle, color: newColor)
        }

        dismiss(animated: true, completion: nil)
    }

    @IBAction func editCategory(_ sender: UIButton) {

        self.newCategory = false

        self.editButton.isHidden = true

        identifiers.append(String(describing: DeleteTableViewCell.self))

        setupTableView()

        categoryTableView.reloadData()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    func showToast() {

        let alertToast = UIAlertController(
            title: "Save failed!",
            message: "Title should not be blank.",
            preferredStyle: .alert
        )

        present(alertToast, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            alertToast.dismiss(animated: false, completion: nil)
        }
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

            self.titleDelegate = titleCell

            guard let category = self.category else {

                self.editButton.isHidden = true

                return titleCell
            }

            if editButton.isHidden {

                titleCell.updateView(title: category.title, enabled: true)

            } else {

                titleCell.updateView(title: category.title, enabled: false)

                self.pageTitleLabel.text = category.title
            }

            return titleCell

        case 1:
            guard let colorCell = cell as? ColorTableViewCell else { return cell }

            self.colorDelegate = colorCell

            guard let category = self.category else { return colorCell }

            guard let color = category.color as? UIColor else { return colorCell}

            if editButton.isHidden {

                colorCell.updateView(color: color, enabled: true)

            } else {

                colorCell.updateView(color: color, enabled: false)
            }

            return colorCell

        default:
            guard let deleteCell = cell as? DeleteTableViewCell else { return cell }

            deleteCell.delegate = self

            return deleteCell
        }
    }

}

extension CategoryViewController: UITableViewDelegate {

}

extension CategoryViewController: DeleteDelegate {

    func deleteObject() {

        guard let category = self.category else { return }

        let id = Int(category.id)

        CategoryManager.share.deleteCategory(id: id)

        dismiss(animated: true, completion: nil)
    }

}

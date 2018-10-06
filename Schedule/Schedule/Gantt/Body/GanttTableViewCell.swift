//
//  GanttTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/20.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class GanttTableViewCell: UITableViewCell {

    @IBOutlet weak var itemCollectionView: UICollectionView!

    @IBOutlet weak var tableViewTitleLabel: UILabel!

    @IBOutlet weak var addButton: UIButton!

    var numberOfCells: Int = 60

    var todayIndex: Int = 30

    var postFlag: Bool = false

    var category: CategoryMO?

    let currentDate = Date()

    var dateComponents = DateComponents()

    var dateformatter = DateFormatter()

    let dateManager = DateManager.share
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupCollectionView()

        collectionViewDidScroll()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))

        tableViewTitleLabel.addGestureRecognizer(gestureRecognizer)
    }

    private func addBottomCells() {

        self.numberOfCells += 30

        UIView.performWithoutAnimation {

            self.itemCollectionView.reloadData()
        }
    }

    private func addTopCells() {

        self.numberOfCells += 30

        self.todayIndex += 30

        UIView.performWithoutAnimation {

            self.itemCollectionView.reloadData()

            self.itemCollectionView.scrollToItem(
                at: IndexPath(row: 32, section: 0),
                at: UICollectionView.ScrollPosition.left,
                animated: false
            )
        }
    }

    private func collectionViewDidScroll() {

        let name = NSNotification.Name("DID_SCROLL")

        _ = NotificationCenter.default.addObserver(
            forName: name, object: nil, queue: nil) { (notification) in

            guard let userInfo = notification.userInfo else { return }

            guard let contentOffset = userInfo["contentOffset"] as? CGFloat else { return }

            self.itemCollectionView.contentOffset.x = contentOffset
        }
    }

    private func setupCollectionView() {

        itemCollectionView.dataSource = self

        (itemCollectionView as UIScrollView).delegate = self

        itemCollectionView.showsHorizontalScrollIndicator = false

        let identifier = String(describing: ItemCollectionViewCell.self)

        let uiNib = UINib(nibName: identifier, bundle: nil)

        itemCollectionView.register(uiNib, forCellWithReuseIdentifier: identifier)
    }

    func setCategoryTitle(category: CategoryMO?) {

        self.category = category

        tableViewTitleLabel.text = category?.title
    }

    @objc func tapAction() {

        let selectedCategory: CategoryMO? = self.category

        let categoryViewController = CategoryViewController.detailViewControllerForCategory(category: selectedCategory)

        self.window?.rootViewController?.show(categoryViewController, sender: nil)
    }

}

extension GanttTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("annie GanttTableViewCell numberOfCells: \(numberOfCells)")
        return dateManager.numberOfDates()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ItemCollectionViewCell.self), for: indexPath)

        guard let eventCell = cell as? ItemCollectionViewCell else { return cell }

        guard let category = self.category else {

            eventCell.setTask(task: nil)

            return cell
        }

        let date = dateManager.getDate(atIndex: indexPath.row)

        let task = TaskManager.share.fetchTask(byCategory: category, date: date)

        eventCell.setTask(task: task?.first)

        return eventCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        print(indexPath)

        guard let selectedCategory = self.category else { return }

        let selectedDate = dateManager.getDate(atIndex: indexPath.row)
        print("Gantt - indexPath.row: ", indexPath.row)
        print("Gantt - selectedDate: ", selectedDate)

        let taskViewController = TaskViewController.detailViewControllerForTask(
            category: selectedCategory,
            date: selectedDate
        )

        self.window?.rootViewController?.show(taskViewController, sender: nil)
    }

}

extension GanttTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

//        let visibleItem = itemCollectionView.visibleCells
//
//        for item in visibleItem {
//
//            guard let item = item as? ItemCollectionViewCell else { break }
//
//            guard let task = item.task else { break }
//
//            if let status = task.consecutiveStatus {
//
//                print(status)
//            }
//        }
//
//        updateConsecutiveLabel()
    }
}

extension GanttTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

extension GanttTableViewCell: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        self.postFlag = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        self.postFlag = decelerate
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        self.postFlag = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if postFlag {

            let name = NSNotification.Name("DID_SCROLL")

            NotificationCenter.default.post(
                name: name,
                object: nil,
                userInfo: ["contentOffset": scrollView.contentOffset.x]
            )
        }

        if scrollView.contentOffset.x < 100 {

            addTopCells()

        } else if scrollView.contentOffset.x > (scrollView.contentSize.width - UIScreen.main.bounds.size.width - 100) {

            addBottomCells()

            scrollView.bounds.origin = CGPoint(x: 200, y: 200)
        }
    }

}

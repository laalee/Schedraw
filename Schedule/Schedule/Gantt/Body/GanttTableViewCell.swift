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

    var todayIndex: Int = 30

    var postFlag: Bool = false

    var category: CategoryMO?

    let currentDate = Date()

    var dateComponents = DateComponents()

    var dateformatter = DateFormatter()

    let dateManager = DateManager.share

    var subLabels: [UILabel] = []

    var selectedIndexPath: IndexPath?

    let circleView = UIView()

    var originFrame: CGRect?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupCollectionView()

        collectionViewDidScroll()

        updateDatas()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))

        tableViewTitleLabel.addGestureRecognizer(gestureRecognizer)
    }

    func reloadItemCollectionView() {

        subLabels.forEach { (subLabel) in

            subLabel.removeFromSuperview()
        }

        self.subLabels = []

        self.itemCollectionView.reloadData()
    }

    private func updateDatas() {

        let name = NSNotification.Name("UPDATE_TASKS")

        _ = NotificationCenter.default.addObserver(
        forName: name, object: nil, queue: nil) { (_) in

            self.reloadItemCollectionView()

            self.itemCollectionView.collectionViewLayout.invalidateLayout()
        }
    }

    private func addBottomCells() {

        UIView.performWithoutAnimation {

            self.reloadItemCollectionView()
        }
    }

    private func addTopCells() {

        self.todayIndex += 30

        UIView.performWithoutAnimation {

            self.reloadItemCollectionView()

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

    func addSubLabel(task: TaskMO, indexPathRow: Int) {

        let label = UILabel()
        label.text = task.title
        label.font = UIFont(name: label.font.fontName, size: 12)
        label.textColor = UIColor.white

        guard let startDate = task.date as? Date else { return }

        guard let lastDate = task.endDate as? Date else { return }

        let consecutive = DateManager.share.consecutiveDay(startDate: startDate, lastDate: lastDate)

        label.frame = CGRect(x: 50 * indexPathRow + 25, y: 0, width: consecutive * 50, height: 50)

        subLabels.append(label)

        self.itemCollectionView.addSubview(label)
    }

}

extension GanttTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

        let task = TaskManager.share.fetchTask(byCategory: category, andDate: date)

        eventCell.setTask(task: task?.first)

        guard let firstTask = task?.first else { return eventCell }

        let consecutiveStatus = firstTask.consecutiveStatus

        if consecutiveStatus == TaskManager.firstDay {

            addSubLabel(task: firstTask, indexPathRow: indexPath.row)
        }

        return eventCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let selectedCategory = self.category else { return }

        let selectedDate = dateManager.getDate(atIndex: indexPath.row)

        let taskViewController = TaskViewController.detailViewControllerForTask(
            category: selectedCategory,
            date: selectedDate
        )

//        guard let cell = itemCollectionView.cellForItem(at: indexPath) as? ItemCollectionViewCell else { return }
//
//        cell.freezeAnimations()
//
//        let currentCellFrame = cell.layer.presentation()!.frame
//
//        let cardPresentationFrameOnScreen = cell.superview!.convert(currentCellFrame, to: nil)
//
//        let cardFrameWithoutTransform = { () -> CGRect in
//            let center = cell.center
//            let size = cell.bounds.size
//            let rect = CGRect(
//                x: center.x - size.width / 2,
//                y: center.y - size.height / 2,
//                width: size.width,
//                height: size.height
//            )
//            return cell.superview!.convert(rect, to: nil)
//        }()
//
//        let params = CardTransition.Params(fromCardFrame: cardPresentationFrameOnScreen,
//                                           fromCardFrameWithoutTransform: cardFrameWithoutTransform,
//                                           fromCell: cell)
//
//        let transition = CardTransition(params: params)
//        taskViewController.transitioningDelegate = transition

        taskViewController.taskAnimationDelegate = self

        taskViewController.transitioningDelegate = self

        presentAnimation(indexPath: indexPath) {

            self.window?.rootViewController?.show(taskViewController, sender: nil)
        }

//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
//
//            self.window?.rootViewController?.show(taskViewController, sender: nil)
//        })
    }

    func presentAnimation(indexPath: IndexPath,
                          completion: @escaping () -> Void) {

        guard let cell = itemCollectionView.cellForItem(at: indexPath) as? ItemCollectionViewCell else { return }

        let rootView = self.window?.rootViewController?.view

        let rect1 = cell.centerBackgroundView.convert(cell.centerBackgroundView.frame, from: cell.contentView)

        let rect2 = cell.centerBackgroundView.convert(rect1, to: rootView)

        originFrame = rect2

        circleView.frame = rect2

        circleView.cornerRadius = rect2.height / 2

        circleView.clipsToBounds = true

        circleView.backgroundColor = self.category?.color as? UIColor

        UIView.animate(withDuration: 0.3, animations: {

            let screenSize = UIScreen.main.bounds.size
            let viewHeight = screenSize.height - rect2.minY > rect2.minY ? screenSize.height - rect2.minY: rect2.minY
            let viewWidth = screenSize.width - rect2.minX > rect2.minX ? screenSize.width - rect2.minX: rect2.minX

            let viewLength = sqrt(viewHeight * viewHeight + viewWidth * viewWidth)

            self.circleView.cornerRadius = viewLength

            self.circleView.frame = CGRect(x: rect2.minX - viewLength,
                                y: rect2.minY - viewLength,
                                width: viewLength * 2,
                                height: viewLength * 2)

        }, completion: { _ in

            completion()
        })

        rootView?.addSubview(circleView)
    }

    func dismissAnimation() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {

                UIView.animate(withDuration: 0.3, animations: {

                    guard let originFrame = self.originFrame else { return }

                    self.circleView.cornerRadius = originFrame.height / 2

                    self.circleView.frame = originFrame

                }, completion: { _ in

                    self.circleView.removeFromSuperview()
                })
        })

    }

}

extension GanttTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
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
        }
    }

}

extension GanttTableViewCell: UIViewControllerTransitioningDelegate {

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return FadePushAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return FadePushAnimator()
    }
}

extension GanttTableViewCell: TaskAnimationDelegate {

    func dismissTaskViewController() {

        dismissAnimation()
    }

}

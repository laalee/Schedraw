//
//  HeaderTableViewCell.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/21.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewHeaderFooterView {

    @IBOutlet weak var dateCollectionView: UICollectionView!

    @IBOutlet weak var monthLabel: UILabel!

    weak var scrollDelegate: GanttScrollDelegate?

    var dates: [Date] = []

    var todayIndex: Int = 30

    var postFlag: Bool = false

    var currentYear: String = ""

    var currentMonth: String = ""

    let dateManager = DateManager.shared

    override func awakeFromNib() {
        super.awakeFromNib()

        setupCollectionView()

        setCurrentDate()

        gotoToday()

        dateManager.addDates(from: -todayIndex, to: todayIndex)
    }

    func gotoToday() {

        _ = NotificationCenter.default.addObserver(
        forName: .scrollToToday, object: nil, queue: nil) { (_) in

            let scrollView = self.dateCollectionView as UIScrollView

            let offset = scrollView.contentOffset
            self.dateCollectionView.setContentOffset(offset, animated: false)

            scrollView.bounds.origin = CGPoint(x: self.todayIndex * 50, y: 0)

            self.scrollDelegate?.didScroll(to: CGPoint(x: self.todayIndex * 50, y: 0))

        }
    }

    func addBottomCells() {

        dateManager.addDates(from: dateManager.numberOfDates() - todayIndex,
                             to: dateManager.numberOfDates() - todayIndex + 29)

        UIView.performWithoutAnimation {

            self.dateCollectionView.reloadData()
        }
    }

    func addTopCells() {

        dateManager.addEarlyDates(from: -todayIndex - 30, to: -todayIndex - 1)

        self.todayIndex += 30

        UIView.performWithoutAnimation {

            self.dateCollectionView.reloadData()

            let scrollView = self.dateCollectionView as UIScrollView

            scrollView.bounds.origin = CGPoint(x: 32 * 50, y: 0)
        }
    }

    private func setupCollectionView() {

        dateCollectionView.dataSource = self

        (dateCollectionView as UIScrollView).delegate = self

        dateCollectionView.showsHorizontalScrollIndicator = false

        let identifier = String(describing: DateCollectionViewCell.self)

        let uiNib = UINib(nibName: identifier, bundle: nil)

        dateCollectionView.register(uiNib, forCellWithReuseIdentifier: identifier)
    }

    func setCurrentDate() {

        let currentDate = Date()

        let dateFormatter = DateFormatter()

        dateFormatter.locale = Locale(identifier: "en_US")

        dateFormatter.dateFormat = "YYYY"

        currentYear = dateFormatter.string(from: currentDate)

        dateFormatter.dateFormat = "MMM"

        currentMonth = dateFormatter.string(from: currentDate)

        monthLabel.text = currentMonth
    }

    func updateMonthAndYear() {

        let visibleIndexPath = dateCollectionView.indexPathsForVisibleItems

        guard let firstIndexPath = visibleIndexPath.min() else { return }

        guard let item = dateCollectionView.cellForItem(at: firstIndexPath) as? DateCollectionViewCell else { return }

        let date = dateManager.getDate(atIndex: firstIndexPath.row)

        let itemMonth = item.getMonth(date: date)

        if currentMonth != itemMonth {

            currentMonth = itemMonth

            monthLabel.text = currentMonth
        }

        let itemYear = item.getYear(date: date)

        if currentYear != itemYear {

            currentYear = itemYear

            NotificationCenter.default.post(
                name: .yearChanged,
                object: nil,
                userInfo: ["year": itemYear]
            )
        }
    }
    
}

extension HeaderTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return dateManager.numberOfDates()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: DateCollectionViewCell.self), for: indexPath)

        guard let eventCell = cell as? DateCollectionViewCell else { return cell }

        let date = dateManager.getDate(atIndex: indexPath.row)

        eventCell.setContent(date: date)

        return eventCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let selectedDate = dateManager.getDate(atIndex: indexPath.row)
    }

}

extension HeaderTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

        updateMonthAndYear()
    }

}

extension HeaderTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }

}

extension HeaderTableViewCell: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        self.postFlag = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        self.postFlag = decelerate
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        self.postFlag = false
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        self.postFlag = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        scrollDelegate?.didScroll(to: scrollView.contentOffset)
    }

}

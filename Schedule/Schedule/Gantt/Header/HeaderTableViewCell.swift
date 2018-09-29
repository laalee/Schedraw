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

    var numberOfCells: Int = 60

    var todayIndex: Int = 30

    var postFlag: Bool = false

    var currentYear: String = ""

    var currentMonth: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionViewDidScroll()

        setupCollectionView()

        setCurrentDate()

        gotoToday()
    }

    func gotoToday() {

        let name = NSNotification.Name("SCROLL_TO_TODAY")

        _ = NotificationCenter.default.addObserver(
        forName: name, object: nil, queue: nil) { (_) in

            self.postFlag = true

            let index = IndexPath.init(row: self.todayIndex, section: 0)

            self.dateCollectionView.scrollToItem(at: index, at: .left, animated: true)
        }
    }

    private func addBottomCells() {

        self.numberOfCells += 30

        UIView.performWithoutAnimation {

            self.dateCollectionView.reloadData()
        }
    }

    private func addTopCells() {

        self.numberOfCells += 30

        self.todayIndex += 30

        UIView.performWithoutAnimation {

            self.dateCollectionView.reloadData()

            self.dateCollectionView.scrollToItem(
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

            self.dateCollectionView.contentOffset.x = contentOffset
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

    func getTheDate(componentsDay: Int) -> Date? {

        let currentDate = Date()

        var newDateComponents = DateComponents()

        newDateComponents.day = componentsDay

        guard let date = Calendar.current.date(
            byAdding: newDateComponents, to: currentDate) else { return nil }

        return date
    }

    func updateMonthAndYear() {

        let visibleIndexPath = dateCollectionView.indexPathsForVisibleItems

        guard let firstIndexPath = visibleIndexPath.min() else { return }

        guard let item = dateCollectionView.cellForItem(at: firstIndexPath) as? DateCollectionViewCell else { return }

        let itemMonth = item.getMonth()

        if currentMonth != itemMonth {

            currentMonth = itemMonth

            monthLabel.text = currentMonth
        }

        let itemYear = item.getYear()

        if currentYear != itemYear {

            currentYear = itemYear

            NotificationCenter.default.post(
                name: NSNotification.Name("YEAR_CHANGED"),
                object: nil,
                userInfo: ["year": item.getYear()]
            )
        }
    }
    
}

extension HeaderTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("annie HeaderTableViewCell numberOfCells: \(numberOfCells)")
        return numberOfCells
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: DateCollectionViewCell.self), for: indexPath)

        guard let eventCell = cell as? DateCollectionViewCell else { return cell }

        guard let date = getTheDate(componentsDay: indexPath.row - todayIndex) else { return eventCell }

        eventCell.date = date

        eventCell.setContent()

        return eventCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let item = dateCollectionView.cellForItem(at: indexPath) as? DateCollectionViewCell else { return }

//        let date = item.date
    }

}

extension HeaderTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        updateMonthAndYear()
    }

}

extension HeaderTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
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

        if postFlag {

            NotificationCenter.default.post(
                name: NSNotification.Name("DID_SCROLL"),
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

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

    let footerViewReuseIdentifier = "RefreshFooterView"

    var footerView: FooterCollectionReusableView?

    var numberOfCells: Int = 60

    var todayIndex: Int = 30

    var flag: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        addBottomCells()

//        addTopCells()

        collectionViewDidScroll()

        setupCollectionView()

        gotoToday()
    }

    func gotoToday() {

        let name = NSNotification.Name("SCROLL_TO_TODAY")

        _ = NotificationCenter.default.addObserver(
        forName: name, object: nil, queue: nil) { (_) in

            let todayIndex = IndexPath.init(row: self.todayIndex, section: 0)

            self.dateCollectionView.scrollToItem(at: todayIndex, at: .left, animated: true)

            self.flag = true
        }
    }

    private func addBottomCells() {

//        let name = NSNotification.Name("ADD_BOTTOM_CELLS")
//
//        _ = NotificationCenter.default.addObserver(
//        forName: name, object: nil, queue: nil) { (notification) in
//
//            guard let userInfo = notification.userInfo else { return }
//
//            guard let number = userInfo["number"] as? Int else { return }
//
//            print("annie dateCollectionView addBottomCells: \(number)")
//
//            var indexPaths: [IndexPath] = []
//
//            for _ in self.numberOfCells..<number {
//
//                let indexPath = IndexPath(item: self.numberOfCells - 1, section: 0)
//
//                indexPaths.append(indexPath)
//            }
//
//            self.numberOfCells = number
//
//            self.dateCollectionView.insertItems(at: indexPaths)
//        }

        UIView.performWithoutAnimation {

            self.numberOfCells += 30

            self.dateCollectionView.reloadData()
        }
    }

    private func addTopCells() {

//        let name = NSNotification.Name("ADD_TOP_CELLS")
//
//        _ = NotificationCenter.default.addObserver(
//        forName: name, object: nil, queue: nil) { (notification) in
//
//            guard let userInfo = notification.userInfo else { return }
//
//            guard let number = userInfo["number"] as? Int else { return }
//
//            print("annie dateCollectionView addTopCells: \(number)")
//
//            var indexPaths: [IndexPath] = []
//
//            for item in 0..<number {
//
//                let indexPath = IndexPath(item: item, section: 0)
//
//                indexPaths.append(indexPath)
//            }
//
//            self.numberOfCells += number
//
//            self.todayIndex += number
//
//            UIView.performWithoutAnimation {
//                self.dateCollectionView.reloadData()
//                self.dateCollectionView.scrollToItem(
//                    at: IndexPath(row: 35, section: 0),
//                    at: UICollectionView.ScrollPosition.left,
//                    animated: false
//                )
//            }
//
////            let index = IndexPath.init(row: 35, section: 0)
////
////            self.dateCollectionView.scrollToItem(at: index, at: .left, animated: false)
//        }

        //--------
        self.numberOfCells += 30

        self.todayIndex += 30

        UIView.performWithoutAnimation {
            self.dateCollectionView.reloadData()
            self.dateCollectionView.scrollToItem(
                at: IndexPath(row: 35, section: 0),
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

        let footerIdentifier = String(describing: FooterCollectionReusableView.self)

        let footerNib = UINib(nibName: footerIdentifier, bundle: nil)

        dateCollectionView.register(
            footerNib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: footerViewReuseIdentifier
        )
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

        let date = indexPath.row - todayIndex

        eventCell.titleLabel.text = String(date)

        return eventCell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)

        guard let footerView = view as? FooterCollectionReusableView else {
            return view
        }

        self.footerView = footerView

        return footerView
    }

}

extension HeaderTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

//        if indexPath.row == numberOfCells - 10 {
//
//            print("annie load bottom -------\(indexPath.row)")
//
//            let name = NSNotification.Name("ADD_BOTTOM_CELLS")
//
//            NotificationCenter.default.post(name: name, object: nil, userInfo: ["number": self.numberOfCells + 30])
//
//        } else if indexPath.row == 5 && flag {
//
//            print("annie load top -------\(indexPath.row)")
//
//            let name = NSNotification.Name("ADD_TOP_CELLS")
//
//            NotificationCenter.default.post(name: name, object: nil, userInfo: ["number": 30])
//        }

    }
}

extension HeaderTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {

        return CGSize(width: 10, height: 50)
    }
}

extension HeaderTableViewCell: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

//        let name = NSNotification.Name("DID_SCROLL")
//
//        NotificationCenter.default.post(
//            name: name,
//            object: nil,
//            userInfo: ["contentOffset": scrollView.contentOffset.x]
//        )

        if scrollView.contentOffset.x < 50 {

            addTopCells()

        } else if scrollView.contentOffset.x > (scrollView.contentSize.width - UIScreen.main.bounds.size.width - 50) {

            addBottomCells()
        }
    }

}

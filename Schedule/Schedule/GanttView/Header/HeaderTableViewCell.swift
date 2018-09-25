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

    var postFlag: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()

        collectionViewDidScroll()

        setupCollectionView()

        gotoToday()
    }

    func gotoToday() {

        let name = NSNotification.Name("SCROLL_TO_TODAY")

        _ = NotificationCenter.default.addObserver(
        forName: name, object: nil, queue: nil) { (_) in

            self.postFlag = true

            let todayIndex = IndexPath.init(row: self.todayIndex, section: 0)

            self.dateCollectionView.scrollToItem(at: todayIndex, at: .left, animated: true)
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

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        self.postFlag = true

        print("anniee HEADER BeginDragging, postFlag = \(postFlag)")
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        self.postFlag = decelerate

        print("anniee HEADER decelerate: \(decelerate), postFlag = \(postFlag)")
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        self.postFlag = false

        print("anniee HEADER EndDecelerating, postFlag = \(postFlag)")
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        self.postFlag = false

        print("anniee HEADER EndScrollingAnimation, postFlag = \(postFlag)")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if postFlag {

//            print("anniee HEADER: \(scrollView.contentOffset.x)")

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

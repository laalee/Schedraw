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

    let footerViewReuseIdentifier = "RefreshFooterView"

    var footerView: FooterCollectionReusableView?

    var numberOfCells: Int = 60

    var postFlag: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupCollectionView()

        collectionViewDidScroll()
    }

    private func addBottomCells() {

        self.numberOfCells += 30

        UIView.performWithoutAnimation {

            self.itemCollectionView.reloadData()
        }
    }

    private func addTopCells() {

        self.numberOfCells += 30

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

        let footerIdentifier = String(describing: FooterCollectionReusableView.self)

        let footerNib = UINib(nibName: footerIdentifier, bundle: nil)

        itemCollectionView.register(
            footerNib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: footerViewReuseIdentifier
        )
    }
    
}

extension GanttTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("annie GanttTableViewCell numberOfCells: \(numberOfCells)")
        return numberOfCells
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ItemCollectionViewCell.self), for: indexPath)

        guard let eventCell = cell as? ItemCollectionViewCell else { return cell }

        eventCell.titleLabel.text = "\(indexPath.row)"

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

extension GanttTableViewCell: UICollectionViewDelegate {

}

extension GanttTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {

        return CGSize(width: 10, height: 50)
    }
}

extension GanttTableViewCell: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        self.postFlag = true

        print("anniee \(tableViewTitleLabel.text!): BeginDragging, postFlag = \(postFlag)")
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        self.postFlag = decelerate

        print("anniee \(tableViewTitleLabel.text!): decelerate: \(decelerate), postFlag = \(postFlag)")
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        self.postFlag = false

        print("anniee \(tableViewTitleLabel.text!): EndDecelerating, postFlag = \(postFlag)")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if postFlag {

//            print("anniee \(tableViewTitleLabel.text!): \(scrollView.contentOffset.x)")

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

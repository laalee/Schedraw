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

    let footerViewReuseIdentifier = "RefreshFooterView"

    var footerView: FooterCollectionReusableView?

    var numberOfCells: Int = 50
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupCollectionView()

        updateNumberOfCells()

        collectionViewDidScroll()

        plusACell()
    }

    private func updateNumberOfCells() {

        let name = NSNotification.Name("UPDATE_ITEM_CELLS")

        _ = NotificationCenter.default.addObserver(
            forName: name, object: nil, queue: nil) { (notification) in

            guard let userInfo = notification.userInfo else { return }

            guard let number = userInfo["number"] as? Int else { return }

                print("number: \(number)")


                var indexPaths: [IndexPath] = []

                for _ in self.numberOfCells..<number {

                    let indexPath = IndexPath(item: self.numberOfCells - 1, section: 0)

                    indexPaths.append(indexPath)
                }

                self.numberOfCells = number

                self.itemCollectionView.insertItems(at: indexPaths)
        }
    }

    private func plusACell() {

        let name = NSNotification.Name("ADD_ITEM")

        _ = NotificationCenter.default.addObserver(
        forName: name, object: nil, queue: nil) { (notification) in

            self.numberOfCells += 1

            var indexPaths: [IndexPath] = []

            let indexPath = IndexPath(item: self.numberOfCells - 1, section: 0)

            indexPaths.append(indexPath)

            self.itemCollectionView.insertItems(at: indexPaths)
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

//    func collectionView(_ collectionView: UICollectionView,
//                        willDisplay cell: UICollectionViewCell,
//                        forItemAt indexPath: IndexPath) {
//
//        if indexPath.row == numberOfCells - 10 {
//
//            print("load-------\(indexPath.row)")
//
//            let name = NSNotification.Name("UPDATE_ITEM_CELLS")
//
//            NotificationCenter.default.post(name: name, object: nil, userInfo: ["number": self.numberOfCells + 50])
//
//        }
//    }

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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let name = NSNotification.Name("DID_SCROLL")

        NotificationCenter.default.post(
            name: name,
            object: nil,
            userInfo: ["contentOffset": scrollView.contentOffset.x]
        )
    }

}

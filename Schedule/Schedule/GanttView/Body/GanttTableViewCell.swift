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

    var numberOfCells: Int = 60
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupCollectionView()

//        addBottomCells()

//        addTopCells()

        collectionViewDidScroll()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("annie point: \(point), event: \(event)")

        return nil
    }

    private func addBottomCells() {

//        let name = NSNotification.Name("ADD_BOTTOM_CELLS")
//
//        _ = NotificationCenter.default.addObserver(
//            forName: name, object: nil, queue: nil) { (notification) in
//
//                guard let userInfo = notification.userInfo else { return }
//
//                guard let number = userInfo["number"] as? Int else { return }
//
//                print("annie itemCollectionView addBottomCells: \(number)")
//
//                var indexPaths: [IndexPath] = []
//
//                for item in self.numberOfCells..<number {
//
//                    let indexPath = IndexPath(item: item - 1, section: 0)
//
//                    indexPaths.append(indexPath)
//                }
//
//                self.numberOfCells = number
//
//                self.itemCollectionView.insertItems(at: indexPaths)
//        }

        UIView.performWithoutAnimation {

            self.numberOfCells += 30

            self.itemCollectionView.reloadData()
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
//            print("annie itemCollectionView addTopCells: \(number)")
//
//            var indexPaths: [IndexPath] = []
//
//            for _ in 0..<number {
//
//                let indexPath = IndexPath(item: 0, section: 0)
//
//                indexPaths.append(indexPath)
//            }
//
//            self.numberOfCells += number
//
//            self.itemCollectionView.insertItems(at: indexPaths)
//        }

        UIView.performWithoutAnimation {

            self.numberOfCells += 30

            self.itemCollectionView.reloadData()

            self.itemCollectionView.scrollToItem(
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

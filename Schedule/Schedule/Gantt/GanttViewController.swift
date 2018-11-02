//
//  GanttViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/20.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class GanttViewController: UIViewController {

    @IBOutlet weak var ganttTableView: UITableView!

    var firstFlag: Bool = true

    var header: HeaderTableViewCell?

    var emptyRows: Int = 0

    var categorys: [CategoryMO] = []

    fileprivate var sourceIndexPath: IndexPath?

    fileprivate var snapshot: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        getCategorys()

        updateDatas()

//        let longPress = UILongPressGestureRecognizer(
//            target: self,
//            action: #selector(longPressGestureRecognized(longPress:)))
//
//        self.ganttTableView.addGestureRecognizer(longPress)
    }

    @objc func longPressGestureRecognized(longPress: UILongPressGestureRecognizer) {

        let state = longPress.state

        let cellLocation = longPress.location(in: ganttTableView)

        guard let rowIndexPath = ganttTableView.indexPathForRow(at: cellLocation) else { return }

        guard let cell = ganttTableView.cellForRow(at: rowIndexPath)
            as? GanttTableViewCell else { return }

        let itemLocation = longPress.location(in: cell.itemCollectionView)

        guard let itemIndexPath = cell.itemCollectionView.indexPathForItem(at: itemLocation) else { return }

        guard let item = cell.itemCollectionView.cellForItem(at: itemIndexPath)
            as? ItemCollectionViewCell else { return }

        switch state {

        case .began:

            sourceIndexPath = itemIndexPath

            longPressBegan(item: item)

        case .changed:

            longPressChanged(location: cellLocation, itemIndexPath: itemIndexPath)

        default:

//            guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
//
//            guard let snapshot = self.snapshot else { return }
//
//            cell.isHidden = false
//            cell.alpha = 0.0
//            UIView.animate(withDuration: 0.25, animations: {
//                snapshot.center = cell.center
//                snapshot.transform = CGAffineTransform.identity
//                snapshot.alpha = 0
//                cell.alpha = 1
//            }, completion: { (finished) in
                self.cleanup()
//            })
        }
    }

    func longPressBegan(item: ItemCollectionViewCell) {

        snapshot = customSnapshotFromView(inputView: item.centerBackgroundView)

        guard let snapshot = self.snapshot else { return }

        let center = CGPoint(x: item.center.x - 20, y: item.center.y - 20)

        snapshot.center = center

        snapshot.alpha = 0.0

        UIView.animate(withDuration: 0.25, animations: {

            snapshot.center = center

            snapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)

            snapshot.alpha = 0.98

            item.alpha = 0.0

        }, completion: { _ in

             item.centerBackgroundView.backgroundColor = UIColor.lightGray
        })

        self.view.addSubview(snapshot)

        self.view.layoutIfNeeded()
    }

    func longPressChanged(location: CGPoint, itemIndexPath: IndexPath) {

        guard let snapshot = self.snapshot else { return }

        var center = snapshot.center
        center.y = location.y - 25
        center.x = location.x - 25
        snapshot.center = center

        guard let sourceIndexPath = self.sourceIndexPath else { return }

        if itemIndexPath != sourceIndexPath {

            print("itemIndexPath: ", itemIndexPath, "sourceIndexPath: ", sourceIndexPath)
            self.sourceIndexPath = itemIndexPath
        }

    }

    private func cleanup() {

        self.sourceIndexPath = nil

        snapshot?.removeFromSuperview()

        self.snapshot = nil
    }

    private func customSnapshotFromView(inputView: UIView) -> UIView? {

        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)

        if let currentContext = UIGraphicsGetCurrentContext() {

            inputView.layer.render(in: currentContext)
        }

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {

            UIGraphicsEndImageContext()

            return nil
        }

        UIGraphicsEndImageContext()

        let snapshot = UIImageView(image: image)

        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0
        snapshot.layer.shadowOffset = CGSize(width: -5, height: 0)
        snapshot.layer.shadowRadius = 5
        snapshot.layer.shadowOpacity = 0.4

        return snapshot
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.layoutIfNeeded()

        if firstFlag {

            scrollToToday(animated)

            firstFlag = false
        }

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateEmptyCells()
    }

    private func setupTableView() {

        ganttTableView.dataSource = self

        ganttTableView.delegate = self

        // task cell

        let identifier = String(describing: GanttTableViewCell.self)

        let uiNib = UINib(nibName: identifier, bundle: nil)

        ganttTableView.register(uiNib, forCellReuseIdentifier: identifier)

        // header cell

        let headerIdentifier = String(describing: HeaderTableViewCell.self)

        let headerNib = UINib(nibName: headerIdentifier, bundle: nil)

        ganttTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: headerIdentifier)
    }

    @IBAction func scrollToToday(_ sender: Any) {

        let name = NSNotification.Name("SCROLL_TO_TODAY")

        NotificationCenter.default.post(name: name, object: nil)
    }

    func getCategorys() {

        guard let categorys = CategoryManager.share.getAllCategory() else { return }

        self.categorys = categorys
    }

    func updateEmptyCells() {

        let tableViewHeight = Int(ganttTableView.frame.size.height)

        self.emptyRows = (tableViewHeight / 50) - categorys.count

        if emptyRows <= 0 {

            emptyRows = 1
        }

        ganttTableView.reloadData()
    }

    private func updateDatas() {

        let name = NSNotification.Name("UPDATE_CATEGORYS")

        _ = NotificationCenter.default.addObserver(
        forName: name, object: nil, queue: nil) { (_) in

            self.getCategorys()

            self.updateEmptyCells()
        }
    }

}

extension GanttViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categorys.count + emptyRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: GanttTableViewCell.self), for: indexPath)

        guard let ganttCell = cell as? GanttTableViewCell else {
            return cell
        }

        if indexPath.row < categorys.count {

            ganttCell.setCategoryTitle(category: categorys[indexPath.row])
            ganttCell.addButton.isHidden = true
            ganttCell.tableViewTitleLabel.isHidden = false

        } else {

            ganttCell.setCategoryTitle(category: nil)
            ganttCell.addButton.isHidden = indexPath.row != categorys.count
            ganttCell.tableViewTitleLabel.isHidden = indexPath.row != categorys.count
        }

        ganttCell.tableViewTitleLabel.isUserInteractionEnabled = true

        ganttCell.reloadItemCollectionView()

        return ganttCell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: HeaderTableViewCell.self))

        guard let headerView = view as? HeaderTableViewCell else {
            return view
        }

        self.header = headerView

        return headerView
    }

}

extension GanttViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 51
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 51
    }

}

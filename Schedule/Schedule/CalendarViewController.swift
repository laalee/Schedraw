//
//  ScheduleViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/20.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var ganttCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }

    private func setupCollectionView() {

        ganttCollectionView.dataSource = self

        ganttCollectionView.delegate = self

        let identifier = String(describing: EventCollectionViewCell.self)

        let uiNib = UINib(nibName: identifier, bundle: nil)

        ganttCollectionView.register(uiNib, forCellWithReuseIdentifier: identifier)
    }

    override func viewWillAppear(_ animated: Bool) {

        view.layoutIfNeeded()

        gotoToday(UIButton())
    }

    @IBAction func gotoToday(_ sender: UIButton) {

        let todayIndex = IndexPath.init(row: 0, section: 30)

        ganttCollectionView.scrollToItem(at: todayIndex, at: .left, animated: true)
    }

}

extension CalendarViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 90
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: EventCollectionViewCell.self), for: indexPath)

        guard let eventCell = cell as? EventCollectionViewCell else { return cell }

        eventCell.titleLabel.text = "\(indexPath.row), \(indexPath.section)"

        return eventCell
    }

}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 40, height: 40)
    }
}

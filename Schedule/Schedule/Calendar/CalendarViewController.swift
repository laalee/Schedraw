//
//  ScheduleViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/20.
//  Copyright © 2018年 laalee. All rights reserved.
//

//swiftlint:disable variable_name

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!

    @IBOutlet weak var dailyTaskView: UIView!

    @IBOutlet weak var dailyTaskHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var dailyTaskBottomConstraint: NSLayoutConstraint!

    var currentMonthIndex: Int = 5

    var calendarDates: [[Date?]] = []

    var currentYear: Int = Calendar.current.component(.year, from: Date())

    var currentMonth = Calendar.current.component(.month, from: Date())

    var currentDate = DateManager.share.transformDate(date: Date())

    var pickerBackground: UIView!

    var dailyTaskIndex: IndexPath?

    var monthTaskSection: Int?

    var categorys: [Any] = []

    var selectedCategory: CategoryMO?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()

        getDates()

        updateDatas()

        updateCategorys()

        setSelectCategory()

        dailyTaskHeightConstraint.constant = UIScreen.main.bounds.height * 2 / 5

        dailyTaskView.layer.shadowColor = #colorLiteral(red: 0.741996612, green: 0.741996612, blue: 0.741996612, alpha: 1)
        dailyTaskView.layer.shadowOpacity = 0.5
        dailyTaskView.layer.shadowRadius = 5.0
        dailyTaskView.layer.shadowOffset = CGSize(width: 0, height: 0 )
        dailyTaskView.layer.masksToBounds = false
    }

    func getCategorys() {

        guard let categorys = CategoryManager.share.getAllCategory() else { return }

        NotificationCenter.default.post(
            name: NSNotification.Name("SETUP_PICKER_CATEGORYS"),
            object: nil,
            userInfo: ["categorys": categorys]
        )
    }

    private func updateCategorys() {

        let name = NSNotification.Name("UPDATE_CATEGORYS")

        _ = NotificationCenter.default.addObserver(
        forName: name, object: nil, queue: nil) { (_) in

            self.getCategorys()

            self.calendarCollectionView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.layoutIfNeeded()

        scrollToToday()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        getCategorys()

        calendarCollectionView.collectionViewLayout.invalidateLayout()
    }

    private func setupCollectionView() {

        calendarCollectionView.dataSource = self

        calendarCollectionView.delegate = self

        // day cell

        let dayIdentifier = String(describing: DayCollectionViewCell.self)

        let dayNib = UINib(nibName: dayIdentifier, bundle: nil)

        calendarCollectionView.register(dayNib, forCellWithReuseIdentifier: dayIdentifier)

        // month cell

        let monthIdentifier = String(describing: MonthCollectionViewCell.self)

        let monthNib = UINib(nibName: monthIdentifier, bundle: nil)

        calendarCollectionView.register(
            monthNib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: monthIdentifier
        )
    }

    @IBAction func goToday(_ sender: Any) {

        scrollToToday()
    }

    private func scrollToToday() {

        let indexPath = IndexPath.init(row: 0, section: currentMonthIndex)

        guard let attributes =
            calendarCollectionView.layoutAttributesForSupplementaryElement(
                ofKind: UICollectionView.elementKindSectionHeader,
                at: indexPath
            ) else { return }

        self.calendarCollectionView.setContentOffset(
            CGPoint(x: 0, y: attributes.frame.origin.y - calendarCollectionView.contentInset.top),
            animated: true
        )
    }

    private func updateDatas() {

        let name = NSNotification.Name("UPDATE_TASKS")

        _ = NotificationCenter.default.addObserver(
        forName: name, object: nil, queue: nil) { (_) in

            self.calendarCollectionView.reloadData()

            self.calendarCollectionView.collectionViewLayout.invalidateLayout()
        }
    }

    private func getDates() {

        for month in (-currentMonthIndex)...currentMonthIndex {

            let theDate = dateByAddingMonth(componentsMonth: month)

            let year = Calendar.current.component(.year, from: theDate)

            let month = Calendar.current.component(.month, from: theDate)

            let weekDay = firseWeekDayInTheMonth(year: year, month: month)

            let numberOfDays = numberOfDaysInTheMonth(date: theDate)

            var datesInMonth: [Date?] = []

            for _ in 0..<(weekDay - 1) {

                datesInMonth.append(nil)
            }

            for theDay in 1...(numberOfDays) {

                var date = gatTheDate(year: year, month: month, days: theDay)

                date = DateManager.share.transformDate(date: date)

                datesInMonth.append(date)
            }

            for _ in 1 ... -(datesInMonth.count % 7 - 7) {

                datesInMonth.append(nil)
            }

            self.calendarDates.append(datesInMonth)
        }
    }

    private func dateByAddingMonth(componentsMonth: Int) -> Date {

        let currentDate = Date()

        var newDateComponents = DateComponents()

        newDateComponents.month = componentsMonth

        guard let date = Calendar.current.date(
            byAdding: newDateComponents, to: currentDate) else { return Date() }

        return date
    }

    private func numberOfDaysInTheMonth(date: Date) -> Int {

        let range = Calendar.current.range(of: .day, in: .month, for: date)

        return range?.count ?? 0
    }

    private func firseWeekDayInTheMonth(year: Int, month: Int) -> Int {

        let dateComponents = DateComponents(year: year, month: month)

        guard let date = Calendar.current.date(from: dateComponents) else { return 0 }

        return Calendar.current.component(.weekday, from: date)
    }

    private func gatTheDate(year: Int, month: Int, days: Int) -> Date {

        var components = DateComponents()

        components.year = year
        components.month = month
        components.day = days

        guard let date = Calendar.current.date(from: components) else { return Date() }

        return date
    }

    private func addTopCells() {

        self.currentMonthIndex += 6

        let firstMonth = -currentMonthIndex

        let lastMonyh = firstMonth + 5

        for month in (firstMonth...lastMonyh).reversed() {

            let theDate = dateByAddingMonth(componentsMonth: month)

            let year = Calendar.current.component(.year, from: theDate)

            let month = Calendar.current.component(.month, from: theDate)

            let weekDay = firseWeekDayInTheMonth(year: year, month: month)

            let numberOfDays = numberOfDaysInTheMonth(date: theDate)

            var datesInMonth: [Date?] = []

            for _ in 0..<(weekDay - 1) {

                datesInMonth.append(nil)
            }

            for theDay in 1...(numberOfDays) {

                let date = gatTheDate(year: year, month: month, days: theDay)

                datesInMonth.append(date)
            }

            for _ in 1 ... -(datesInMonth.count % 7 - 7) {

                datesInMonth.append(nil)
            }

            self.calendarDates.insert(datesInMonth, at: 0)
        }

        UIView.performWithoutAnimation {

            self.calendarCollectionView.reloadData()

            self.calendarCollectionView.scrollToItem(
                at: IndexPath(row: 14, section: 6),
                at: UICollectionView.ScrollPosition.top,
                animated: false
            )
        }
    }

    private func addBottomCells() {

        let firstMonth = calendarDates.count - currentMonthIndex

        let lastMonyh = firstMonth + 5

        for month in firstMonth...lastMonyh {

            let theDate = dateByAddingMonth(componentsMonth: month)

            let year = Calendar.current.component(.year, from: theDate)

            let month = Calendar.current.component(.month, from: theDate)

            let weekDay = firseWeekDayInTheMonth(year: year, month: month)

            let numberOfDays = numberOfDaysInTheMonth(date: theDate)

            var datesInMonth: [Date?] = []

            for _ in 0..<(weekDay - 1) {

                datesInMonth.append(nil)
            }

            for theDay in 1...(numberOfDays) {

                let date = gatTheDate(year: year, month: month, days: theDay)

                datesInMonth.append(date)
            }

            for _ in 1 ... -(datesInMonth.count % 7 - 7) {

                datesInMonth.append(nil)
            }

            self.calendarDates.append(datesInMonth)
        }

        UIView.performWithoutAnimation {

            self.calendarCollectionView.reloadData()

        }
    }

    func fetchByDate(indexPath: IndexPath) {

        guard let theDate = calendarDates[indexPath.section][indexPath.row] else {

            self.dailyTaskIndex = nil

            self.monthTaskSection = nil

            self.dailyTaskBottomConstraint.constant = 0

            UIView.animate(withDuration: 0.3) {

                self.view.layoutIfNeeded()
            }

            return
        }

        var tasks: [TaskMO]?

        if let category = self.selectedCategory {

            tasks = TaskManager.share.fetchTask(byCategory: category, andDate: theDate)

        } else {

            tasks = TaskManager.share.fetchTask(byDate: theDate)
        }

        if tasks?.count != 0 && dailyTaskIndex != indexPath {

            self.dailyTaskIndex = indexPath

            self.dailyTaskBottomConstraint.constant = dailyTaskView.bounds.height

            NotificationCenter.default.post(
                name: NSNotification.Name("DAILY_TASK_UPDATE"),
                object: nil,
                userInfo: ["task": tasks as Any, "selectedCategory": self.selectedCategory as Any]
            )

            let indexPath = IndexPath.init(row: indexPath.row, section: indexPath.section)

            if let item = calendarCollectionView.cellForItem(at: indexPath) {
                self.calendarCollectionView.setContentOffset(
                    CGPoint(x: 0, y: item.frame.origin.y - calendarCollectionView.contentInset.top),
                    animated: true
                )
            }

        } else {

            self.dailyTaskIndex = nil

            self.monthTaskSection = nil

            self.dailyTaskBottomConstraint.constant = 0
        }

        UIView.animate(withDuration: 0.3) {

            self.view.layoutIfNeeded()
        }
    }

    @objc func tapMonthAction(sender: UIButton) {

        var tasks: [TaskMO] = []

        for date in calendarDates[sender.tag] {

            if let date = date {

                if let category = self.selectedCategory {

                    if let task = TaskManager.share.fetchTask(byCategory: category, andDate: date) {

                        tasks += task
                    }
                } else {

                    if let task = TaskManager.share.fetchTask(byDate: date) {

                        tasks += task
                    }
                }
            }
        }

        if tasks.count != 0 && monthTaskSection != sender.tag {

            self.monthTaskSection = sender.tag

            self.dailyTaskBottomConstraint.constant = dailyTaskView.bounds.height

            NotificationCenter.default.post(
                name: NSNotification.Name("MONYH_TASK_UPDATE"),
                object: nil,
                userInfo: ["task": tasks as Any, "selectedCategory": self.selectedCategory as Any]
            )

            let indexPath = IndexPath.init(row: 0, section: sender.tag)

            guard let attributes =
                calendarCollectionView.layoutAttributesForSupplementaryElement(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    at: indexPath
                ) else { return }

            self.calendarCollectionView.setContentOffset(
                CGPoint(x: 0, y: attributes.frame.origin.y - calendarCollectionView.contentInset.top),
                animated: true
            )
        } else {

            self.monthTaskSection = nil

            self.dailyTaskBottomConstraint.constant = 0
        }

        UIView.animate(withDuration: 0.3) {

            self.view.layoutIfNeeded()
        }
    }

    func setSelectCategory() {

        _ = NotificationCenter.default.addObserver(
            forName: NSNotification.Name("DISMISS_ALERT_PICKER"),
            object: nil, queue: nil) { (notification) in

                guard let userInfo = notification.userInfo else { return }

                if let category = userInfo["selectedCategory"] as? CategoryMO {

                    self.selectedCategory = category

                } else {

                    self.selectedCategory = nil
                }

                self.calendarCollectionView.reloadData()
        }
    }

    @IBAction func selectCategory(_ sender: Any) {

        NotificationCenter.default.post(
            name: NSNotification.Name("SHOW_ALERT_PICKER"),
            object: nil)
    }

}

extension CalendarViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return calendarDates.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return calendarDates[section].count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: DayCollectionViewCell.self), for: indexPath)

        guard let dayCell = cell as? DayCollectionViewCell else { return cell }

        dayCell.clearBackgroundViews()

        guard let theDate = calendarDates[indexPath.section][indexPath.row] else {

            dayCell.setDayLabel(date: nil)

            return dayCell
        }

        dayCell.setDayLabel(date: theDate)

        var tasks: [TaskMO]?

        if let selectedCategory = self.selectedCategory {

            tasks = TaskManager.share.fetchTask(byCategory: selectedCategory, andDate: theDate)

            dayCell.setCategoryTask(tasks: tasks)

        } else {

            tasks = TaskManager.share.fetchTask(byDate: theDate)

            dayCell.setTask(tasks: tasks)
        }

        if DateManager.share.formatDate(forTaskPage: theDate) ==
            DateManager.share.formatDate(forTaskPage: currentDate) {

//            dayCell.dayLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            if let text = dayCell.dayLabel.text {

                let textRange = NSMakeRange(0, text.count)

                let attributedText = NSMutableAttributedString(string: text)

                attributedText.addAttribute(
                    NSAttributedString.Key.underlineStyle ,
                    value: NSUnderlineStyle.single.rawValue,
                    range: textRange
                )

                dayCell.dayLabel.attributedText = attributedText
            }
        }

        return dayCell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {

            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: String(describing: MonthCollectionViewCell.self),
                for: indexPath
            )

            guard let headerView = view as? MonthCollectionViewCell else { return view }

            guard let date = calendarDates[indexPath.section][6] else { return view }

            let dateFormatter = DateFormatter()

            dateFormatter.locale = Locale(identifier: "en_US")

            dateFormatter.dateFormat = "YYYY"

            let year = dateFormatter.string(from: date)

            dateFormatter.dateFormat = "MMMM"

            let month = dateFormatter.string(from: date)

            headerView.monthButton.setTitle(year + " " + month, for: .normal)

            headerView.monthButton.tag = indexPath.section

            headerView.monthButton.addTarget(self, action: #selector(tapMonthAction(sender:)), for: .touchUpInside)

            return headerView
        }

        return UICollectionReusableView()

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        fetchByDate(indexPath: indexPath)
    }

}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = calendarCollectionView.frame.width / 7

        return CGSize(width: width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {

        let width = calendarCollectionView.frame.width

        return CGSize(width: width, height: 50)
    }

}

extension CalendarViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.y < 100 {

            addTopCells()

        } else if scrollView.contentOffset.y > (scrollView.contentSize.height - UIScreen.main.bounds.height - 100) {

            addBottomCells()
        }
    }

}

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

    var currentDate = DateManager.shared.transformDate(date: Date())

    var pickerBackground: UIView!

    var dailyTaskIndex: IndexPath?

    var monthTaskSection: Int?

    var categorys: [Any] = []

    var selectedCategory: CategoryMO?

    var timingFlag: Bool = true

    var taskShowing: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()

        getDates()

        registerObservers()

        dailyTaskHeightConstraint.constant = UIScreen.main.bounds.height * 2 / 5

        dailyTaskView.layer.shadowColor = #colorLiteral(red: 0.741996612, green: 0.741996612, blue: 0.741996612, alpha: 1)
        dailyTaskView.layer.shadowOpacity = 0.5
        dailyTaskView.layer.shadowRadius = 5.0
        dailyTaskView.layer.shadowOffset = CGSize(width: 0, height: 0 )
        dailyTaskView.layer.masksToBounds = false
    }

    func getCategorys() {

        guard let categorys = CategoryManager.shared.getAllCategory() else { return }

        NotificationCenter.default.post(
            name: .setupPickerCategorys,
            object: nil,
            userInfo: ["categorys": categorys]
        )
    }

    func registerObservers() {

        _ = NotificationCenter.default.addObserver(
            forName: .updateCategorys,
            object: nil,
            queue: nil) { (_) in

                self.getCategorys()

                self.calendarCollectionView.reloadData()
        }

        _ = NotificationCenter.default.addObserver(
            forName: .updateTasks,
            object: nil,
            queue: nil) { (_) in

                self.dailyTaskBottomConstraint.constant = 0

                self.calendarCollectionView.reloadData()

                self.calendarCollectionView.collectionViewLayout.invalidateLayout()
        }

        _ = NotificationCenter.default.addObserver(
            forName: .dismissAlertPicker,
            object: nil,
            queue: nil) { (notification) in

                self.setSelectCategory(notification)
        }

        _ = NotificationCenter.default.addObserver(
            forName: .updateDailyConstraint,
            object: nil,
            queue: nil) { (notification) in

                self.updateDailyTaskBottomConstraint(notification)
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

        let dayIdentifier = String(describing: DayCollectionViewCell.self)

        let dayNib = UINib(nibName: dayIdentifier, bundle: nil)

        calendarCollectionView.register(dayNib, forCellWithReuseIdentifier: dayIdentifier)

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

                date = DateManager.shared.transformDate(date: date)

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

            tasks = TaskManager.shared.fetchTask(byCategory: category, andDate: theDate)

        } else {

            tasks = TaskManager.shared.fetchTask(byDate: theDate)
        }

        if dailyTaskIndex != indexPath {

            self.dailyTaskIndex = indexPath

            if let count = tasks?.count {

                var height = CGFloat(count * 80 + 50)

                let viewHeight = dailyTaskView.bounds.height

                height = height > viewHeight ? viewHeight: height

                self.dailyTaskBottomConstraint.constant = height
            }

            NotificationCenter.default.post(
                name: .dailyTaskUpdate,
                object: nil,
                userInfo: ["task": tasks as Any, "selectedCategory": self.selectedCategory as Any]
            )

            self.taskShowing = true

            if tasks?.count == 0 {

                self.timingFlag = false

                self.taskShowing = false

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {

                    self.timingFlag = true
                }

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {

                    if self.timingFlag && !self.taskShowing {

                        self.dailyTaskBottomConstraint.constant = 0

                        UIView.animate(withDuration: 0.3) {

                            self.view.layoutIfNeeded()
                        }
                    }
                }
            } else {

                let indexPath = IndexPath.init(row: indexPath.row, section: indexPath.section)

                if let item = calendarCollectionView.cellForItem(at: indexPath) {

                    self.calendarCollectionView.setContentOffset(
                        CGPoint(x: 0, y: item.frame.origin.y - calendarCollectionView.contentInset.top),
                        animated: true
                    )
                }
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

                    if let task = TaskManager.shared.fetchTask(byCategory: category, andDate: date) {

                        tasks += task
                    }
                } else {

                    if let task = TaskManager.shared.fetchTask(byDate: date) {

                        tasks += task
                    }
                }
            }
        }

        if monthTaskSection != sender.tag {

            var filterTasks: [TaskMO] = []

            for task in tasks {

                var flag = true

                for filterTask in filterTasks
                    where filterTask.consecutiveId == task.consecutiveId && task.consecutiveId != 0 {

                    flag = false
                }

                if flag {

                    filterTasks.append(task)
                }
            }

            var height = CGFloat(filterTasks.count * 80 + 50)

            let viewHeight = dailyTaskView.bounds.height

            height = height > viewHeight ? viewHeight: height

            self.dailyTaskBottomConstraint.constant = height

            self.monthTaskSection = sender.tag

            NotificationCenter.default.post(
                name: .monthTaskUpdate,
                object: nil,
                userInfo: ["task": filterTasks as Any]
            )

            self.taskShowing = true

            if filterTasks.count == 0 {

                self.taskShowing = false

                self.timingFlag = false

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {

                    self.timingFlag = true
                }

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {

                    if self.timingFlag && !self.taskShowing {

                        self.dailyTaskBottomConstraint.constant = 0

                        UIView.animate(withDuration: 0.3) {

                            self.view.layoutIfNeeded()
                        }
                    }
                }
            }

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

    func setSelectCategory(_ notification: Notification) {

        guard let userInfo = notification.userInfo else { return }

        if let category = userInfo["selectedCategory"] as? CategoryMO {

            self.selectedCategory = category

        } else {

            self.selectedCategory = nil
        }

        self.calendarCollectionView.reloadData()
    }

    func updateDailyTaskBottomConstraint(_ notification: Notification) {

        guard let userInfo = notification.userInfo else { return }

        if let count = userInfo["taskCount"] as? Int {

            var height = CGFloat(count * 80 + 50)

            let viewHeight = self.dailyTaskView.bounds.height

            height = height > viewHeight ? viewHeight: height

            self.dailyTaskBottomConstraint.constant = height

            self.dailyTaskBottomConstraint.constant = height

        }
    }

    @IBAction func selectCategory(_ sender: Any) {

        NotificationCenter.default.post(
            name: .showAlertPicker,
            object: nil)

        self.dailyTaskBottomConstraint.constant = 0
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

            tasks = TaskManager.shared.fetchTask(byCategory: selectedCategory, andDate: theDate)

            dayCell.setCategoryTask(tasks: tasks)

        } else {

            tasks = TaskManager.shared.fetchTask(byDate: theDate)

            dayCell.setTask(tasks: tasks)
        }

        if DateManager.shared.formatDate(forTaskPage: theDate) ==
            DateManager.shared.formatDate(forTaskPage: currentDate) {

            if let text = dayCell.dayLabel.text {

                let textRange = NSRange(location: 0, length: text.count)

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

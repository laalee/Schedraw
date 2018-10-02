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

    @IBOutlet weak var categoryPickerView: UIPickerView!

    @IBOutlet weak var buttonView: UIView!

    var currentMonthIndex: Int = 5

    var calendarDates: [[Date?]] = []

    var currentYear: Int = Calendar.current.component(.year, from: Date())

    var currentMonth = Calendar.current.component(.month, from: Date())

    var pickerBackground: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()

        getDates()

        categoryPickerView.dataSource = self

        categoryPickerView.delegate = self

        self.categoryPickerView.isHidden = true

        self.buttonView.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {

        view.layoutIfNeeded()

        scrollToToday()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

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

                let date = gatTheDate(year: year, month: month, days: theDay)

                datesInMonth.append(date)
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

            self.calendarDates.append(datesInMonth)
        }

        UIView.performWithoutAnimation {

            self.calendarCollectionView.reloadData()

        }
    }

    @IBAction func selectCategory(_ sender: Any) {

        guard let parentView = self.parent?.view else { return }

        pickerBackground = UIViewController.displayPicker(onView: parentView)

        self.categoryPickerView.isHidden = false

        self.buttonView.isHidden = false
    }

    @IBAction func catrgoryDidSelect(_ sender: Any) {

        self.categoryPickerView.isHidden = true

        self.buttonView.isHidden = true

        UIViewController.removePicker(picker: pickerBackground)
    }

    @IBAction func cancelSelect(_ sender: Any) {

        self.categoryPickerView.isHidden = true

        self.buttonView.isHidden = true

        UIViewController.removePicker(picker: pickerBackground)
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

        guard let theDate = calendarDates[indexPath.section][indexPath.row] else {

            dayCell.dayLabel.text = ""

            dayCell.centerBackgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

            dayCell.secondCenterView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

            dayCell.thirdCenterView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

            return dayCell
        }

        let tasks = TaskManager.share.getTask(by: theDate)

        dayCell.setTask(tasks: tasks)

        let theday = Calendar.current.component(.day, from: theDate)

        dayCell.dayLabel.text = String(theday)

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

            headerView.monthLabel.text = year + " " + month

            return headerView
        }

        return UICollectionReusableView()

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)

        guard let theDate = calendarDates[indexPath.section][indexPath.row] else {
            return
        }

        let task = TaskManager.share.getTask(by: theDate)

        let theday = Calendar.current.component(.day, from: theDate)

        print("theday: \(theday), task: \(task)")
    }

}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = calendarCollectionView.frame.width / 7

        return CGSize(width: width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let width = calendarCollectionView.frame.width

        return CGSize(width: width, height: 50)
    }

}

extension CalendarViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.y < 100 {

            addTopCells()

        } else if scrollView.contentOffset.y > (scrollView.contentSize.height - UIScreen.main.bounds.size.height - 100) {

            addBottomCells()
        }
    }

}

extension CalendarViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return Data.share.getTypes().count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return Data.share.getTypes()[row].title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        let minute = row
        print("hour: \(minute)")
    }

}

extension CalendarViewController: UIPickerViewDelegate {

}

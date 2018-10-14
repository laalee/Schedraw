//
//  SettingViewController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/9/29.
//  Copyright © 2018年 laalee. All rights reserved.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController {

    @IBOutlet weak var settingTableView: UITableView!

    var identifiers = [
//        String(describing: DisplayTableViewCell.self),
        String(describing: SupportTableViewCell.self)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        setupColors()
    }

    func setupColors() {

        self.view.backgroundColor = DisplayModeManager.shared.getSubColor()

        self.settingTableView.backgroundColor = DisplayModeManager.shared.getSubColor()
    }

    private func setupTableView() {

        settingTableView.dataSource = self

        settingTableView.delegate = self

        for identifier in identifiers {

            settingTableView.register(
                UINib(nibName: identifier, bundle: nil),
                forCellReuseIdentifier: identifier
            )
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }

    @objc func contactUsPressed(_ sender: Any) {

        let mailComposeViewController = configuredMailComposeViewController()

        if MFMailComposeViewController.canSendMail() {

            self.show(mailComposeViewController, sender: nil)
        }

    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {

        let mailComposerVC = MFMailComposeViewController()

        mailComposerVC.mailComposeDelegate = self

        mailComposerVC.setToRecipients(["laalee0525@gmail.com"])

        mailComposerVC.setSubject("About the Schedule.")

        return mailComposerVC
    }
}

extension SettingViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return identifiers.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: identifiers[indexPath.section],
            for: indexPath
        )

//        switch indexPath.section {
//        case 0:
//            guard let displayCell = cell as? DisplayTableViewCell else { return cell }
//
//            return displayCell
//
//        case 1:
            guard let supportCell = cell as? SupportTableViewCell else { return cell }

            supportCell.contactUsButton.addTarget(self, action: #selector(contactUsPressed), for: .touchUpInside)

            return supportCell

//        default:
//            break
//        }
//
//        return cell
    }
}

extension SettingViewController: UITableViewDelegate {

}

extension SettingViewController: MFMailComposeViewControllerDelegate {

    @objc(mailComposeController:didFinishWithResult:error:)
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
        ) {

        controller.dismiss(animated: true, completion: nil)
    }
}


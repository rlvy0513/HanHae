//
//  SettingsViewController.swift
//  HanHae
//
//  Created by 김성민 on 10/3/24.
//

import UIKit

final class SettingsViewController: HHBaseViewController {
    
    private let tableView = UITableView(
        frame: .zero,
        style: .insetGrouped
    )
    private let cellIdentifier = "Cell"
    
    private lazy var closeSettingsBarButton: UIBarButtonItem = {
        let barBtn = UIBarButtonItem(
            title: "닫기",
            style: .plain,
            target: self,
            action: #selector(dismissView)
        )
        barBtn.tintColor = .hhAccent
        barBtn.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.hhBody],
            for: .normal
        )
        barBtn.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.hhBody],
            for: .highlighted
        )
        return barBtn
    }()
    
    private let remindAlarmSwitch: UISwitch = {
        let alarmSwitch = UISwitch()
        alarmSwitch.onTintColor = .hhAccent
        return alarmSwitch
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        setupConstraints()
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: cellIdentifier
        )
    }
    
    private func setupNavigationBar() {
        title = "앱 설정"
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: FontName.eliceDigitalBaeumBold.rawValue, size: 17)!
        ]
        navigationItem.rightBarButtonItem = closeSettingsBarButton
    }
    
    @objc
    private func dismissView() {
        dismiss(animated: true, completion: nil)
    }

}


extension SettingsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 10
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        return UIView()
    }
}


extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return section == 0 ? 3 : 2
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath
        )
        cell.backgroundColor = .hhModalCell
        
        var content = cell.defaultContentConfiguration()
        content.imageProperties.tintColor = .hhAccent
        content.textProperties.font = .hhBody
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                content.image = UIImage(systemName: "sun.max")
                content.text = "앱 테마 설정"
                cell.accessoryType = .disclosureIndicator
            case 1:
                content.image = UIImage(systemName: "a.square")
                content.text = "언어 설정"
                cell.accessoryType = .disclosureIndicator
            case 2:
                content.image = UIImage(systemName: "bell")
                content.text = "리마인드 알림"
                cell.accessoryView = remindAlarmSwitch
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                content.image = UIImage(systemName: "square.and.pencil")
                content.text = "앱 피드백 남기기"
                cell.accessoryType = .disclosureIndicator
            case 1:
                content.image = UIImage(systemName: "star")
                content.text = "앱 평점 남기기"
                cell.accessoryType = .disclosureIndicator
            default:
                break
            }
        }
        
        cell.contentConfiguration = content
        return cell
    }
}

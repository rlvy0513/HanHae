//
//  SettingsViewController.swift
//  HanHae
//
//  Created by 김성민 on 10/3/24.
//

import UIKit

final class SettingsViewController: HHBaseViewController {
    
    private let viewModel = SettingsViewModel()
    
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
        
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = .hhAccent
        appearance.titleTextAttributes = [
            .font: UIFont.hhHeadLine
        ]
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.hhBody
        ]
        barButtonAppearance.setTitleTextAttributes(attributes, for: .normal)
        barButtonAppearance.setTitleTextAttributes(attributes, for: .highlighted)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = viewModel.sections[indexPath.section]
        let option = section.options[indexPath.row]
        
        viewModel.handleSelection(of: option, navigationController: navigationController)
    }
}


extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getSectionsCount()
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.getNumberOfRowsInSection(section: section)
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath
        )
        var content = cell.defaultContentConfiguration()
        
        content.imageProperties.tintColor = .hhAccent
        content.textProperties.font = .hhBody
        
        let section = viewModel.sections[indexPath.section]
        let option = section.options[indexPath.row]
        content.image = viewModel.getOptionImage(for: option)
        content.text = viewModel.getOptionTitle(for: option)
        
        if option == .reminder {
            cell.accessoryView = remindAlarmSwitch
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        
        cell.contentConfiguration = content
        cell.backgroundColor = .hhModalCell
        cell.selectionStyle = .none
        
        return cell
    }
}

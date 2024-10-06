//
//  SettingsViewController.swift
//  HanHae
//
//  Created by 김성민 on 10/3/24.
//

import UIKit

final class SettingsViewController: SettingsBaseViewController {
    
    private let viewModel = SettingsViewModel()
    
    private let remindAlarmSwitch: UISwitch = {
        let alarmSwitch = UISwitch()
        alarmSwitch.onTintColor = .hhAccent
        return alarmSwitch
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        super.setupTableView()
    }
    
    override func setupNavigationBar() {
        title = "앱 설정"
        
        super.setupNavigationBar()
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

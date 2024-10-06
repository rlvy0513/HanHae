//
//  SettingsViewController.swift
//  HanHae
//
//  Created by 김성민 on 10/3/24.
//

import UIKit

final class SettingDetailViewController: SettingsBaseViewController {
    
    var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
    }
    
    override func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        super.setupTableView()
    }
    
    override func setupNavigationBar() {
        title = viewModel.getDetailTitle()
        
        super.setupNavigationBar()
    }

}


extension SettingDetailViewController: UITableViewDelegate {
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
        viewModel.handleSelection(of: indexPath.row)
    }
}


extension SettingDetailViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.getDetailNumberOfRowsInSection()
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
        content.text = viewModel.getDetailOptionTextForRow(at: indexPath.row)
        
        cell.contentConfiguration = content
        cell.backgroundColor = .hhModalCell
        cell.selectionStyle = .none
        
        return cell
    }
}

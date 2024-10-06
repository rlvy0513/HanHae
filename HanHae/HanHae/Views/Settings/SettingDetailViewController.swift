//
//  SettingsViewController.swift
//  HanHae
//
//  Created by 김성민 on 10/3/24.
//

import UIKit

final class SettingDetailViewController: HHBaseViewController {
    
    var viewModel: SettingsViewModel
    
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
        title = viewModel.getDetailTitle()
        
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

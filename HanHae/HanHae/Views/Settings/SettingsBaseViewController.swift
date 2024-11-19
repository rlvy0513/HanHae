//
//  SettingsBaseViewController.swift
//  HanHae
//
//  Created by 김성민 on 10/6/24.
//

import UIKit

class SettingsBaseViewController: HHBaseViewController {
    
    let tableView = UITableView(
        frame: .zero,
        style: .insetGrouped
    )
    let cellIdentifier = "Cell"
    
    lazy var closeSettingsBarButton: UIBarButtonItem = {
        let barBtn = UIBarButtonItem(
            title: String(localized: "닫기"),
            style: .plain,
            target: self,
            action: #selector(dismissView)
        )
        return barBtn
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
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: cellIdentifier
        )
    }
    
    func setupNavigationBar() {
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

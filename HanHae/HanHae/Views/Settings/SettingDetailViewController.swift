//
//  SettingsViewController.swift
//  HanHae
//
//  Created by 김성민 on 10/3/24.
//

import UIKit

final class SettingDetailViewController: HHBaseViewController {
    
    private var kindOfSetting: Setting = .theme
    
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
    
    init(indexOfRow: Int) {
        self.kindOfSetting = Setting(rawValue: indexOfRow)!
        
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
        title = kindOfSetting == .theme ? "앱 테마 설정" : "언어 설정"
        
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
        switch kindOfSetting {
        case .theme:
            switch indexPath.row {
            case 0:
                print("시스템")
            case 1:
                print("라이트")
            case 2:
                print("다크")
            default:
                break
            }
        case .language:
            switch indexPath.row {
            case 0:
                print("한국어")
            case 1:
                print("영어")
            default:
                break
            }
        }
    }
}


extension SettingDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return kindOfSetting == .theme ? 3 : 2
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
        cell.selectionStyle = .none
        
        var content = cell.defaultContentConfiguration()
        content.imageProperties.tintColor = .hhAccent
        content.textProperties.font = .hhBody
        
        switch kindOfSetting {
        case .theme:
            switch indexPath.row {
            case 0:
                content.text = "시스템 설정과 동일"
            case 1:
                content.text = "라이트 모드"
            case 2:
                content.text = "다크 모드"
            default:
                break
            }
        case .language:
            switch indexPath.row {
            case 0:
                content.text = "한국어"
            case 1:
                content.text = "English"
            default:
                break
            }
        }

        cell.contentConfiguration = content
        return cell
    }
}


fileprivate enum Setting: Int {
    case theme
    case language
}

//
//  SettingsViewController.swift
//  HanHae
//
//  Created by 김성민 on 10/3/24.
//

import UIKit
import MessageUI

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
    
    func presentFeedbackEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            let bodyString = """
                 <html>
                 <body>
                    <p><small>피드백이나 문의사항을을 작성해 주세요.</small></p><br>
                 
                    <br>
                    <p>===============================<br>
                    iPhone Model : \(DeviceInfo.modelName)<br>
                    iOS Version : \(DeviceInfo.iOSVersion)<br>
                    App Version : \(DeviceInfo.appVersion)<br>
                    ===============================<br>
                    <small>* iPhone Model이 올바르지 않은 경우, 수동으로 입력해 주세요.</small></p>
                 </body>
                 </html>
                 """
            
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["sjybext@naver.com"])
            mailComposeVC.setSubject("한해(HanHae) 앱 피드백 메일입니다.")
            mailComposeVC.setMessageBody(bodyString, isHTML: true)
            
            self.present(mailComposeVC, animated: true)
        } else {
            let alert = UIAlertController(
                title: "메일을 보낼 수 없습니다.",
                message: "디바이스에 메일 계정이 설정되어 있지 않습니다.\n메일 앱에서 사용자의 메일 계정을 설정해 주세요.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true, completion: nil)
        }
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
        
        viewModel.handleSelection(of: option, viewController: self)
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


extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
        var alertTitle: String?
        var alertMessage: String?
        
        switch result {
        case .cancelled:
            alertTitle = "메일 전송 취소"
            alertMessage = "메일 전송이 취소되었습니다."
        case .saved:
            alertTitle = "메일 저장됨"
            alertMessage = "메일이 저장되었습니다."
        case .sent:
            alertTitle = "메일 전송 완료"
            alertMessage = "한해 앱에 대한 피드백을 주셔서 감사합니다.\n이용자분의 의견을 반영하여 발전하는 한해가 되겠습니다."
        case .failed:
            alertTitle = "메일 전송 실패"
            alertMessage = "메일 전송에 실패했습니다. 다시 시도해 주세요."
        @unknown default:
            alertTitle = "알 수 없는 오류"
            alertMessage = "알 수 없는 오류가 발생했습니다."
        }
        
        controller.dismiss(animated: true) { [weak self] in
            if let title = alertTitle, let message = alertMessage {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}

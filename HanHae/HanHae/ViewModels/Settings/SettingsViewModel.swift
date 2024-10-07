//
//  SettingsViewModel.swift
//  HanHae
//
//  Created by 김성민 on 10/5/24.
//

import UIKit
import StoreKit

final class SettingsViewModel {
    
    // MARK: - data
    enum SettingOption {
        case theme
        case language
        case reminder
        case feedback
        case rating
        
        var title: String {
            switch self {
            case .theme: return "앱 테마 설정"
            case .language: return "언어 설정"
            case .reminder: return "리마인드 알림"
            case .feedback: return "앱 피드백 남기기"
            case .rating: return "앱 평점 남기기"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .theme: return UIImage(systemName: "sun.max")
            case .language: return UIImage(systemName: "a.square")
            case .reminder: return UIImage(systemName: "bell")
            case .feedback: return UIImage(systemName: "square.and.pencil")
            case .rating: return UIImage(systemName: "star")
            }
        }
        
        var detailOptions: [String] {
            switch self {
            case .theme:
                return ["시스템 설정과 동일", "라이트 모드", "다크 모드"]
            case .language:
                return ["한국어", "English"]
            default:
                return []
            }
        }
    }
    
    struct Section {
        let title: String
        let options: [SettingOption]
    }
    
    let sections: [Section] = [
        Section(title: "앱 설정", options: [.theme, .language, .reminder]),
        Section(title: "기타", options: [.feedback, .rating])
    ]
    
    var currentSetting: SettingOption?
    
    private let userDefaults = UserDefaults.standard
    private let themeKey = "selectedTheme"
    private let languageKey = "selectedLanguage"
    private let reminderKey = "isReminderOn"
    
    var selectedTheme: Int? {          // 0: 시스템, 1: 라이트, 2: 다크
        get {
            return userDefaults.integer(forKey: themeKey)
        }
        set {
            userDefaults.setValue(newValue, forKey: themeKey)
        }
    }
    
    var selectedLanguage: Int? {          // 0: 한국어, 1: 영어
        get {
            return userDefaults.integer(forKey: languageKey)
        }
        set {
            userDefaults.setValue(newValue, forKey: languageKey)
        }
    }
    
    var isReminderOn: Bool {
        get {
            return userDefaults.object(forKey: reminderKey) != nil ? userDefaults.bool(forKey: reminderKey) : true
        }
        set {
            userDefaults.set(newValue, forKey: reminderKey)
        }
    }
    
    // MARK: - input
    func handleReminderSwitchToggled(_ sender: UISwitch) {
        isReminderOn = sender.isOn
    }
    
    // MARK: - output
    func getOptionImage(for option: SettingOption) -> UIImage? {
        return option.image
    }
    
    func getOptionTitle(for option: SettingOption) -> String {
        return option.title
    }
    
    func getDetailTitle() -> String {
        guard let currentSetting else { return "" }
        
        return currentSetting.title
    }
    
    func getDetailOptionTextForRow(at index: Int) -> String {
        guard let currentSetting = currentSetting else { return "" }
        let options = currentSetting.detailOptions
        
        return options[index]
    }
    
    func getSectionsCount() -> Int {
        self.sections.count
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        self.sections[section].options.count
    }
    
    func getDetailNumberOfRowsInSection() -> Int {
        guard let currentSetting = currentSetting else { return 0 }
        
        return currentSetting.detailOptions.count
    }
    
    func presentCheckmark(of cell: UITableViewCell, indexPathOfRow: Int) -> UIView? {
        let checkmarkImage = customCheckmarkImage()
        
        switch currentSetting {
        case .theme:
            return indexPathOfRow == selectedTheme ? UIImageView(image: checkmarkImage) : nil
        case .language:
            return indexPathOfRow == selectedLanguage ? UIImageView(image: checkmarkImage) : nil
        default:
            return nil
        }
    }
    
    // MARK: - logic    
    func handleSelection(
        of option: SettingOption,
        viewController: UIViewController
    ) {
        switch option {
        case .theme, .language:
            self.currentSetting = option
            
            let detailVC = SettingDetailViewController(viewModel: self)
            viewController.navigationController?.pushViewController(detailVC, animated: true)
        case .reminder:
            break
        case .feedback:
            guard let settingsVC = viewController as? SettingsViewController else { return }
            settingsVC.presentFeedbackEmail()
        case .rating:
            guard let scene = viewController.view.window?.windowScene else { return }
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func handleSelection(of detailOptionIndexOfRow: Int) {
        guard let currentSetting = currentSetting else { return }
        
        switch currentSetting {
        case .theme:
            selectedTheme = detailOptionIndexOfRow
            applyTheme(detailOptionIndexOfRow)
        case .language:
            selectedLanguage = detailOptionIndexOfRow
            
            switch detailOptionIndexOfRow {
            case 0:
                print("한국어")
            case 1:
                print("영어")
            default:
                break
            }
        default:
            break
        }
    }
    
    private func customCheckmarkImage() -> UIImage? {
        let checkmarkConfig = UIImage.SymbolConfiguration(
            pointSize: 17,
            weight: .medium
        )
        let checkmarkImage = UIImage(
            systemName: "checkmark",
            withConfiguration: checkmarkConfig
        )?.withTintColor(.hhAccent, renderingMode: .alwaysOriginal)
        
        return checkmarkImage
    }
    
    private func applyTheme(_ themeIndex: Int?) {
        guard let themeIndex else { return }
        
        let windows = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
        
        windows.forEach { window in
            UIView.transition(
                with: window,
                duration: 0.4,
                options: [.transitionCrossDissolve], animations: {
                    switch themeIndex {
                    case 0:
                        window.overrideUserInterfaceStyle = .unspecified
                    case 1:
                        window.overrideUserInterfaceStyle = .light
                    case 2:
                        window.overrideUserInterfaceStyle = .dark
                    default:
                        window.overrideUserInterfaceStyle = .unspecified
                    }
                },
                completion: nil
            )
        }
    }
    
    private func applyLanguage(_ languageIndex: Int?) {
        // TODO: - 기능 구현 필요
        // guard let languageIndex else { return }
    }
    
    func loadSavedTheme() {
        let savedThemeIndex = userDefaults.integer(forKey: themeKey)
        applyTheme(savedThemeIndex)
    }
    
    func loadSavedLanguage() {
        let savedLanguageIndex = userDefaults.integer(forKey: languageKey)
        applyLanguage(savedLanguageIndex)
    }
    
}




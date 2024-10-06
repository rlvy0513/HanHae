//
//  SettingsViewModel.swift
//  HanHae
//
//  Created by 김성민 on 10/5/24.
//

import UIKit

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
    
    var selectedTheme: Int = 0         // 0: 시스템, 1: 라이트, 2: 다크
    var selectedLanguage: Int = 0      // 0: 한국어, 1: 영어
    
    // MARK: - input
    
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
        navigationController: UINavigationController?
    ) {
        switch option {
        case .theme, .language:
            self.currentSetting = option
            
            let detailVC = SettingDetailViewController(viewModel: self)
            navigationController?.pushViewController(detailVC, animated: true)
        case .reminder:
            // 알림 관련 설정은 Switch로 처리되어 별도 동작 없음
            break
        case .feedback:
            // 피드백 화면으로 이동하는 로직 추가
            print("Feedback selected")
        case .rating:
            // 앱 스토어 리뷰 페이지로 이동하는 로직 추가
            print("Rating selected")
        }
    }
    
    func handleSelection(of detailOptionIndexOfRow: Int) {
        guard let currentSetting = currentSetting else { return }
        
        switch currentSetting {
        case .theme:
            selectedTheme = detailOptionIndexOfRow
            
            switch detailOptionIndexOfRow {
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
    
}




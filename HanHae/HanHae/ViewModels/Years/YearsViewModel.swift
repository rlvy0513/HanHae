//
//  YearsViewModel.swift
//  HanHae
//
//  Created by 김성민 on 9/22/24.
//

import UIKit

final class YearsViewModel {
    
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - data
    private var years: [HHYear] {
        return coreDataManager.getYears()
    }
    
    // MARK: - input
    
    // MARK: - ouput
    func getYearsCount() -> Int {
        return years.count
    }
    
    func getYearLabelText(index: Int) -> String {
        return "\(years[index].year)년"
    }
    
    func getYearLabelColor(index: Int) -> UIColor {
        if Date.todayYear == years[index].year {
            return UIColor.hhAccent
        } else {
            return UIColor.hhText
        }
    }
    
    func makeMonthlyTDLViewModelAt(
        yearIndex: Int,
        monthIndex: Int
    ) -> TestMonthlyTDLViewModel {
        let monthData = (years[yearIndex].months?.array as! [HHMonth])[monthIndex]
        return TestMonthlyTDLViewModel(monthlyData: monthData)
    }
    
    // MARK: - logic
    func getMonthlyTDL(
        yearIndex: Int,
        monthIndex: Int
    ) -> [ToDo] {
        let monthData = (years[yearIndex].months?.array as! [HHMonth])[monthIndex]
        
        return monthData.toDoList?.array as! [ToDo]
    }
    
    func getScrollIndexPath(atYear: Int, atMonth: Int) -> IndexPath {
        let section = atYear - 2020
        let item = atMonth - 1
        return IndexPath(item: item, section: section)
    }
    
    func pushMonthlyViewController(vc: UIViewController) {
        let monthlyVC = MonthlyViewController()
        vc.navigationController?.pushViewController(monthlyVC, animated: true)
    }
    
    func presentSettingsViewController(vc: UIViewController) {
        let settingsVC = SettingsViewController()
        let naviController = UINavigationController(rootViewController: settingsVC)
        naviController.modalPresentationStyle = .formSheet
        
        vc.present(naviController, animated: true)
    }
    
}

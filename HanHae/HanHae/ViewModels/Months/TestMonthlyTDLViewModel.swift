//
//  TestMonthlyTDLViewModel.swift
//  HanHae
//
//  Created by 김성민 on 9/27/24.
//

import UIKit

final class TestMonthlyTDLViewModel {
    
    // MARK: - data
    let monthlyData: HHMonth
    var toDoList: [ToDo] {
        monthlyData.toDoList
    }
    
    init(monthlyData: HHMonth) {
        self.monthlyData = monthlyData
    }
    
    // MARK: - input
    
    // MARK: - output
    func getMonthLabelText() -> String {
        return "\(monthlyData.month)월"
    }
    
    func getMonthLabelColor() -> UIColor {
        if Date.todayYear == monthlyData.year,
           Date.todayMonth == monthlyData.month {
            return UIColor.hhAccent
        } else {
            return UIColor.hhText
        }
    }
    
    func getNumericLabelText() -> (toDoCount: String, percent: String) {
        let toDoListCount = toDoList.count
        let completedToDoListCount = toDoList.filter { $0.isCompleted == true }.count
        
        let toDoCountString: String
        let percentString: String
        
        if !toDoList.isEmpty {
            toDoCountString = "\(completedToDoListCount) / \(toDoListCount)"
            
            if completedToDoListCount == 0 {
                percentString = "0"
            } else {
                let percentNumber = (Double(completedToDoListCount) / Double(toDoListCount)) * 100
                percentString = String(format: "%.0f", percentNumber)
            }
        } else {
            toDoCountString = "- / -"
            percentString = "--"
        }
        
        return (toDoCountString, percentString)
    }
    
    // MARK: - logic
    
}

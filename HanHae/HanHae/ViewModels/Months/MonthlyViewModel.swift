//
//  MonthlyTDLViewModel.swift
//  HanHae
//
//  Created by 김성민 on 9/27/24.
//

import UIKit

final class MonthlyViewModel {
    
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - data
    let yearIndex: Int
    let monthIndex: Int
    
    let monthData: HHMonth
    private(set) var toDoList: [ToDo] = [] {
        didSet {
            onToDoListUpdated?(toDoList)
        }
    }
    
    var onMottoUpdated: ((String) -> Void)?
    lazy var mottoPlaceholder = "\(monthData.month)월의 나에게\n목표 달성을 위한\n응원의 메시지를 적어주세요."
    
    var onToDoListUpdated: (([ToDo]) -> Void)?
    var isEmptyToDoList: Bool {
        return toDoList.isEmpty
    }
    private var isEditingMode = false
    
    init(yearIndex: Int, monthIndex: Int, monthData: HHMonth) {
        self.yearIndex = yearIndex
        self.monthIndex = monthIndex
        self.monthData = monthData
        
        fetchUpdatedToDoList()
    }
    
    // MARK: - input
    
    // MARK: - output
    func getMonthLabelText() -> String {
        return "\(monthData.month)월"
    }
    
    func getMonthLabelColor() -> UIColor {
        if Date.todayYear == monthData.year!.year,
           Date.todayMonth == monthData.month {
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
    
    func getMonthlyMottoText() -> String {
        if let monthlyMotto = monthData.monthlyMotto {
            return monthlyMotto
        } else {
            return mottoPlaceholder
        }
    }
    
    func getYearText() -> String {
          return " \(yearIndex + 2020)"
      }
    
    // MARK: - logic
    func updateMonthlyMotto(_ newMotto: String) {
        coreDataManager.updateMonthlyMotto(
            forYearIndex: yearIndex,
            monthIndex: monthIndex,
            newMotto: newMotto
        )
        onMottoUpdated?(newMotto)
    }
    
    func addToDo() {
        coreDataManager.addToDo(
            forYearIndex: yearIndex,
            monthIndex: monthIndex
        )
        
        fetchUpdatedToDoList()
    }
    
    func removeToDo(at index: Int) {
        coreDataManager.removeToDo(
            forYearIndex: yearIndex,
            monthIndex: monthIndex,
            atToDoIndex: index
        )
        
        fetchUpdatedToDoList()
    }
    
    func removeToDoList() {
        coreDataManager.removeToDoList(
            forYearIndex: yearIndex,
            monthIndex: monthIndex
        )
        
        fetchUpdatedToDoList()
    }
    
    func moveToDo(fromIndex: Int, toIndex: Int) {
        coreDataManager.moveToDo(
            forYearIndex: yearIndex,
            monthIndex: monthIndex,
            fromToDoIndex: fromIndex,
            toToDoIndex: toIndex
        )
        
        fetchUpdatedToDoList()
    }
    
    func updateToDoTitle(at index: Int, newTitle: String) {
        guard index >= 0 && index < toDoList.count else { return }
        
        coreDataManager.updateToDoTitle(
            forYearIndex: yearIndex,
            monthIndex: monthIndex,
            atToDoIndex: index,
            newTitle: newTitle
        )
    }
    
    func updateToDoNote(at index: Int, newNote: String) {
        guard index >= 0 && index < toDoList.count else { return }
        
        coreDataManager.updateToDoNote(
            forYearIndex: yearIndex,
            monthIndex: monthIndex,
            atToDoIndex: index,
            newNote: newNote
        )
    }
    
    func updateToDoCompletionStatus(at index: Int, isCompleted: Bool) {
        coreDataManager.updateToDoCompletionStatus(
            forYearIndex: yearIndex,
            monthIndex: monthIndex,
            atToDoIndex: index,
            isCompleted: isCompleted
        )
        
        fetchUpdatedToDoList()
    }
    
    func fetchUpdatedToDoList() {
        toDoList = monthData.toDoList?.array as! [ToDo]
    }
    
    func didTapEditListButton() {
        isEditingMode.toggle()
    }
    
    func finishEditing() {
        isEditingMode = false
    }
    
    func presentSettingsViewController(vc: UIViewController) {
        let settingsVC = SettingsViewController()
        let naviController = UINavigationController(rootViewController: settingsVC)
        naviController.modalPresentationStyle = .formSheet
        
        vc.present(naviController, animated: true)
    }
}

//
//  MonthlyTodoListViewModel.swift
//  HanHae
//
//  Created by 기 표 on 10/2/24.
//

import Foundation

class MonthlyToDoListViewModel {
    
    private let toDoListKey = "savedTodoList"

    private(set) var toDoList: [ToDo] = [] {
        didSet {
            saveToDoList()
            onToDoListUpdated?(toDoList)
        }
    }
    
    var isEmpty: Bool {
        return toDoList.isEmpty
    }
    
    var onToDoListUpdated: (([ToDo]) -> Void)?

    init() {
        loadToDoList()
    }
    
    private var isEditingMode = false
    
    // 목표 추가
    func addToDo() {
        toDoList.append(ToDo(title: "목표를 입력하세요.", note: nil))
    }
    
    // 목표 순서
    func moveToDo(from oldIndex: Int, to newIndex: Int) {
        guard oldIndex >= 0 && oldIndex < toDoList.count,
                newIndex >= 0 && newIndex < toDoList.count else { return }
        let movedToDo = toDoList.remove(at: oldIndex)
        toDoList.insert(movedToDo, at: newIndex)
    }
    
    // 목표 삭제
    func removeToDo(at index: Int) {
        guard index >= 0 && index < toDoList.count else { return }
        toDoList.remove(at: index)
    }
    
    // 전체삭제
    func removeAllToDoList() {
        toDoList.removeAll()
    }
    
    // 목표 업데이트
    func updateToDoText(at index: Int, text: String) {
        guard index >= 0 && index < toDoList.count else { return }
        toDoList[index].title = text
    }
    
    // 메모 변경
    func updateNoteText(at index: Int, note: String) {
        guard index >= 0 && index < toDoList.count else { return }
        toDoList[index].note = note.isEmpty ? nil : note
    }

    // 완료 유무
    func updateCompletionStatus(at index: Int, isCompleted: Bool) {
        guard index >= 0 && index < toDoList.count else { return }
        toDoList[index].isCompleted = isCompleted
        toDoList[index].completionDate = isCompleted ? Date() : nil
        saveToDoList()
    }

    // 편집 모드 토글 메서드
    func didTapEditListButton() {
        isEditingMode.toggle()
    }

    // 편집 모드 종료 메서드
    func finishEditing() {
        isEditingMode = false
    }
    
    private func saveToDoList() {
        do {
            let data = try JSONEncoder().encode(toDoList)
            UserDefaults.standard.set(data, forKey: toDoListKey)
        } catch {
            print("저장실패: \(error.localizedDescription)")
        }
    }

    private func loadToDoList() {
        if let data = UserDefaults.standard.data(forKey: toDoListKey) {
            do {
                toDoList = try JSONDecoder().decode([ToDo].self, from: data)
            } catch {
                print("불러오기실패: \(error.localizedDescription)")
            }
        }
    }
    
    func completionPercentage() -> Double {
        guard !toDoList.isEmpty else { return 0.0 }
        let completedCount = toDoList.count { $0.isCompleted }
        return (Double(completedCount) / Double(toDoList.count)) * 100
    }
}

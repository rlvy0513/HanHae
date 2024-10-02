//
//  MonthlyTodoListViewModel.swift
//  HanHae
//
//  Created by 기 표 on 10/2/24.
//

import Foundation

class MonthlyTodoListViewModel {
    
    private let todoListKey = "savedTodoList"

    private(set) var todoList: [ToDo] = [] {
        didSet {
            saveTodoList()
            onTodoListUpdated?(todoList)
        }
    }
    
    var isEmpty: Bool {
        return todoList.isEmpty
    }
    
    var onTodoListUpdated: (([ToDo]) -> Void)?

    init() {
        loadTodoList()
    }
    
    // 목표 추가
    func addTodo() {
        todoList.append(ToDo(title: "목표를 입력하세요.", note: nil))
    }
    
    // 목표 순서
    func moveTodo(from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        let movedTodo = todoList.remove(at: sourceIndex)
        todoList.insert(movedTodo, at: destinationIndex)
    }
    
    // 목표 삭제
    func removeTodo(at index: Int) {
        guard index >= 0 && index < todoList.count else {
            print("Index out of bounds")
            return
        }
        todoList.remove(at: index)
    }
    
    // 목표 업데이트
    func updateTodoText(at index: Int, text: String) {
        guard index >= 0 && index < todoList.count else { return }
        todoList[index].title = text
    }
    
    // 메모 변경
    func updateNoteText(at index: Int, note: String) {
        guard index >= 0 && index < todoList.count else { return }
        todoList[index].note = note.isEmpty ? nil : note
    }

    // 완료 유무
    func updateCompletionStatus(at index: Int, isCompleted: Bool) {
        todoList[index].isCompleted = isCompleted
        todoList[index].completionDate = isCompleted ? Date() : nil
        saveTodoList()
    }
    
    // 전체삭제
    func removeAllTodos() {
        todoList.removeAll()
    }

    private func saveTodoList() {
        do {
            let data = try JSONEncoder().encode(todoList)
            UserDefaults.standard.set(data, forKey: todoListKey)
        } catch {
            print("저장실패: \(error.localizedDescription)")
        }
    }

    private func loadTodoList() {
        if let data = UserDefaults.standard.data(forKey: todoListKey) {
            do {
                todoList = try JSONDecoder().decode([ToDo].self, from: data)
            } catch {
                print("불러오기실패: \(error.localizedDescription)")
            }
        }
    }
    
    func completionPercentage() -> Double {
        let completedTodos = todoList.filter { $0.isCompleted }
        guard !todoList.isEmpty else { return 0.0 }
        return (Double(completedTodos.count) / Double(todoList.count)) * 100
    }
}

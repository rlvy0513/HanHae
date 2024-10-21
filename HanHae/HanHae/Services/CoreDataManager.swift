//
//  CoreDataManager.swift
//  HanHae
//
//  Created by 김성민 on 9/29/24.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    private var safeContext: NSManagedObjectContext {
        guard let context else {
            fatalError("Context not found.")
        }
        
        return context
    }
    
    private init() {
        assert(context != nil, "Context should not be nil.")
    }
    
    func getYears() -> [HHYear] {
        var years: [HHYear] = []
        
        let request: NSFetchRequest<HHYear> = HHYear.fetchRequest()
        let dateOrder = NSSortDescriptor(key: "year", ascending: true)
        request.sortDescriptors = [dateOrder]
        
        do {
            let fetchedYears = try safeContext.fetch(request)
            years = fetchedYears
        } catch {
            print("연도 데이터 가져오기 실패: \(error.localizedDescription)")
        }
        
        return years
    }
    
    func updateMonthlyMotto(
        forYearIndex yearIndex: Int,
        monthIndex: Int,
        newMotto: String
    ) {
        let request: NSFetchRequest<HHMonth> = HHMonth.fetchRequest()
        request.predicate = NSPredicate(
            format: "year.year == %d AND month == %d",
            yearIndex + 2020,
            monthIndex + 1
        )
        
        do {
            let fetchedMonths = try safeContext.fetch(request)
            
            guard let monthToUpdate = fetchedMonths.first else { return }
            monthToUpdate.monthlyMotto = newMotto
            
            if safeContext.hasChanges {
                do {
                    try safeContext.save()
                } catch {
                    print("변경된 Motto 저장 실패: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Motto 업데이트 실패: \(error.localizedDescription)")
        }
    }
    
    func addToDo(
        forYearIndex yearIndex: Int,
        monthIndex: Int
    ) {
        let request: NSFetchRequest<HHMonth> = HHMonth.fetchRequest()
        request.predicate = NSPredicate(
            format: "year.year == %d AND month == %d",
            yearIndex + 2020,
            monthIndex + 1
        )
        
        do {
            let fetchedMonths = try safeContext.fetch(request)
            
            guard let monthToUpdate = fetchedMonths.first else { return }
            let newToDo = ToDo(context: safeContext)
            newToDo.id = UUID().uuidString
            newToDo.title = "목표를 입력하세요."
            newToDo.note = nil
            newToDo.priority = 4
            newToDo.startDate = Date()
            newToDo.isCompleted = false
            newToDo.completionDate = nil
            
            monthToUpdate.addToToDoList(newToDo)
            
            if safeContext.hasChanges {
                do {
                    try safeContext.save()
                } catch {
                    print("ToDo 추가 실패: \(error.localizedDescription)")
                }
            }
        } catch {
            print("ToDo 추가 실패: \(error.localizedDescription)")
        }
    }
    
    func removeToDo(
        forYearIndex yearIndex: Int,
        monthIndex: Int,
        atToDoIndex toDoIndex: Int
    ) {
        let request: NSFetchRequest<HHMonth> = HHMonth.fetchRequest()
        request.predicate = NSPredicate(
            format: "year.year == %d AND month == %d",
            yearIndex + 2020,
            monthIndex + 1
        )
        
        do {
            let fetchedMonths = try safeContext.fetch(request)
            
            guard let monthToDelete = fetchedMonths.first else { return }
            monthToDelete.removeFromToDoList(at: toDoIndex)
            
            if safeContext.hasChanges {
                do {
                    try safeContext.save()
                } catch {
                    print("ToDo 삭제 실패: \(error.localizedDescription)")
                }
            }
        } catch {
            print("ToDo 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    func removeToDoList(
        forYearIndex yearIndex: Int,
        monthIndex: Int
    ) {
        let request: NSFetchRequest<HHMonth> = HHMonth.fetchRequest()
        request.predicate = NSPredicate(
            format: "year.year == %d AND month == %d",
            yearIndex + 2020,
            monthIndex + 1
        )
        
        do {
            let fetchedMonths = try safeContext.fetch(request)
            
            guard let monthToDelete = fetchedMonths.first,
                  let toDoList = monthToDelete.toDoList else { return }
            monthToDelete.removeFromToDoList(toDoList)
            
            if safeContext.hasChanges {
                do {
                    try safeContext.save()
                } catch {
                    print("ToDoList 삭제 실패: \(error.localizedDescription)")
                }
            }
        } catch {
            print("ToDoList 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    func updateToDoTitle(
        forYearIndex yearIndex: Int,
        monthIndex: Int,
        atToDoIndex toDoIndex: Int,
        newTitle: String
    ) {
        let request: NSFetchRequest<HHMonth> = HHMonth.fetchRequest()
        request.predicate = NSPredicate(
            format: "year.year == %d AND month == %d",
            yearIndex + 2020,
            monthIndex + 1
        )
        
        do {
            let fetchedMonths = try safeContext.fetch(request)
            
            guard let monthToUpdate = fetchedMonths.first,
                  let toDoList = monthToUpdate.toDoList else { return }
            
            let toDoListArray = toDoList.array as! [ToDo]
            toDoListArray[toDoIndex].title = newTitle
            
            if safeContext.hasChanges {
                do {
                    try safeContext.save()
                } catch {
                    print("ToDo 제목 업데이트 실패: \(error.localizedDescription)")
                }
            }
        } catch {
            print("ToDo 제목 업데이트 실패: \(error.localizedDescription)")
        }
    }
    
    func updateToDoNote(
        forYearIndex yearIndex: Int,
        monthIndex: Int,
        atToDoIndex toDoIndex: Int,
        newNote: String
    ) {
        let request: NSFetchRequest<HHMonth> = HHMonth.fetchRequest()
        request.predicate = NSPredicate(
            format: "year.year == %d AND month == %d",
            yearIndex + 2020,
            monthIndex + 1
        )
        
        do {
            let fetchedMonths = try safeContext.fetch(request)
            
            guard let monthToUpdate = fetchedMonths.first,
                  let toDoList = monthToUpdate.toDoList else { return }
            
            let toDoListArray = toDoList.array as! [ToDo]
            toDoListArray[toDoIndex].note = newNote
            
            if safeContext.hasChanges {
                do {
                    try safeContext.save()
                } catch {
                    print("ToDo 노트 업데이트 실패: \(error.localizedDescription)")
                }
            }
        } catch {
            print("ToDo 노트 업데이트 실패: \(error.localizedDescription)")
        }
    }
    
    func updateToDoCompletionStatus(
        forYearIndex yearIndex: Int,
        monthIndex: Int,
        atToDoIndex toDoIndex: Int,
        isCompleted: Bool
    ) {
        let request: NSFetchRequest<HHMonth> = HHMonth.fetchRequest()
        request.predicate = NSPredicate(
            format: "year.year == %d AND month == %d",
            yearIndex + 2020,
            monthIndex + 1
        )
        
        do {
            let fetchedMonths = try safeContext.fetch(request)
            
            guard let monthToUpdate = fetchedMonths.first,
                  let toDoList = monthToUpdate.toDoList else { return }
            
            let toDoListArray = toDoList.array as! [ToDo]
            toDoListArray[toDoIndex].isCompleted = isCompleted
            
            if isCompleted {
                toDoListArray[toDoIndex].completionDate = Date()
            } else {
                toDoListArray[toDoIndex].completionDate = nil
            }
            
            if safeContext.hasChanges {
                do {
                    try safeContext.save()
                } catch {
                    print("ToDo 완료 상태 업데이트 실패: \(error.localizedDescription)")
                }
            }
        } catch {
            print("ToDo 완료 상태 업데이트 실패: \(error.localizedDescription)")
        }
    }
    
    func moveToDo(
        forYearIndex yearIndex: Int,
        monthIndex: Int,
        fromToDoIndex: Int,
        toToDoIndex: Int
    ) {
        let request: NSFetchRequest<HHMonth> = HHMonth.fetchRequest()
        request.predicate = NSPredicate(
            format: "year.year == %d AND month == %d",
            yearIndex + 2020,
            monthIndex + 1
        )
        
        do {
            let fetchedMonths = try safeContext.fetch(request)
            
            guard let monthToMove = fetchedMonths.first else { return }
            monthToMove.moveToDo(fromIndex: fromToDoIndex, toIndex: toToDoIndex)
            
            if safeContext.hasChanges {
                do {
                    try safeContext.save()
                } catch {
                    print("ToDo 이동 실패: \(error.localizedDescription)")
                }
            }
        } catch {
            print("ToDo 이동 실패: \(error.localizedDescription)")
        }
    }
    
}

//
//  HHMonth+CoreDataProperties.swift
//  HanHae
//
//  Created by 김성민 on 10/18/24.
//
//

import Foundation
import CoreData


extension HHMonth {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HHMonth> {
        return NSFetchRequest<HHMonth>(entityName: "HHMonth")
    }

    @NSManaged public var monthlyMotto: String?
    @NSManaged public var month: Int64
    @NSManaged public var year: HHYear?
    @NSManaged public var toDoList: NSOrderedSet?

}

// MARK: Generated accessors for toDoList
extension HHMonth {

    @objc(insertObject:inToDoListAtIndex:)
    @NSManaged public func insertIntoToDoList(_ value: ToDo, at idx: Int)

    @objc(removeObjectFromToDoListAtIndex:)
    @NSManaged public func removeFromToDoList(at idx: Int)

    @objc(insertToDoList:atIndexes:)
    @NSManaged public func insertIntoToDoList(_ values: [ToDo], at indexes: NSIndexSet)

    @objc(removeToDoListAtIndexes:)
    @NSManaged public func removeFromToDoList(at indexes: NSIndexSet)

    @objc(replaceObjectInToDoListAtIndex:withObject:)
    @NSManaged public func replaceToDoList(at idx: Int, with value: ToDo)

    @objc(replaceToDoListAtIndexes:withToDoList:)
    @NSManaged public func replaceToDoList(at indexes: NSIndexSet, with values: [ToDo])

    @objc(addToDoListObject:)
    @NSManaged public func addToToDoList(_ value: ToDo)

    @objc(removeToDoListObject:)
    @NSManaged public func removeFromToDoList(_ value: ToDo)

    @objc(addToDoList:)
    @NSManaged public func addToToDoList(_ values: NSOrderedSet)

    @objc(removeToDoList:)
    @NSManaged public func removeFromToDoList(_ values: NSOrderedSet)
    
    func moveToDo(fromIndex: Int, toIndex: Int) {
        guard let toDoList else { return }
        
        var toDoListArray = toDoList.array as! [ToDo]
        let movedToDo = toDoListArray.remove(at: fromIndex)
        toDoListArray.insert(movedToDo, at: toIndex)
        
        self.toDoList = NSOrderedSet(array: toDoListArray)
    }

}

extension HHMonth : Identifiable {

}

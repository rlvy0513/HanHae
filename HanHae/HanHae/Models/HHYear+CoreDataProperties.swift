//
//  HHYear+CoreDataProperties.swift
//  HanHae
//
//  Created by 김성민 on 10/18/24.
//
//

import Foundation
import CoreData


extension HHYear {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HHYear> {
        return NSFetchRequest<HHYear>(entityName: "HHYear")
    }

    @NSManaged public var year: Int64
    @NSManaged public var months: NSOrderedSet?

}

// MARK: Generated accessors for months
extension HHYear {

    @objc(insertObject:inMonthsAtIndex:)
    @NSManaged public func insertIntoMonths(_ value: HHMonth, at idx: Int)

    @objc(removeObjectFromMonthsAtIndex:)
    @NSManaged public func removeFromMonths(at idx: Int)

    @objc(insertMonths:atIndexes:)
    @NSManaged public func insertIntoMonths(_ values: [HHMonth], at indexes: NSIndexSet)

    @objc(removeMonthsAtIndexes:)
    @NSManaged public func removeFromMonths(at indexes: NSIndexSet)

    @objc(replaceObjectInMonthsAtIndex:withObject:)
    @NSManaged public func replaceMonths(at idx: Int, with value: HHMonth)

    @objc(replaceMonthsAtIndexes:withMonths:)
    @NSManaged public func replaceMonths(at indexes: NSIndexSet, with values: [HHMonth])

    @objc(addMonthsObject:)
    @NSManaged public func addToMonths(_ value: HHMonth)

    @objc(removeMonthsObject:)
    @NSManaged public func removeFromMonths(_ value: HHMonth)

    @objc(addMonths:)
    @NSManaged public func addToMonths(_ values: NSOrderedSet)

    @objc(removeMonths:)
    @NSManaged public func removeFromMonths(_ values: NSOrderedSet)

}

extension HHYear : Identifiable {

}

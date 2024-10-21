//
//  ToDo+CoreDataProperties.swift
//  HanHae
//
//  Created by 김성민 on 10/18/24.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var title: String
    @NSManaged public var startDate: Date
    @NSManaged public var priority: Int64
    @NSManaged public var note: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var id: String
    @NSManaged public var completionDate: Date?
    @NSManaged public var month: HHMonth?

}

extension ToDo : Identifiable {

}

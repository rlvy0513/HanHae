//
//  sampleModel.swift
//  HanHae
//
//  Created by 김성민 on 9/12/24.
//

import UIKit

// MARK: - 샘플 데이터 모델
struct ToDo: Codable {
    var id: String = UUID().uuidString
    var title: String
    var note: String?
    
    var isCompleted: Bool = false
    
    var startDate: Date = Date()
    var completionDate: Date?
    
    var priority: Int64 = 4
}

enum Priority: Int64 {
    case high = 1
    case mid
    case low
    case none
}

struct HHYear {
    var year: Int
    var months: [HHMonth]
}

struct HHMonth {
    var year: Int
    var month: Int
    
    var monthlyComment: String?
    var toDoList: [ToDo] = []
}


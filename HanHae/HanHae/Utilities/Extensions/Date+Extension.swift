//
//  Date+Extension.swift
//  HanHae
//
//  Created by 김성민 on 9/29/24.
//

import UIKit

extension Date {
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    static var todayYear: Int {
        return Date().year
    }
    
    static var todayMonth: Int {
        return Date().month
    }
}

////
////  MonthlyMottoViewModel.swift
////  HanHae
////
////  Created by 기 표 on 10/2/24.
//
//
//import Foundation
//
//class MonthlyMottoViewModel {
//    
//    private let mottoKey = "savedMotto"
//    private var model: HHMonth
//    
//    var onMottoUpdated: ((String) -> Void)?
//    
//    var defaultMottoText: String {
//        return "\(model.month)월의 나에게\n목표 달성을 위한\n응원의 메시지를 적어주세요."
//    }
//    
//    init(model: HHMonth) {
//        self.model = model
//        syncModelWithUserDefaults()
//    }
//
//    private func syncModelWithUserDefaults() {
//        if let savedMotto = UserDefaults.standard.string(forKey: mottoKey) {
//            model.monthlyComment = savedMotto
//        }
//    }
//    
//    var currentMonth: HHMonth {
//        return model
//    }
//    
//    func updateMotto(_ motto: String) {
//        model.monthlyComment = motto
//        UserDefaults.standard.set(motto, forKey: mottoKey)
//        onMottoUpdated?(motto)
//    }
//    
//    func loadMotto() -> String {
//        return model.monthlyComment ?? UserDefaults.standard.string(forKey: mottoKey) ?? defaultMottoText
//    }
//    
//    func syncWithModel(_ monthlyComment: String?) {
//        if let motto = monthlyComment {
//            model.monthlyComment = motto
//            UserDefaults.standard.set(motto, forKey: mottoKey)
//        }
//    }
//}

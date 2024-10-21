//
//  CoreDataInitializer.swift
//  HanHae
//
//  Created by 김성민 on 10/21/24.
//

import UIKit
import CoreData

final class CoreDataInitializer {
    
    let context: NSManagedObjectContext
    
    private let hasInitializerKey = "hasInitializedData"
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func initializeDataIfNeeded() {
        let userDefaults = UserDefaults.standard
        let hasInitilizedData = userDefaults.bool(forKey: hasInitializerKey)
        
        if !hasInitilizedData {
            creatInitializeData()
            userDefaults.set(true, forKey: hasInitializerKey)
        }
    }
    
    private func creatInitializeData() {
        for year in 2020...2099 {
            let hhYear = HHYear(context: context)
            hhYear.year = Int64(year)
            
            for month in 1...12 {
                let hhMonth = HHMonth(context: context)
                hhMonth.month = Int64(month)
                hhMonth.year = hhYear
            }
        }
        
        do {
            try context.save()
            print("초기 데이터 생성 및 저장 성공")
        } catch {
            print("초기 데이터 저장 실패: \(error.localizedDescription)")
        }
    }
    
}

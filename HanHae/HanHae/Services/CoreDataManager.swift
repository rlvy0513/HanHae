//
//  CoreDataManager.swift
//  HanHae
//
//  Created by 김성민 on 9/29/24.
//

import UIKit
import CoreData


// MARK: - 일단 샘플로 만들어서 임시로 사용하기
final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private var years: [HHYear] = []
    
    private init() {
        makeYearsData()
    }
    
    private func makeYearsData() {
        let yearNumbers = 2020...2099
        
        let goToJeju = ToDo(title: "제주도 여행가기", note: "13일 ~ 15일까지", priority: 0)
        let buyIPhone = ToDo(title: "아이폰 16 Pro 구매하기", isCompleted: true)
        let getLicense = ToDo(title: "컴퓨터 자격증 따기", note: "엑셀, 파워포인트", isCompleted: true, priority: 1)
        let doDiet = ToDo(title: "다이어트 하기")
        let longTitle = ToDo(title: "제목이 정말 긴 목표가 있다면 어떻게 처리가 될것인가? 나만 궁금한가...")
        
        for year in yearNumbers {
            let jan = HHMonth(year: year, month: 1)
            let feb = HHMonth(year: year, month: 2, monthlyComment: "2월이 시작되었습니다.", toDoList: [goToJeju, getLicense, doDiet])
            let mar = HHMonth(year: year, month: 3)
            let apr = HHMonth(year: year, month: 4, monthlyComment: "4월이 시작되었습니다.", toDoList: [goToJeju, getLicense, doDiet, buyIPhone])
            let may = HHMonth(year: year, month: 5, toDoList: [goToJeju, getLicense, doDiet, buyIPhone, longTitle, longTitle])
            let jun = HHMonth(year: year, month: 6, monthlyComment: "6월이 시작되었습니다.", toDoList: [longTitle, longTitle, longTitle, longTitle, longTitle, longTitle, longTitle])
            let jul = HHMonth(year: year, month: 7)
            let agu = HHMonth(year: year, month: 8, monthlyComment: "2월이 시작되었습니다.", toDoList: [goToJeju, getLicense, doDiet, goToJeju, goToJeju, goToJeju, getLicense, doDiet, longTitle])
            let sep = HHMonth(year: year, month: 9)
            let oct = HHMonth(year: year, month: 10, monthlyComment: "4월이 시작되었습니다.", toDoList: [goToJeju, getLicense, doDiet, buyIPhone])
            let nov = HHMonth(year: year, month: 11, toDoList: [goToJeju, getLicense, doDiet, buyIPhone])
            let dec = HHMonth(year: year, month: 12, monthlyComment: "6월이 시작되었습니다.", toDoList: [goToJeju, longTitle])
            
            let year = HHYear(year: year, months: [jan, feb, mar, apr, may, jun, jul, agu, sep, oct, nov, dec])
            
            years.append(year)
        }
    }
    
    func getYears() -> [HHYear] {
        return years
    }
    
}

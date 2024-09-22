//
//  YearsViewModel.swift
//  HanHae
//
//  Created by 김성민 on 9/22/24.
//

import UIKit

final class YearsViewModel {
    
    // MARK: - data
    var years: [HHYear] = []
    
    var calendar: Calendar = {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar
    }()
    var now = Date()
    
    // MARK: - input
    
    // MARK: - ouput
    func getYearsCount() -> Int {
        return years.count
    }
    
    func getYearNumberString(index: Int) -> String {
        return "\(years[index].year)년"
    }
    
    // 추후 월에도 색상 적용할지 확인 필요
    func getLabelColor(index: Int) -> UIColor {
        let yearOfNow = calendar.component(.year, from: now)
        
        if yearOfNow == years[index].year {
            return UIColor.hhAccent
        } else {
            return UIColor.hhText
        }
    }
    
    // MARK: - logic
    func fetchYearsData() {
        // MARK: - 샘플 데이터
        let yearNumbers = 2020...2099
        
        let goToJeju = ToDo(title: "제주도 여행가기", note: "13일 ~ 15일까지", priority: 0)
        let buyIPhone = ToDo(title: "아이폰 16 Pro 구매하기")
        let getLicense = ToDo(title: "컴퓨터 자격증 따기", note: "엑셀, 파워포인트", priority: 1)
        let doDiet = ToDo(title: "다이어트 하기")

        for year in yearNumbers {
            let jan = HHMonth(year: year, month: 1)
            let feb = HHMonth(year: year, month: 2, monthlyComment: "2월이 시작되었습니다.", toDoList: [goToJeju, getLicense, doDiet])
            let mar = HHMonth(year: year, month: 3)
            let apr = HHMonth(year: year, month: 4, monthlyComment: "4월이 시작되었습니다.", toDoList: [goToJeju, getLicense, doDiet, buyIPhone])
            let may = HHMonth(year: year, month: 5, toDoList: [goToJeju, getLicense, doDiet, buyIPhone])
            let jun = HHMonth(year: year, month: 6, monthlyComment: "6월이 시작되었습니다.", toDoList: [goToJeju])
            let jul = HHMonth(year: year, month: 7)
            let agu = HHMonth(year: year, month: 8, monthlyComment: "2월이 시작되었습니다.", toDoList: [goToJeju, getLicense, doDiet])
            let sep = HHMonth(year: year, month: 9)
            let oct = HHMonth(year: year, month: 10, monthlyComment: "4월이 시작되었습니다.", toDoList: [goToJeju, getLicense, doDiet, buyIPhone])
            let nov = HHMonth(year: year, month: 11, toDoList: [goToJeju, getLicense, doDiet, buyIPhone])
            let dec = HHMonth(year: year, month: 12, monthlyComment: "6월이 시작되었습니다.", toDoList: [goToJeju])
            
            let year = HHYear(year: year, months: [jan, feb, mar, apr, may, jun, jul, agu, sep, oct, nov, dec])
            
            years.append(year)
        }
    }
    
}



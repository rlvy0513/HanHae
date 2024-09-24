//
//  YearsViewModel.swift
//  HanHae
//
//  Created by 김성민 on 9/22/24.
//

import UIKit

final class YearsViewModel: NSObject {
    
    // MARK: - data
    var years: [HHYear] = []
    
    var calendar: Calendar = {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar
    }()
    var now = Date()
    lazy var yearOfNow = calendar.component(.year, from: now)
    lazy var monthOfNow = calendar.component(.month, from: now)
    
    // MARK: - input
    
    // MARK: - ouput
    func getYearLabelText(index: Int) -> String {
        return "\(years[index].year)년"
    }
    
    func getMonthLabelText(yeariIndex: Int, monthIndex: Int) -> String {
        return "\(years[yeariIndex].months[monthIndex].month)월"
    }
    
    func getYearLabelColor(index: Int) -> UIColor {
        if yearOfNow == years[index].year {
            return UIColor.hhAccent
        } else {
            return UIColor.hhText
        }
    }
    
    func getMonthLabelStyle(yearIndex: Int, monthIndex: Int) -> (color: UIColor, font: UIFont) {
        if yearOfNow == years[yearIndex].year,
           monthOfNow == years[yearIndex].months[monthIndex].month {
            return (UIColor.hhAccent, UIFont.hhHeadLine)
        } else {
            return (UIColor.hhText, UIFont.hhBody)
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


extension YearsViewModel: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return years.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 12
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyCell.identifier, for: indexPath) as! MonthlyCell
        cell.monthLabel.text = getMonthLabelText(
            yeariIndex: indexPath.section,
            monthIndex: indexPath.row
        )
        cell.monthLabel.textColor = getMonthLabelStyle(
            yearIndex: indexPath.section,
            monthIndex: indexPath.row
        ).color
        cell.monthLabel.font = getMonthLabelStyle(
            yearIndex: indexPath.section,
            monthIndex: indexPath.row
        ).font
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: YearHeaderView.identifier,
            for: indexPath
        ) as! YearHeaderView
        headerView.yearLabel.text = getYearLabelText(index: indexPath.section)
        headerView.yearLabel.textColor = getYearLabelColor(index: indexPath.section)
        
        return headerView
    }
}

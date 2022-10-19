//
//  DateType+.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/10/19.
//

import Foundation

enum DateType {
    case today
    case thisWeek
    case all
}

extension DateType {
    
    var format: String {
        switch self {
        case .today:
            return "a hh:mm"
        case .thisWeek:
            return "EEEE"
        case .all:
            return "yyyy. MM. dd a hh:mm"
        }
    }
    
    static func toString(_ date: Date, to dateFormat: DateType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = dateFormat.format
        return dateFormatter.string(from: date)
    }
    
}

extension Date {
    
    public static func isDateInThisWeek(_ date: Date) -> Bool {
        
        let currentWeekDay = Calendar.current.component(.weekday, from: Date()) - 1
        let startDate = Date().addingTimeInterval(TimeInterval(86400 * (1 - currentWeekDay)))
        let endDate = Date().addingTimeInterval(TimeInterval(86400 * (7 - currentWeekDay)))
        return startDate.clearTimeInDate()...endDate.clearTimeInDate() ~= date
        
    }
    
    public func clearTimeInDate() -> Date {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        return calendar.date(from: DateComponents(year: year, month: month, day: day, hour: 0))!
    }
}

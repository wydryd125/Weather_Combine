//
//  DateExtension.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import Foundation

extension Date {
    func formattedTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h시"
        return dateFormatter.string(from: self)
    }
    
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func formattedDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale =  Locale(identifier: "ko_KR")
        return Calendar.current.isDateInToday(self) ? "오늘" : dateFormatter.string(from: self)
    }
}

extension String {
    func fullDate() -> Date {
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return fullDateFormatter.date(from: self) ?? Date()
    }
}

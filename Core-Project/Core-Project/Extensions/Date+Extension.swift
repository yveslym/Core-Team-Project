//
//  Date+Extension.swift
//  Core-Project
//
//  Created by Yveslym on 12/14/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation
import UIKit

extension Date{
    func dayOfWeak() -> String{
        let day =  Calendar.current.dateComponents([.weekday], from: self).weekday!
        let dayName = DateFormatter().weekdaySymbols[(day-1) % 7]
        return dayName
    }
    func monthName() -> String{
        let month =  Calendar.current.dateComponents([.month], from: self).month!
        let monthName = DateFormatter().monthSymbols[(month - 1) % 12]
        return monthName
    }
}

extension Calendar{
    
    ///function to return the 12 month name
    static func allMonthOfYear() -> [String]{
        
        var monthList = [String]()
        var index = 0
        while index < 12 {
            let monthName = DateFormatter().monthSymbols[index]
            monthList.append(monthName)
            index = index + 1
        }
        return monthList
    }
    
    /// function to return the name of the 7 day of week
    static func allDayOfWeek() -> [String]{
        
        var dayList = [String]()
        var index = 0
        while index < 7 {
            let dayName = DateFormatter().weekdaySymbols[index]
            dayList.append(dayName)
            index = index + 1
        }
        return dayList
    }
}

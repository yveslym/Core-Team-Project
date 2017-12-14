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
        let monthName = DateFormatter().weekdaySymbols[(month - 1) % 12]
        return monthName
    }
    
}

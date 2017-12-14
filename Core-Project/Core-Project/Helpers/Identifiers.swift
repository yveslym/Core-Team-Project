//
//  Identifiers.swift
//  Core-Project
//
//  Created by Erik Perez on 12/4/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation

/// Made up of static properties containing all existing *identifiers* for:
/// * Segues
/// * View Controllers
/// * Collection View Cells
struct Identifiers {
    // Segues
    static let homeToAddBank = "homeViewToAddBankAccount"
    static let addBankToHome = "addBankViewToHomeView"
    static let linkBankUnwindToHome = "linkBankUnwindToHome"
    
    // Cells
    static let currentMonthCell = "dailyExpenseCell"
}
//struct YearDescription{
//    static func monthName() -> [String]{
//        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let dateString = "2017-01-01"
//        let date = dateString.toDate()
//        
//        let month =  Calendar.current.dateComponents([.month], from: date!).month
//        
//        let monthName = DateFormatter().monthSymbols[(month! - 1) % 12]
//        
//        
//        
   // }
//}

//
//  Expense Model.swift
//  Core-Project
//
//  Created by Yveslym on 12/14/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation

struct ExpenseModel{
    
    // function that return a dic of transaction with name of the day as key
    func expenseByDay( dayKey: String, monthKey: String, transaction: [Transaction]) -> [Transaction]{
        
        let trans = transaction.filter({$0.dayName == dayKey && $0.monthName == monthKey})
        
        return trans
    }
    
    func expensesByMonth(key: String,transaction: [Transaction]) -> [Transaction]{
        
       let trans = transaction.filter({$0.monthName == key})

        return trans
        }
    }



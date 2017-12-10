//
//  TotalDayExpense.swift
//  Core-Project
//
//  Created by Erik Perez on 12/5/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation

struct DayExpense {
    var date: String
    var totalAmount = 0.0
    var listedTransactions: [Transaction]

    init(date: String, transactions: [Transaction]) {
        self.listedTransactions = transactions
        self.date = date
        transactions.forEach { (transaction) in
            self.totalAmount += transaction.amount
        }
    
    }
}

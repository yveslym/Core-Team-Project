//
//  PlaidOperation.swift
//  Core-Project
//
//  Created by Yveslym on 12/7/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation

class plaidOperation{
    
    // - MARK: Methods
    
    
    // function to get the transaction of a given account
    static func transaction(with bank: Bank, startDate: Date, endDate: Date, completion: @escaping ([Transaction]?) -> Void) {
       let stack = CoreDataStack.instance
        let days = [startDate,endDate]
        Networking.network(bank: bank, route: .transactions, apiHost: .development, date: days,completion: { (data) in
            var myTransaction = try! JSONDecoder().decode(transactionOperation.self, from: data!)
            
            let record = stack.fetchRecordsForEntity(.Transaction, inManagedObjectContext: stack.viewContext) as? [Transaction]
            
            var index = 0
            myTransaction.transactions.forEach({ (newTans) in
                record?.forEach({ (existingTrans) in
                    if newTans.id == existingTrans.id{
                        myTransaction.transactions.remove(at: index)
                    }
                    index += 1
                })
            })
            
            return completion(myTransaction.transactions)
        })
    }
    
    static func itemAccess(publicToken: String, completion: @escaping (ItemAccess?) -> Void){
        Networking.network(route: .exchangeToken, apiHost: .development,public_token: publicToken,completion: { (data) in
            let itemAccess = try! JSONDecoder().decode(ItemAccess.self, from: data!)
            return completion(itemAccess)
        })
    }
    
    static func identity(with accessToken: String, completion: ()){
        
    }
}

//
//  Transactions.swift
//  Core-Project
//
//  Created by Yveslym on 11/20/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation

struct Transaction: Codable{
    
    var account_id: String?
    var amount: Double?
    var category: String?
    var types: String?
    var date: String?
    var address: String?
    var city: String?
    var state: String?
    var zipCode: String?
    var name: String?
    
    enum TransactionKey: String,CodingKey{
        case transactions
        case location
        case category
        case amount
        case date
        case account_id
        case name
        
        enum AddressKey: String,CodingKey{
            case city
            case state
            case address
            case zip
        }
        
    }
}

extension Transaction{
    init(from decoder: Decoder)throws{
        
        let contenair = try decoder.container(keyedBy: TransactionKey.self)
    
        self.name = try contenair.decodeIfPresent(String.self, forKey: .name) ?? nil
        self.account_id = try contenair.decodeIfPresent(String.self, forKey: .account_id) ?? nil
        self.date = try contenair.decodeIfPresent(String.self, forKey: .date) ?? nil
        self.amount = try contenair.decodeIfPresent(Double.self, forKey: .amount) ?? nil
        let category = try contenair.decodeIfPresent([String].self, forKey: .category) ?? nil
        if category != nil{
            if category!.count > 1{
            self.category = category?[1]
            self.types = category?[0]
            }
            else{
                self.category = category?[0]
            }
        }
        let locationContenair = try contenair.nestedContainer(keyedBy: TransactionKey.AddressKey.self, forKey: .location)
        
        self.city = try locationContenair.decodeIfPresent(String.self, forKey: .city) ?? nil
        self.state = try locationContenair.decodeIfPresent(String.self, forKey: .state) ?? nil
        self.address = try locationContenair.decodeIfPresent(String.self, forKey: .address) ?? nil
        self.zipCode = try locationContenair.decodeIfPresent(String.self, forKey: .zip) ?? nil
    }
}

struct transactionOperation: Codable{
    var transactions:[Transaction]
}





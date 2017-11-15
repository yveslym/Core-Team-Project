//
//  BankOperation.swift
//  Core-Project
//
//  Created by Yveslym on 11/14/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation
import KeychainSwift

struct BankOperation{
    
    static var listOfAccount: [BankAccount]?{
        
        let count = Int(KeychainSwift().get("numberOfAccount")!)
        var _account : [BankAccount]? = nil
        var index = 1
        
        while (index < count!){
            let data = KeychainSwift().getData("Account"+String(index))
            let decodeAccount = try! JSONDecoder().decode(BankAccount.self, from: data!)
            _account?.append(decodeAccount)
            index = index + 1
        }
        return _account
    }
    
    /// number of account saved by user
    static var numberOfAccount:Int?{
        let keychain = KeychainSwift()
        if (keychain.get("numberOfAccount") != nil){
            return Int(keychain.get("numberOfAccount")!)
        }
        return 0
    }
    /// function to increment number of account when user add new account
    static func incrementNumberOfAccount(){
        let count = Int(KeychainSwift().get("numberOfAccount")!)! + 1
        KeychainSwift().set(String(count), forKey: "numberOfAccount")
    }
    
    /// function to save new bank account linked by user
    static func save(bankAccount: BankAccount){
        let bankName = "Account"+String((BankOperation.numberOfAccount!+1))
        let data = try! JSONSerialization.data(withJSONObject: bankAccount, options: .prettyPrinted)
        KeychainSwift().set(data, forKey: bankName)
        BankOperation.incrementNumberOfAccount()
    }
}

protocol BankingProtocol:class{
    func getBankAccount(bankAccount: BankAccount)
}
















//
//  Account+CoreDataClass.swift
//  
//
//  Created by Yveslym on 12/7/17.
//
//

import Foundation
import CoreData

@objc(Account)
public class Account: NSManagedObject,Codable {
   
    required convenience public init(from decoder: Decoder)throws {
       
        enum AccountKey: String, CodingKey{
            case name,account_id, balances, mask, subtype, official_name
            
            enum BalanceKey: String, CodingKey {
                case current, available, limit
            }
        }
        
         let context = CoreDataStack.instance.privateContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Account", in: context) else { fatalError() }
        
        self.init(entity: entity, insertInto: context)
        
        let contenaire = try! decoder.container(keyedBy: AccountKey.self)
        let balanceContenaire = try! contenaire.nestedContainer(keyedBy: AccountKey.BalanceKey.self, forKey: .balances)
        
        self.name = try contenaire.decode(String.self, forKey: .name)
        self.id = try contenaire.decode(String.self, forKey: .account_id)
        self.accNumber = try contenaire.decode(String.self, forKey: .mask) 
        self.subtype = try contenaire.decodeIfPresent(String.self, forKey: .subtype)
       
        self.officialName = try contenaire.decodeIfPresent(String.self, forKey: .official_name)

        //self.balance = try contenaire.decodeIfPresent(Balance.self, forKey: .balances)
        self.limit = try balanceContenaire.decodeIfPresent(String.self, forKey: .limit)
        self.currentBalance = try balanceContenaire.decodeIfPresent(Double.self, forKey: .current)!
        self.availableBalance = try balanceContenaire.decodeIfPresent(Double.self, forKey: .available)!

    }
}

    



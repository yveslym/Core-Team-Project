//
//  Bank+CoreDataClass.swift
//  
//
//  Created by Yveslym on 12/7/17.
//
//

import Foundation
import CoreData

@objc(Bank)
public class Bank: NSManagedObject, Codable {
    
    enum BankAccountKey: String, CodingKey{
        case institution, accounts, status, request_id, link_session_id, itemAccess,transactions
        enum instutionKey: String, CodingKey{
            case institution_id
            case name
            
        }
        enum AccountKey: String, CodingKey{
            case id
            case name
        }
    }
    
    public convenience required init( from decoder: Decoder)throws{
        
        let cont = CoreDataStack.instance.privateContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Bank", in: cont) else { fatalError() }
        
        self.init(entity: entity, insertInto: cont)
        
        let BankContenair = try decoder.container(keyedBy: BankAccountKey.self)
        
        self.requestId = try BankContenair.decodeIfPresent(String.self, forKey: .request_id)
        self.linkSessionId = try BankContenair.decodeIfPresent(String.self, forKey: .link_session_id)
        
        
        let instutitionContenair = try BankContenair.nestedContainer(keyedBy: BankAccountKey.instutionKey.self, forKey: .institution)
        
        self.institutionId = try instutitionContenair.decodeIfPresent(String.self, forKey: .institution_id)
        self.institutionName = try instutitionContenair.decodeIfPresent(String.self, forKey: .name)
        let Allaccount = try BankContenair.decodeIfPresent([Account].self, forKey: .accounts) ?? nil
        
        for account in Allaccount!{
            self.addToAccounts(account)
        }
    }
}


















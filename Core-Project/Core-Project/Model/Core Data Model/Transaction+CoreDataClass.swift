//
//  Transaction+CoreDataClass.swift
//  
//
//  Created by Yveslym on 12/7/17.
//
//

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject, Decodable {

    public convenience required init(from decoder: Decoder) throws {
   
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
        
        //guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        let context = CoreDataStack.instance.privateContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context) else { fatalError() }
        
        self.init(entity: entity, insertInto: context)

        
        let contenair = try decoder.container(keyedBy: TransactionKey.self)
        
        name = try contenair.decodeIfPresent(String.self, forKey: .name) ?? nil
        self.accountID = try contenair.decodeIfPresent(String.self, forKey: .account_id) ?? nil
        self.date = try contenair.decodeIfPresent(String.self, forKey: .date) ?? nil
        self.amount = (try contenair.decodeIfPresent(Double.self, forKey: .amount) ?? nil)!
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
extension Transaction{
    convenience init(context: NSManagedObjectContext) {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Transaction", in:
            context)!
        
        self.init(entity: entityDescription, insertInto: context)
    }
}
















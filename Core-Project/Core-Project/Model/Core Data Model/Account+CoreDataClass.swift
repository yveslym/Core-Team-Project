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
            case name,id
        }
        
        //guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
         let context = CoreDataStack.instance.privateContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Account", in: context) else { fatalError() }
        
        self.init(entity: entity, insertInto: context)
        
        let contenaire = try! decoder.container(keyedBy: AccountKey.self)
        self.name = try contenaire.decode(String.self, forKey: .name)
        self.id = try contenaire.decode(String.self, forKey: .id)
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
    
    



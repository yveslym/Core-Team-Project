//
//  Identity+CoreDataClass.swift
//  Core-Project
//
//  Created by Yveslym on 12/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Identity)
public class Identity: NSManagedObject, Codable {

    enum IdentityKey: String, CodingKey{
        case addresses,names,emails,phone_numbers
    }
    
    convenience required public init(from decoder: Decoder)throws{
        
        let cont = CoreDataStack.instance.privateContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Identity", in: cont) else { fatalError() }
        
        self.init(entity: entity, insertInto: cont)
        
        let contenaire = try! decoder.container(keyedBy: IdentityKey.self)
        self.name = try contenaire.decodeIfPresent(String.self, forKey: .names)
        
       let address = try contenaire.decodeIfPresent([Addresses].self, forKey: .addresses)
        let phone = try contenaire.decodeIfPresent([PhoneNumber].self, forKey: .phone_numbers)
        
        let email = try contenaire.decodeIfPresent([Email].self, forKey: .emails)
        
        address?.forEach({self.addToAddresses($0)})
        phone?.forEach({self.addToPhoneNumber($0)})
        email?.forEach({self.addToEmail($0)})
    }
}

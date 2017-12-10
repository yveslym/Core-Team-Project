//
//  PhoneNumber+CoreDataClass.swift
//  Core-Project
//
//  Created by Yveslym on 12/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PhoneNumber)
public class PhoneNumber: NSManagedObject, Codable {

    enum PhoneNumberKey: String, CodingKey{
        case primary, type,data
    }
    
    convenience required public init(from decoder: Decoder)throws{
        
        let cont = CoreDataStack.instance.privateContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Identity", in: cont) else { fatalError() }
        
        self.init(entity: entity, insertInto: cont)
    
        let contenaire = try! decoder.container(keyedBy: PhoneNumberKey.self)
        let primary = try contenaire.decodeIfPresent(String.self, forKey: .primary)
        self.primary = primary!.toBool()!
        
        self.type = try contenaire.decodeIfPresent(String.self, forKey: .type)
        self.number = try! contenaire.decodeIfPresent(Int16.self, forKey: .data)!
    }
}

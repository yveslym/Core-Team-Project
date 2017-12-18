//
//  Addresses+CoreDataClass.swift
//  Core-Project
//
//  Created by Yveslym on 12/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Addresses)
public class Addresses: NSManagedObject, Codable {

    enum AddressesKey: String, CodingKey{
        case data
        
        enum DataKey: String, CodingKey {
            case city,state,street,zip
        }
    }
    convenience required public init(from decoder: Decoder)throws{
        
        let cont = CoreDataStack.instance.privateContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Identity", in: cont) else { fatalError() }
        
        self.init(entity: entity, insertInto: cont)
        
        let contenaire = try! decoder.container(keyedBy: AddressesKey.self)
        let dataContenaire = try! contenaire.nestedContainer(keyedBy: AddressesKey.DataKey.self, forKey: .data)
        
        self.street = try dataContenaire.decodeIfPresent(String.self, forKey: .street)
        self.city = try dataContenaire.decodeIfPresent(String.self, forKey: .city)
        self.street = try dataContenaire.decodeIfPresent(String.self, forKey: .state)
        self.zipCode = try dataContenaire.decodeIfPresent(String.self, forKey: .zip)
    }
}
































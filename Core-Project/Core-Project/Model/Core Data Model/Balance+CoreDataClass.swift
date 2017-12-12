//
//  Balance+CoreDataClass.swift
//  Core-Project
//
//  Created by Yveslym on 12/11/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Balance)
public class Balance: NSManagedObject, Decodable {

    enum BalanceKey: String, CodingKey{
        case current, available
    }
    convenience required public init(from decoder: Decoder)throws{
        
        let cont = CoreDataStack.instance.privateContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Identity", in: cont) else { fatalError() }
        
        self.init(entity: entity, insertInto: cont)
        
        let contenaire = try! decoder.container(keyedBy: BalanceKey.self)
        self.current = try contenaire.decode(Double.self, forKey: .current)
        self.available = try contenaire.decode(Double.self, forKey: .available)
    }
}

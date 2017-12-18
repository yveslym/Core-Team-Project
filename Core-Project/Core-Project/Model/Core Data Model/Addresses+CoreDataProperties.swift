//
//  Addresses+CoreDataProperties.swift
//  Core-Project
//
//  Created by Yveslym on 12/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//
//

import Foundation
import CoreData


extension Addresses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Addresses> {
        return NSFetchRequest<Addresses>(entityName: "Addresses")
    }

    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var street: String?
    @NSManaged public var zipCode: String?
    @NSManaged public var identity: Identity?

}

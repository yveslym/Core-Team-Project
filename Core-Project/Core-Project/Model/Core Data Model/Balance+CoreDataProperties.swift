//
//  Balance+CoreDataProperties.swift
//  Core-Project
//
//  Created by Yveslym on 12/11/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//
//

import Foundation
import CoreData


extension Balance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Balance> {
        return NSFetchRequest<Balance>(entityName: "Balance")
    }

    @NSManaged public var current: Double
    @NSManaged public var available: Double
    @NSManaged public var account: Account?

}

//
//  PhoneNumber+CoreDataProperties.swift
//  Core-Project
//
//  Created by Yveslym on 12/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//
//

import Foundation
import CoreData


extension PhoneNumber {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneNumber> {
        return NSFetchRequest<PhoneNumber>(entityName: "PhoneNumber")
    }

    @NSManaged public var primary: Bool
    @NSManaged public var type: String?
    @NSManaged public var number: Int16
    @NSManaged public var identity: Identity?

}

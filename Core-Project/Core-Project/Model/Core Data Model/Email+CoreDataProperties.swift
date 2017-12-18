//
//  Email+CoreDataProperties.swift
//  Core-Project
//
//  Created by Yveslym on 12/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//
//

import Foundation
import CoreData


extension Email {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Email> {
        return NSFetchRequest<Email>(entityName: "Email")
    }

    @NSManaged public var email: String?
    @NSManaged public var primary: Bool
    @NSManaged public var type: String?
    @NSManaged public var identity: Identity?

}

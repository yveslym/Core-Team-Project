//
//  ItemAccess+CoreDataProperties.swift
//  
//
//  Created by Yveslym on 12/7/17.
//
//

import Foundation
import CoreData


extension ItemAccess {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemAccess> {
        return NSFetchRequest<ItemAccess>(entityName: "ItemAccess")
    }

    @NSManaged public var accessToken: String?
    @NSManaged public var itemId: String?
    @NSManaged public var bank: Bank?

}

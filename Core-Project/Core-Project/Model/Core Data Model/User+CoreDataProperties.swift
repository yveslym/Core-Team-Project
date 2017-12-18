//
//  User+CoreDataProperties.swift
//  
//
//  Created by Yveslym on 12/7/17.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var uid: String?
    @NSManaged public var username: String?
    @NSManaged public var bank: NSSet?

}

// MARK: Generated accessors for bank
extension User {

    @objc(addBankObject:)
    @NSManaged public func addToBank(_ value: Bank)

    @objc(removeBankObject:)
    @NSManaged public func removeFromBank(_ value: Bank)

    @objc(addBank:)
    @NSManaged public func addToBank(_ values: NSSet)

    @objc(removeBank:)
    @NSManaged public func removeFromBank(_ values: NSSet)

}

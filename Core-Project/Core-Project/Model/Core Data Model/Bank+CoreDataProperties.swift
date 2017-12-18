//
//  Bank+CoreDataProperties.swift
//  
//
//  Created by Yveslym on 12/7/17.
//
//

import Foundation
import CoreData


extension Bank {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bank> {
        return NSFetchRequest<Bank>(entityName: "Bank")
    }

    @NSManaged public var access_token: String?
    @NSManaged public var institutionId: String?
    @NSManaged public var institutionName: String?
    @NSManaged public var linkSessionId: String?
    @NSManaged public var requestId: String?
    @NSManaged public var accounts: NSSet?
    @NSManaged public var itemAccess: ItemAccess?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for accounts
extension Bank {

    @objc(addAccountsObject:)
    @NSManaged public func addToAccounts(_ value: Account)

    @objc(removeAccountsObject:)
    @NSManaged public func removeFromAccounts(_ value: Account)

    @objc(addAccounts:)
    @NSManaged public func addToAccounts(_ values: NSSet)

    @objc(removeAccounts:)
    @NSManaged public func removeFromAccounts(_ values: NSSet)

}

// MARK: Generated accessors for itemAccess
extension Bank {

    @objc(addItemAccessObject:)
    @NSManaged public func addToItemAccess(_ value: ItemAccess)

    @objc(removeItemAccessObject:)
    @NSManaged public func removeFromItemAccess(_ value: ItemAccess)

    @objc(addItemAccess:)
    @NSManaged public func addToItemAccess(_ values: NSSet)

    @objc(removeItemAccess:)
    @NSManaged public func removeFromItemAccess(_ values: NSSet)

}










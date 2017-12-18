//
//  Account+CoreDataProperties.swift
//  
//
//  Created by Yveslym on 12/7/17.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var id: String?
    @NSManaged public var currentBalance: Double
    @NSManaged public var availableBalance: Double
    @NSManaged public var name: String?
    @NSManaged public var accNumber: String
    @NSManaged public var bank: Bank?
    @NSManaged public var transactions: NSSet?
    @NSManaged public var balance: Balance?
    @NSManaged public var subtype: String?
    @NSManaged public var officialName: String?
    @NSManaged public var limit: String?
}

// MARK: Generated accessors for transactions
extension Account {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values:[Transaction])

}

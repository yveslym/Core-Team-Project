//
//  Transaction+CoreDataProperties.swift
//  
//
//  Created by Yveslym on 12/7/17.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var accountID: String?
    @NSManaged public var address: String?
    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var city: String?
    @NSManaged public var date: String?
    @NSManaged public var name: String?
    @NSManaged public var state: String?
    @NSManaged public var types: String?
    @NSManaged public var zipCode: String?
    @NSManaged public var account: Account?
    @NSManaged public var id: String?
     @NSManaged public var dayName: String?
     @NSManaged public var monthName: String?

}

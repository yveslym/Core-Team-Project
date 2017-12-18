//
//  Identity+CoreDataProperties.swift
//  Core-Project
//
//  Created by Yveslym on 12/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//
//

import Foundation
import CoreData


extension Identity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Identity> {
        return NSFetchRequest<Identity>(entityName: "Identity")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: NSSet?
    @NSManaged public var phoneNumber: NSSet?
    @NSManaged public var addresses: NSSet?
    @NSManaged public var account: Account?

}

// MARK: Generated accessors for email
extension Identity {

    @objc(addEmailObject:)
    @NSManaged public func addToEmail(_ value: Email)

    @objc(removeEmailObject:)
    @NSManaged public func removeFromEmail(_ value: Email)

    @objc(addEmail:)
    @NSManaged public func addToEmail(_ values: NSSet)

    @objc(removeEmail:)
    @NSManaged public func removeFromEmail(_ values: NSSet)

}

// MARK: Generated accessors for phoneNumber
extension Identity {

    @objc(addPhoneNumberObject:)
    @NSManaged public func addToPhoneNumber(_ value: PhoneNumber)

    @objc(removePhoneNumberObject:)
    @NSManaged public func removeFromPhoneNumber(_ value: PhoneNumber)

    @objc(addPhoneNumber:)
    @NSManaged public func addToPhoneNumber(_ values: NSSet)

    @objc(removePhoneNumber:)
    @NSManaged public func removeFromPhoneNumber(_ values: NSSet)

}

// MARK: Generated accessors for addresses
extension Identity {

    @objc(addAddressesObject:)
    @NSManaged public func addToAddresses(_ value: Addresses)

    @objc(removeAddressesObject:)
    @NSManaged public func removeFromAddresses(_ value: Addresses)

    @objc(addAddresses:)
    @NSManaged public func addToAddresses(_ values: NSSet)

    @objc(removeAddresses:)
    @NSManaged public func removeFromAddresses(_ values: NSSet)

}

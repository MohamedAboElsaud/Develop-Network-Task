//
//  Contact+CoreDataProperties.swift
//  SimpleContactsTask
//
//  Created by mohamed ahmed on 17/07/2025.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var phoneNumber: String?
    @NSManaged public var name: String?
    @NSManaged public var image: Data?
    @NSManaged public var createdAt: Date?

}

extension Contact : Identifiable {

}

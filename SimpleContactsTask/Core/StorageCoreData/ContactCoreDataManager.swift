//
//  ContactCoreDataManager.swift
//  SimpleContactsTask
//
//  Created by mohamed ahmed on 17/07/2025.
//



import Foundation
import CoreData

class ContactCoreDataManager: StorageManager<ContactModel, Contact> {

    override init() {
        super.init()
    }

    @discardableResult
    override func add(_ entity: ContactModel) async throws -> Contact {
        let contact = Contact(context: self.getContext())

        contact.name = entity.name
        contact.phoneNumber = entity.phoneNumber
        contact.createdAt = Date.now
        contact.image = entity.image.jpegData(compressionQuality: 1)

        try  self.getContext().save()

        return contact
    }
    
    override func getAll() throws -> [Contact] {
        let fetchRequest = Contact.fetchRequest();
        
        let sortByDate = NSSortDescriptor(key: #keyPath(Contact.createdAt), ascending: false)
        
        fetchRequest.sortDescriptors = [sortByDate]
        
        return try getContext().fetch(fetchRequest)
    }
    
    override func getById(id: NSManagedObjectID) throws -> Contact {
        return try getContext().existingObject(with: id) as! Contact
    }

    @discardableResult
    override func update(id: NSManagedObjectID, entity: ContactModel) throws -> Contact {
        let contact = try getById(id: id)
        
        contact.phoneNumber = entity.phoneNumber
        contact.image = entity.image.jpegData(compressionQuality: 1)
        contact.name = entity.name
        
        try self.getContext().save()
        
        return contact
    }
    
    override func delete(id: NSManagedObjectID) throws {
        let contact = try getById(id: id)
        
        getContext().delete(contact)
        
        try getContext().save()
    }
}

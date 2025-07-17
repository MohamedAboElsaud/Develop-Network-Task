//
//  ContactDetailsViewController.swift
//  SimpleContactsTask
//
//  Created by mohamed ahmed on 17/07/2025.
//


import UIKit
import CoreData

class ContactDetailsViewController: UIViewController {

    public var selectedContactId: NSManagedObjectID!
    
    private var contactData: Contact!
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
       return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openEditContact" {
            let contactController = segue.destination as! ContactDataViewController

            contactController.editingContact = contactData
        }
    }
    
    @IBAction func onDeletePress(_ sender: Any) {
        let deleteConfirmation = UIAlertController(title: "Delete contact", message: "Are you sure you want to delete te contact \(contactData.name ?? "")?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action) in
            
            do {
                let contactManager = ContactCoreDataManager()
                try contactManager.delete(id: self.contactData.objectID)
                
                self.navigationController?.popViewController(animated: true)
            } catch {
                ErrorAlert.handleError(self, message: "Error occurs while deleting contact")
            }

        })
        
        deleteConfirmation.addAction(deleteAction)
        deleteConfirmation.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(deleteConfirmation, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            let contactManager = ContactCoreDataManager()
            
            contactData = try contactManager.getById(id: selectedContactId)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YYYY"
            
            nameLabel.text = contactData.name
            phoneLabel.text = contactData.phoneNumber
            createdAtLabel.text = dateFormatter.string(from: contactData.createdAt!)
            
            if let imageData = contactData.image {
                photoImage.image = UIImage(data: imageData)
            }
            
            
        } catch {
            ErrorAlert.handleError(self, message: "Error occurs when loading contact details")
            self.navigationController?.popViewController(animated: true)
        }
    }

}

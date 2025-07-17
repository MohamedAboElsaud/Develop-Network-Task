//
//  ContactsViewController.swift
//  SimpleContactsTask
//
//  Created by mohamed ahmed on 17/07/2025.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addContactButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
       return .lightContent
    }
    
    func UILoad () {
        addContactButton.layer.shadowColor = UIView().tintColor.cgColor
        addContactButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        addContactButton.layer.shadowOpacity = 0.5
        addContactButton.layer.shadowRadius = 10
        addContactButton.layer.masksToBounds = false
        addContactButton.layer.cornerRadius = 4.0
    }
    
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        UILoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "openContactDetails") {
            let contactDetailsController = segue.destination as! ContactDetailsViewController
            
            if let index = tableView.indexPathForSelectedRow?.row {
                contactDetailsController.selectedContactId = contacts[index].objectID
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchContacts()
    }
    
    func fetchContacts() {
        let contactManager = ContactCoreDataManager()
        
        do {
            contacts = try contactManager.getAll()
            tableView.reloadData()
        } catch {
            ErrorAlert.handleError(self, message: "Error occurs fetching contacts")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactCell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
        
        let currentContact = contacts[indexPath.row]
        
        contactCell.name.text = currentContact.name
        contactCell.phoneNumber.text = currentContact.phoneNumber

        if let photo = currentContact.image {
            contactCell.photo.image = UIImage(data: photo)
        }
        return contactCell
    }
    
}

extension UINavigationController {
   open override var preferredStatusBarStyle: UIStatusBarStyle {
       return topViewController?.preferredStatusBarStyle ?? .lightContent
   }
}

//
//  ContactsViewController.swift
//  SimpleContactsTask
//
//  Created by mohamed ahmed on 17/07/2025.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

    var filterContacts = [Contact]()
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!

        filterForSearchTextAndScopeButton(searchText: searchText,scopeButton: scopeButton)
    }

    func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String = "All")
    {
        filterContacts = contacts.filter{ contact in
            let scopeMatch = (scopeButton == "All" || ((contact.name?.lowercased().contains(scopeButton.lowercased())) != nil))
            if (searchController.searchBar.text != ""){
                let searchTextMatch = contact.name?.lowercased().contains(searchText.lowercased())

                return scopeMatch && ((searchTextMatch) != nil)
            }
            else{
                return scopeMatch
            }
        }
        tableView.reloadData()
    }

    @IBOutlet weak var addContactButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    let searchController = UISearchController()

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
        initSearchController()
    }

    func initSearchController(){

        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All", "Favorites"]
        searchController.searchBar.delegate = self

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "openContactDetails") {
            let contactDetailsController = segue.destination as! ContactDetailsViewController

            if let index = tableView.indexPathForSelectedRow?.row {

                if searchController.isActive{
                    contactDetailsController.selectedContactId = filterContacts[index].objectID
                }else{
                    contactDetailsController.selectedContactId = contacts[index].objectID
                }

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
        if(searchController.isActive)
                {
                    return filterContacts.count
                }
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactCell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell


        var currentContact = contacts[indexPath.row]


            if(searchController.isActive)
            {
                currentContact = filterContacts[indexPath.row]
            }
            else
            {
                currentContact = contacts[indexPath.row]
            }

        contactCell.name.text = currentContact.name
        contactCell.phoneNumber.text = currentContact.phoneNumber

        if let photo = currentContact.image {
            contactCell.photo.image = UIImage(data: photo)
        }
        return contactCell
    }


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // delete data and row
            do {
                let contactManager = ContactCoreDataManager()
                try contactManager.delete(id: self.contacts[indexPath.row].objectID)
            } catch {
                ErrorAlert.handleError(self, message: "Error occurs while deleting contact")
            }



            contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }
}

//
//  ContactDataViewController.swift
//  SimpleContactsTask
//
//  Created by mohamed ahmed on 17/07/2025.
//


import UIKit

class ContactDataViewController: UIViewController {

    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var photoThumbnail: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    public var editingContact: Contact?
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
       return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // reuse screen for add new Content or edit Contant
        if editingContact != nil {
            nameField.text = editingContact?.name
            phoneNumberField.text = editingContact?.phoneNumber
            
            if let image = editingContact?.image {
                photoThumbnail.setBackgroundImage(UIImage(data: image), for: .normal)
            }
            
            saveButton.setTitle("Update contact", for: .normal)
            navigationItem.title = "Edit \(editingContact!.name ?? "")"
        }
        
        validateFields()

        // Check TextFields every editing for write values
        nameField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneNumberField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)


        // hidden Keyboard by teach in any where on screen
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture)

    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        validateFields()
    }

    @MainActor
    @IBAction func handleSaveContact(_ sender: UIButton) {
        Task {
            let contactData = ContactModel(name: nameField!.text ?? "NA", phoneNumber: phoneNumberField!.text ?? "NA", image: photoThumbnail.backgroundImage(for: .normal) ?? UIImage())

            let contactsManager = ContactCoreDataManager()

            do {
                if editingContact == nil {
                    _ = try await contactsManager.add(contactData)
                } else {
                    _ = try contactsManager.update(id: editingContact!.objectID, entity: contactData)
                }

                self.navigationController?.popViewController(animated: true)
            } catch {
                ErrorAlert.handleError(self, message: "Error occurs saving contact. Try again later")
            }
        }
    }
    
    @IBAction func onPhotoChangePress(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }


    func validateFields () {
        var isValid = true

        if  nameField.text!.isEmpty || nameField.text!.count < 4 {
            isValid = false
        }
        
        if phoneNumberField.text!.isEmpty || phoneNumberField.text!.count < 8 {
            isValid = false
        }
            saveButton.isEnabled = isValid
    }
}

extension ContactDataViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        if let selected = info[.editedImage] as? UIImage {
            photoThumbnail.setBackgroundImage(selected, for: .normal)
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
}

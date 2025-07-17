//
//  ContactModel.swift
//  SimpleContactsTask
//
//  Created by mohamed ahmed on 17/07/2025.
//


import Foundation
import UIKit

struct ContactModel {
    let name: String
    let phoneNumber: String
    let image: UIImage

    init(name: String, phoneNumber: String, image: UIImage) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.image = image
    }
}

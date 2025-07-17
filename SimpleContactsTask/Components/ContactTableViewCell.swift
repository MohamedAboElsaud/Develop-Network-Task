//
//  ContactTableViewCell.swift
//  SimpleContactsTask
//
//  Created by mohamed ahmed on 17/07/2025.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

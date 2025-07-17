//
//  ErrorAlert.swift
//  SimpleContactsTask
//
//  Created by mohamed ahmed on 17/07/2025.
//


import Foundation
import UIKit

class ErrorAlert {

    static func handleError(_ context: UIViewController, message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        context.present(alert, animated: true, completion: nil)
    }
    
}

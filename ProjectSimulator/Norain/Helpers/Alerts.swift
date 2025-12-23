//
//  Alerts.swift
//  ProjectSimulator
//
//  Created by Norain  on 18/12/2025.
//

import UIKit

class Alerts{
    static func confirmation(on vc: UIViewController, title: String, message: String, confirmHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Confirm", style: .default) { _ in
            confirmHandler()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        // Use the passed-in View Controller to show the alert
        vc.present(alert, animated: true)
    }
}

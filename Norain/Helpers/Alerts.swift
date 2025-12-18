//
//  Alerts.swift
//  ProjectSimulator
//
//  Created by Norain  on 18/12/2025.
//

import UIKit

extention UIViewController{
    
    
    func Confirmation(title:String, message:String,confirmHandler: @escaping() ->Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default){action in
                confirmHandler()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
}

//
//  Donor.swift
//  ProjectSimulator
//
//  Created by Norain  on 18/12/2025.
//

import Foundation
class NorainDonor: NorainAppUser{
    var bio: String
    
    init(documentID: String,dictionary: [String: Any]) {
            let username = dictionary["username"] as? String ?? ""
            let name = dictionary["full_name"] as? String ?? ""
            let email = dictionary["email"] as? String ?? ""
            let userImg = dictionary["profile_image_url"] as? String ?? ""
            let phoneNumber = dictionary["number"] as? String ?? "12345678"
            let role = dictionary["role"] as? Int ?? 2
            let notifications_enabled = dictionary["notifications_enabled"] as? Bool ?? true
            let profile_completed = dictionary["profile_completed"] as? Bool ?? true
        
            self.bio = dictionary["mission"] as? String ?? "No donor bio entered."
    
        super.init(documentID: documentID,username: username, name: name, phoneNumber: phoneNumber, email: email, userImg: userImg, role: 3,notifications_enabled: notifications_enabled)
        }
    
    
    
    
}

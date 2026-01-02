//
//  NGO.swift
//  ProjectSimulator
//
//  Created by Norain  on 18/12/2025.
//

import Foundation

enum NGOStatus: String, CaseIterable {
    case pending = "Pending"
    case approved = "Approved"
    case rejected = "Rejected"
}

class NorainNGO: NorainAppUser {
    var cause:String
    var address:String
    var governorate:String
    var status: NGOStatus
    var mission:String
    var rejectionReason: String?
    
    init(documentID: String,dictionary: [String: Any]) {
            // 1. Extract values from dictionary (matching Firebase keys exactly)
            let username = dictionary["username"] as? String ?? ""
            let name = dictionary["organization_name"] as? String ?? ""
            let email = dictionary["email"] as? String ?? ""
            let userImg = dictionary["profile_image_url"] as? String ?? ""
            let phoneNumber = dictionary["number"] as? Int ?? 12345678
            let notifications_enabled = dictionary["notifications_enabled"] as? Bool ?? true
        
            self.status = NGOStatus(rawValue: dictionary["status"] as? String ?? "Pending") ?? .pending
            self.rejectionReason = dictionary["rejectionReason"] as? String
            self.cause = dictionary["cause"] as? String ?? ""
            self.address = dictionary["address"] as? String ?? ""
            self.mission = dictionary["mission"] as? String ?? "No NGO mission entered."
            self.governorate = dictionary["governorate"] as? String ?? ""
           
            

            // 2. Pass base data to super
        super.init(documentID: documentID,username: username, name: name, phoneNumber: phoneNumber, email: email, userImg: userImg, role: 3,notifications_enabled: notifications_enabled)
        }
    
}

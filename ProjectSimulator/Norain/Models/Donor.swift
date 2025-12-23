//
//  Donor.swift
//  ProjectSimulator
//
//  Created by Norain  on 18/12/2025.
//

import Foundation
class Donor: AppUser{
    var bio: String
    
    init(userName: String, password: String, name: String, phoneNumber: Int, email: String, address: String,userImg: String,bio: String) {
        self.bio = bio
        super.init(userName: userName, password: password, name: name, phoneNumber: phoneNumber, email: email, userImg: userImg)
    }
    
    
    
    
}

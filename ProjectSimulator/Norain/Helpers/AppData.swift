//
//  AppData.swift
//  ProjectSimulator
//
//  Created by Norain  on 18/12/2025.
//

import Foundation
class AppData{
    
    static var users = [AppUser]()
    
    static func load(){
        //load all data stored in a file
        if users.isEmpty{
            users = sampleUsers
        }
    }
    static var sampleUsers = [
        Donor(userName: "norain.hani", password:"1234", name: "norain hani", phoneNumber: 33744063, email: "norain.hani@gmail.com", address: "house 23, block 432, road 567"),
        NGO(userName: "Amal.Foundation", password: "1234", name: "Amal Foundation", phoneNumber: 17112355, email: "amalfoundation@gmail.com", cause: "Women rights", address: "building 123, block 456, road 789", governorate: "Muharraq", IsApproved: true, IsRejected: false, IsPending: false)
    ]
    
}

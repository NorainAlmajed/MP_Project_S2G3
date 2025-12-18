//
//  User.swift
//  ProjectSimulator
//
//  Created by Norain  on 18/12/2025.
//

import Foundation
class AppUser {
    var userName:String
    var password:String
    var name : String
    var phoneNumber:Int
    var email:String

    init(userName: String, password: String, name: String, phoneNumber: Int, email: String) {
        self.userName = userName
        self.password = password
        self.phoneNumber = phoneNumber
        self.email = email
        self.name = name
    }
    
    
    
    
}

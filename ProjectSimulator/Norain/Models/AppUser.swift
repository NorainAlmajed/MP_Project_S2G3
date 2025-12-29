//
//  User.swift
//  ProjectSimulator
//
//  Created by Norain  on 18/12/2025.
//

import Foundation
class NorainAppUser {
    var documentID: String
    var username:String
    var name : String
    var phoneNumber:Int
    var email:String
    var userImg:String
    var role:Int
    var notifications_enabled:Bool


    init(documentID: String,username: String, name: String, phoneNumber: Int, email: String, userImg: String,role:Int,notifications_enabled:Bool) {
        self.documentID = documentID
        self.username = username
        self.phoneNumber = phoneNumber
        self.email = email
        self.name = name
        self.userImg = userImg
        self.role = role
        self.notifications_enabled = notifications_enabled
    }
    
    
    
    
}

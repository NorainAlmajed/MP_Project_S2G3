//
//  NGO.swift
//  ProjectSimulator
//
//  Created by Norain  on 18/12/2025.
//

import Foundation
class NGO: AppUser {
    var cause:String
    var address:String
    var governorate:String
    var IsApproved:Bool
    var IsRejected:Bool
    var IsPending:Bool
    
    init( userName: String, password: String,name:String, phoneNumber: Int,email:String, cause: String, address: String, governorate: String,IsApproved:Bool,IsRejected:Bool,IsPending:Bool) {
        self.cause = cause
        self.address = address
        self.governorate = governorate
        self.IsApproved = IsApproved
        self.IsRejected = IsRejected
        self.IsPending = IsPending
        super.init(userName: userName, password: password, name: name, phoneNumber:phoneNumber, email: email)
    }
    
}

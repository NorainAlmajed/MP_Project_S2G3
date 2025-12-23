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
    var isApproved:Bool
    var isRejected:Bool
    var isPending:Bool
    var mission:String
    
    init( userName: String, password: String,name:String, phoneNumber: Int,email:String, cause: String, address: String, governorate: String,isApproved:Bool,isRejected:Bool,isPending:Bool, userImg:String,mission:String) {
        self.cause = cause
        self.address = address
        self.governorate = governorate
        self.isApproved = isApproved
        self.isRejected = isRejected
        self.isPending = isPending
        self.mission = mission
        super.init(userName: userName, password: password, name: name, phoneNumber:phoneNumber, email: email,userImg:userImg)
    }
    
}

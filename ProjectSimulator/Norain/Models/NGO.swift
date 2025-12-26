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

class NGO: AppUser {
    var cause:String
    var address:String
    var governorate:String
    var status: NGOStatus
    var mission:String
    var rejectionReason: String?
    
    init( userName: String, password: String,name:String, phoneNumber: Int,email:String, cause: String, address: String, governorate: String, userImg:String,mission:String, status:NGOStatus = .pending,rejectionReason: String? = nil) {
        self.cause = cause
        self.address = address
        self.mission = mission
        self.governorate = governorate
        self.status = status
        self.rejectionReason = rejectionReason
        super.init(userName: userName, password: password, name: name, phoneNumber:phoneNumber, email: email,userImg:userImg)
    }
    
}

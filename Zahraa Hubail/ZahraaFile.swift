//
//  Address.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 29/11/2025.
//

import UIKit

protocol ZahraaAddressDelegate: AnyObject {
    func didAddAddress(_ address: ZahraaAddress)
}

class ZahraaAddress {
    var building: String
    var road: String
    var block: String
    var flat: String?
    var area: String
    var governorate: String
    
    init(building: String, road: String, block: String, flat: String?, area: String, governorate: String) {
        self.building = building
        self.road = road
        self.block = block
        self.flat = flat
        self.area = area
        self.governorate = governorate
    }
}

struct Notification {
    var title: String
    var description: String
    var date: Date
    var userID: String
}


struct ZahraaUser {
    let userID: String                  // Firestore documentID
    var fullName: String?           // optional
    var username: String
    let role: Int                   // 1=admin, 2=donor, 3=NGO
    var enableNotification: Bool = true
    var profile_image_url: String? = ""
    var organization_name: String?
}


struct Address {
    var name: String?
    var building: String
    var road: String
    var block: String
    var flat: String
    var area: String
    var governorate: String
    var fullAddress: String {
        return "\(building), \(road), \(block)\n\(area), \(governorate)"
    }
}

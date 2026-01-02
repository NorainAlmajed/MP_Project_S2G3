//
//  Address.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 29/11/2025.
//

import UIKit
import FirebaseFirestore


protocol ZahraaAddressDelegate: AnyObject {
    func didAddAddress(_ address: ZahraaAddress)
}

struct ZahraaAddress {
    var name: String?
    var building: String
    var road: String
    var block: String
    var flat: String?
    var area: String
    var governorate: String
    var fullAddress: String? {
        return "\(building), \(road), \(block)\n\(area), \(governorate)"
    }
 
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




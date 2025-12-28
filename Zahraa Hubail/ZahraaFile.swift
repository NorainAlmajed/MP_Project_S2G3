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


class Donation {
    var firestoreID: String?
    var donationID: Int                   // Firestore auto-generated document ID
    var ngo: ZahraaUser            // Reference to NGO in Firestore
    var creationDate: Timestamp
    var donor: ZahraaUser          // Reference to donor in Firestore§
    var address: ZahraaAddress        // Reference to address in Firestore
    var pickupDate: Timestamp
    var pickupTime: String
    var foodImageUrl: String
    var status: Int
    var category: String
    var quantity: Int
    var weight: Double?
    var expiryDate: Timestamp
    var description: String?
    var rejectionReason: String?
    var recurrence: Int

    init(
        firestoreID: String,
        donationID: Int,
        ngo: ZahraaUser,
        creationDate: Timestamp,
        donor: ZahraaUser,
        address: ZahraaAddress,
        pickupDate: Timestamp,
        pickupTime: String,
        foodImageUrl: String,
        status: Int,
        category: String,
        quantity: Int,
        weight: Double? = nil,
        expiryDate: Timestamp,
        description: String? = nil,
        rejectionReason: String? = nil,
        recurrence: Int = 0
    ) {
        self.firestoreID = firestoreID
        self.donationID = donationID
        self.ngo = ngo
        self.creationDate = creationDate
        self.donor = donor
        self.address = address
        self.pickupDate = pickupDate
        self.pickupTime = pickupTime
        self.foodImageUrl = foodImageUrl
        self.status = status
        self.category = category
        self.quantity = quantity
        self.weight = weight
        self.expiryDate = expiryDate
        self.description = description
        self.rejectionReason = rejectionReason
        self.recurrence = recurrence
    }
}

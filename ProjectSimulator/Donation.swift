//
//  Donation.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 28/11/2025.
//

import UIKit
import FirebaseFirestore


class Donation {
    var firestoreID: String?  
    var donationID: Int                   // Firestore auto-generated document ID
    var ngo: User            // Reference to NGO in Firestore
    var creationDate: Timestamp
    var donor: User          // Reference to donor in Firestore§
    var address: Address        // Reference to address in Firestore
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
        donationID: Int,
        ngo: User,
        creationDate: Timestamp,
        donor: User,
        address: Address,
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


//var donations: [Donation] = [
//    Donation(donationID: 91475, ngo: "Karrana Charity Society", creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date()s, pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 1, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
//    
//    Donation(donationID: 91475, ngo: "Karrana Charity Society", creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 2, Category: "Bakery", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
//    
//    Donation(donationID: 91475, ngo: "Karrana Charity Society", creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 3, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
//    
//    Donation(donationID: 91475, ngo: "Karrana Charity Society", creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 4, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
//    
//    Donation(donationID: 91475, ngo: "Karrana Charity Society", creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 5, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
//    
//    Donation(donationID: 91475, ngo: "Karrana Charity Society", creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 1, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
//    
//    Donation(donationID: 91475, ngo: "Karrana Charity Society", creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 2, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor")
//]

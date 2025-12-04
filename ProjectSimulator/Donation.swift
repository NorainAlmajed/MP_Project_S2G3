//
//  Donation.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 28/11/2025.
//

import UIKit

struct Donation {
    let donationID: Int
    let ngo: String //Change
    let creationDate: Date
    let donor: String //Change
    var address: Address
    var pickupDate: Date
    var pickupTime: String
    var foodImage: UIImage
    var status: Int
    var Category: String
    var quantity: Int
    var weight: Double?
    var expiryDate: Date
    var description: String?
    
}

var donations: [Donation] = [
    Donation(donationID: 91475, ngo: "Karrana Charity Society", creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 1, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
    
    Donation(donationID: 91475, ngo: "Karrana Charity Society", creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 2, Category: "Bakery", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
    
    Donation(donationID: 91475, ngo: "Karrana Charity Society", creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 3, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
    
    Donation(donationID: 91475, ngo: "Karrana Charity Society", creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 4, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
    
    Donation(donationID: 91475, ngo: "Karrana Charity Society", creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 5, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
    
    Donation(donationID: 91475, ngo: "Karrana Charity Society", creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 1, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
    
    Donation(donationID: 91475, ngo: "Karrana Charity Society", creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 2, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor")
]

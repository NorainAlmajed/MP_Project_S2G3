//
//  Address.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 29/11/2025.
//

import UIKit

struct Address {
    var building: Int
    var road: Int
    var block: Int
    var flat: Int?
    var area: String
    var governorate: String
}

struct Notification {
    var title: String
    var description: String
    var date: Date
}


struct User {
    var fullName: String
    var username: String
    var notifications: [Notification]?
    var donations: [Donation]?
    let userType: Int
    var enableNotification: Bool = true
}


var users: [User] = [
    
    User(fullName: "Zahraa Hubail", username: "zahraa.hubail",
          notifications: [
            
            Notification(title: "NGO Awaiting Approval", description: "alnoor.association has just signed up and is awaiting your verification.", date: Date()),
                         
            Notification(title: "New Donor Regestration", description: "zahraa.hubail has just signed up to the system", date: Date()),
                         
            Notification(title: "New Donation Recieved", description: "Donor fatima.hassan has made a new donation to UCO Elderly Care.", date: Date()),
            
            Notification(title: "New Donation Recieved", description: "Donor fatima.hassan has made a new donation to UCO Elderly Care.", date: Date()),
            
            Notification(title: "New Donation Recieved", description: "Donor fatima.hassan has made a new donation to UCO Elderly Care.", date: Date()),
            
            Notification(title: "New Donation Recieved", description: "Donor fatima.hassan has made a new donation to UCO Elderly Care.", date: Date()),
            
            Notification(title: "New Donation Recieved", description: "Donor fatima.hassan has made a new donation to UCO Elderly Care.", date: Date()),
            
            Notification(title: "New Donation Recieved", description: "Donor fatima.hassan has made a new donation to UCO Elderly Care.", date: Date())
        ],
          donations: [
            Donation(donationID: 91475, ngo: ngo1, creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "8AM - 9PM", foodImage: UIImage(named: "apples") ?? UIImage(), status: 1, Category: "Produce", quantity: 30, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor", recurrence: 1),
            
            Donation(donationID: 88888, ngo: ngo2, creationDate: Date(), donor: "raghad.aleskafi", address: Address(building: 1111, road: 2222, block: 3333, flat: 402, area: "Seef", governorate: "North"), pickupDate: Date(), pickupTime: "12AM - 2PM", foodImage: UIImage(named: "apples") ?? UIImage(), status: 2, Category: "Bakery", quantity: 88, weight: 8.8, expiryDate: Date(), rejectionReason: "The food does not meet the quality standards.", recurrence: 3),
            
            Donation(donationID: 91475, ngo: ngo2, creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 3, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "   ", rejectionReason: "   ", ),
            
            Donation(donationID: 91475, ngo: ngo1, creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 4, Category: "Produce", quantity: 30, weight: 18.8, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor", rejectionReason: "The food does not meet the quality standards, it's not ripe enough."),
            
            Donation(donationID: 91475, ngo: ngo2, creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 5, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
            
            Donation(donationID: 91475, ngo: ngo1, creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 1, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
            
            Donation(donationID: 91475, ngo: ngo1, creationDate: Date(), donor: "zahraa.hubail", address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 2, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor")
        ],
         userType: 1
)
]


 var user = users[0]

var notifications: [Notification] = [
    
    Notification(title: "NGO Awaiting Approval", description: "alnoor.association has just signed up and is awaiting your verification.", date: Date()),
                 
    Notification(title: "New Donor Regestration", description: "zahraa.hubail has just signed up to the system", date: Date()),
                 
    Notification(title: "New Donation Recieved", description: "Donor fatima.hassan has made a new donation to UCO Elderly Care.", date: Date()),
    
    Notification(title: "New Donation Recieved", description: "Donor fatima.hassan has made a new donation to UCO Elderly Care.", date: Date()),
    
    Notification(title: "New Donation Recieved", description: "Donor fatima.hassan has made a new donation to UCO Elderly Care.", date: Date()),
    
    Notification(title: "New Donation Recieved", description: "Donor fatima.hassan has made a new donation to UCO Elderly Care.", date: Date()),
    
    Notification(title: "New Donation Recieved", description: "Donor fatima.hassan has made a new donation to UCO Elderly Care.", date: Date()),
    
    Notification(title: "New Donation Recieved", description: "Donor fatima.hassan has made a new donation to UCO Elderly Care.", date: Date())
]


struct NGO {
    var ngoName: String
    var logo: UIImage
}

var ngo1 = NGO(ngoName: "Karrana Charity Society",
              logo: UIImage(named: "KarranaCharity") ?? UIImage())

var ngo2 = NGO(ngoName: "Al kawther Society Social Care",
              logo: UIImage(named: "alkawthar") ?? UIImage())

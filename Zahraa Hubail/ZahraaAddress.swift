//
//  Address.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 29/11/2025.
//

import UIKit

struct ZahraaAddress {
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



//var userNotifications: [Notification] = [
//    
//    Notification(title: "NGO Awaiting Approval", description: "alnoor.association has just signed up and is awaiting your verification.", date: Date().addingTimeInterval(-300)),
//                     
//    Notification(title: "New Donor Regestration", description: "zahraa.hubail has just signed up to the system", date: Date().addingTimeInterval(-100)),
//                     
//    Notification(title: "New Donation Recieved", description: "Donor fatima.hassan has made a new donation to UCO Elderly Care.", date: Date().addingTimeInterval(-200)),
//        
//    Notification(title: "Donation Rejected", description: "Donation #1234 has been rejected by the admin.", date: Date()),
//        
//    Notification(title: "New Donation Accepted", description: "Donation #1234 has been accepted by the admin.", date: Date().addingTimeInterval(-400)),
//        
//    Notification(title: "New Donation Recieved", description: "Donor fatima.hassan has made a new donation to UCO Elderly Care.", date: Date().addingTimeInterval(-500)),
//        
//    Notification(title: "New Donation Recieved", description: "Donor fatima.hassan has made a new donation to UCO Elderly Care.", date: Date().addingTimeInterval(-600)),
//        
//    Notification(title: "New Donation Recieved", description: "Donor fatima.hassan has made a new donation to UCO Elderly Care.", date: Date().addingTimeInterval(-700))
//
//]


//var users: [User] = [
//    
//    User(fullName: "Zahraa Hubail", username: "zahraa.hubail",
//         notifications: userNotifications,
         
//          donations: [
//            Donation(donationID: 91475, ngo: ngo1, creationDate: Date(), donor: user1, address: Address(building: 1311, road: 3027, block: 430, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "8AM - 9PM", foodImage: UIImage(named: "apples") ?? UIImage(), status: 1, Category: "Produce", quantity: 30, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor", recurrence: 1),
//            
//            Donation(donationID: 88888, ngo: ngo2, creationDate: Date(), donor: user1, address: Address(building: 1111, road: 2222, block: 3333, flat: 402, area: "Seef", governorate: "North"), pickupDate: Date(), pickupTime: "12AM - 2PM", foodImage: UIImage(named: "apples") ?? UIImage(), status: 2, Category: "Bakery", quantity: 88, weight: 8.8, expiryDate: Date(), rejectionReason: "The food does not meet the quality standards.", recurrence: 3),
//            
//            Donation(donationID: 91475, ngo: ngo2, creationDate: Date(), donor: user1, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 3, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "   ", rejectionReason: "   ", ),
//            
//            Donation(donationID: 91475, ngo: ngo1, creationDate: Date(), donor: user1, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 4, Category: "Produce", quantity: 30, weight: 18.8, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor", rejectionReason: "The food does not meet the quality standards, it's not ripe enough."),
//            
//            Donation(donationID: 91475, ngo: ngo2, creationDate: Date(), donor: user1, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 5, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
//            
//            Donation(donationID: 91475, ngo: ngo1, creationDate: Date(), donor: user1, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 1, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
//            
//            Donation(donationID: 91475, ngo: ngo1, creationDate: Date(), donor: user1, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 2, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor")
////        ],
//         userType: 1
//)
//]

//var user = users[0]
//
//var admin = User(fullName: "Haetham Alhaddad", username: "haetham.alhaddad", userType: 1)
//


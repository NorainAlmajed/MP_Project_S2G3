//
//  File.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 11/12/2025.
//

import UIKit


struct NGO//THIS IS THE NAME OF THE STRUCT
{
    let name: String
    let category: String
    let photo: UIImage
    let mission: String
    let phoneNumber: Int
    let email: String
    }





var arrNgo: [NGO] =
    //[] to make it nil
[
    NGO(
        name: "Al kawther Society Social Care",
        category: "Orphanage",
        photo: UIImage(named: "img_alkwther_logo") ?? UIImage(),
        mission: "Al Kawther Society for Social Care is dedicated to nurturing and empowering orphans by providing them with education, emotional support, and a safe environment to grow into confident and compassionate members of society.",
        phoneNumber: 17677737,
        email: "contact@alkawthersociety.org"
        
    ),
    
    NGO(
        name: "Amal Foundation",
        category: "Charity",
        photo: UIImage(named: "img_amal_logo") ?? UIImage(),
        mission: "Amal Foundation’s mission is to bring hope and dignity to widowed women by empowering them with emotional support, education, and sustainable opportunities to rebuild their lives with confidence and purpose.",
        phoneNumber: 17677777,
        email: "info@amalfoundation.org"
    ),
    
    NGO(
        name: "Uco Elderly Care",
        category: "Adult Day Care Center",
        photo: UIImage(named: "img_uco_logo") ?? UIImage(),
        mission: "To provide compassionate care, support, and a safe environment for elderly individuals, promoting their well-being, dignity, and active participation in the community.",
        phoneNumber: 17677717,
        email: "uco@gmail.com"
    ),
    
    NGO(
        name: "Heal Foundation",
        category: "Rehabilitation & Recovery",
        photo: UIImage(named: "img_heal_logo") ?? UIImage(),
        mission: "Heal is dedicated to helping individuals recover from addiction with compassion, guidance, and community support empowering them to rebuild their lives with dignity, strength, and hope.",
        phoneNumber: 17645189,
        email: "info@heal.org"
    )
]



struct User {
    //  This struct represents ONE donor (admin chooses from these)
    let username: String
    let userType: Int
}



// MARK: - Donor Data Source
//  Central place for all donors (NO hardcoding in ViewControllers)
var users: [User] = [
    User(username: "zahraa_hubail",userType: 1),//admin
    User(username: "raghad_aleskafi",userType: 2),//donor
    User(username: "norain_almajed",userType: 3),
    User(username: "fatima_alaiwi",userType: 1),
    User(username: "zainab_mahdi",userType: 2),
    User(username: "ali_ahmed",userType: 1),
    User(username: "yousif_ali",userType: 1),
    User(username: "hassan_mahdi",userType: 2)
]

var user = users [0]

extension User {
    var isAdmin: Bool { userType == 1 }   // ✅ Admin = 1 donor= 2
}






//old
//var arrNgo = [NgoData]()//create empty array  + the name of the struct that i made  down
//
//
//var ngoDataArray: [NgoData] = [
//NgoData(name: "Al kawther Society Social Care", category: "Orphanage", photo: UIImage named: "img_alkwther_logo")!
//
//
//arrNgo.append(NgoData.init(name: "Amal Foundation", category: "Charity", photo: UIImage(named: "img_amal_logo")!))
//arrNgo.append(NgoData.init(name: "Uco Elderly Care", category: "Adult Day Care Center", photo: UIImage(named: "img_uco_logo")!))
//arrNgo.append(NgoData.init(name: "Heal Foundation", category: "Rehabilitation & Recovery", photo: UIImage(named: "img_heal_logo")!))

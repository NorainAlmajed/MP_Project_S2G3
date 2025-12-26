//
//  File.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 11/12/2025.
//



// check if i can come back

//again
//now i can push
import UIKit
import Foundation


struct NGO//THIS IS THE NAME OF THE STRUCT
{
    let id: String   
    let name: String
    let category: String
    let photo: String
    let mission: String
    let phoneNumber: String
    let email: String
    }





var arrNgo: [NGO] =
    //[] to make it nil
[
    NGO(
        id: "alkawther",
        name: "Al kawther Society Social Care",
        category: "Orphanage",
        photo: "https://alkawther-orphan.org/wp-content/uploads/2022/10/website-logo-01.png",
        mission: "Al Kawther Society for Social Care is dedicated to nurturing and empowering orphans by providing them with education, emotional support, and a safe environment to grow into confident and compassionate members of society.",
        phoneNumber: "17677737",
        email: "contact@alkawthersociety.org"
        
    ),
    
    NGO(
        id: "amal",
        name: "Amal Foundation",
        category: "Charity",
        photo: "https://alkawther-orphan.org/wp-content/uploads/2022/10/website-logo-01.png",
        mission: "Amal Foundation’s mission is to bring hope and dignity to widowed women by empowering them with emotional support, education, and sustainable opportunities to rebuild their lives with confidence and purpose.",
        phoneNumber: "17677777",
        email: "info@amalfoundation.org"
    ),
    
    NGO(
        id: "uco",
        name: "Uco Elderly Care",
        category: "Adult Day Care Center",
        photo: "https://alkawther-orphan.org/wp-content/uploads/2022/10/website-logo-01.png",
        mission: "To provide compassionate care, support, and a safe environment for elderly individuals, promoting their well-being, dignity, and active participation in the community.",
        phoneNumber: "17677717",
        email: "uco@gmail.com"
    ),
    
    NGO(
        id: "heal",
        name: "Heal Foundation",
        category: "Rehabilitation & Recovery",
        photo: "https://alkawther-orphan.org/wp-content/uploads/2022/10/website-logo-01.png",
        mission: "Heal is dedicated to helping individuals recover from addiction with compassion, guidance, and community support empowering them to rebuild their lives with dignity, strength, and hope.",
        phoneNumber: "17645189",
        email: "info@heal.org"
    )
]



struct User {
    //  This struct represents ONE donor (admin chooses from these)
    //let id: String      // Firestore document id
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





// MARK: - Donation Draft (Local only)
// Keeps form data when user goes back, without saving to Firebase.

struct DonationDraft {
    var ngoId: String
    var donorName: String?
    var foodCategory: String?
    var quantity: Int?
    var weight: Double?
    var expiryDate: Date?
    var shortDescription: String?
    var imageUrl: String?
    var imageData: Data?      //  (for showing image after back)
    

}

final class DonationDraftStore {
    static let shared = DonationDraftStore()
    private init() {}

    private var drafts: [String: DonationDraft] = [:] // key = ngoId

    func save(_ draft: DonationDraft) {
        drafts[draft.ngoId] = draft
    }

    func load(ngoId: String) -> DonationDraft? {
        drafts[ngoId]
    }

    func clear(ngoId: String) {
        drafts.removeValue(forKey: ngoId)
    }
}




struct DonationPayload {
    let ngoId: String
    let donorName: String?        // nil if donor is donating for themselves
    let foodCategory: String
    let quantity: Int
    let weight: Double?
    let expiryDate: Date
    let shortDescription: String?
    let imageUrl: String
}



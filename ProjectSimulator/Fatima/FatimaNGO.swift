import Foundation
import FirebaseFirestore

struct FatimaNGO {
    let id: String
    let organizationName: String
    let cause: String
    let mission: String
    let email: String
    let number: String
    let profileImageURL: String
    let role: Int

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()

        // role can come as Int or as NSNumber depending on how you stored it
        let roleValue: Int
        if let r = data["role"] as? Int {
            roleValue = r
        } else if let r = data["role"] as? NSNumber {
            roleValue = r.intValue
        } else {
            return nil
        }

        // Only accept NGOs
        guard roleValue == 3 else { return nil }

        self.id = document.documentID
        self.organizationName = data["organization_name"] as? String ?? "Unknown NGO"
        self.cause = data["cause"] as? String ?? "Charity"
        self.mission = data["mission"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.number = data["number"] as? String ?? ""
        self.profileImageURL = data["profile_image_url"] as? String ?? ""
        self.role = roleValue
    }
}

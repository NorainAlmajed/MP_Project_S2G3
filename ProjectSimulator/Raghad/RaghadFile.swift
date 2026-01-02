//
//  File.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 11/12/2025.
//



import UIKit
import Foundation


struct NGO
{
    let id: String   
    let name: String
    let category: String
    let photo: String
    let mission: String
    let phoneNumber: String
    let email: String
    
}




struct DraftUser {
    let username: String
    let userType: Int
    var isAdmin: Bool { userType == 1 }
}




struct DonationDraft {
    var ngoId: String
    var ngoName: String

    var donorName: String?
    var donorRefPath: String?
    
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
    let ngoName: String
    let donorRefPath: String?
    let foodCategory: String
    let quantity: Int
    let weight: Double?
    let expiryDate: Date
    let shortDescription: String?
    let imageUrl: String
}

//
//  Models.swift
//  ProjectSimulator
//
//  Created by Norain  on 25/12/2025.
//

import Foundation


import Foundation
import FirebaseFirestore

struct IncompleteDonation {
    var category: String?
    var description: String?
    var quantity: Int?
    var weight: Double?
    var foodImageUrl: String?
    var expiryDate: Date?
    var donationID: Int?
    var ngo: DocumentReference?
}

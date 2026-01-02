//
//  Address.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 02/01/2026.
//

import Foundation


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


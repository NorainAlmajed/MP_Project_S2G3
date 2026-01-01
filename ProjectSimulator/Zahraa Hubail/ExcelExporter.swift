//
//  ExcelExporter.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 18/12/2025.
//

import UIKit

class ExcelExporter {

    // Create CSV file for a donation
    static func createDonationCSV(donation: Donation) -> URL? {
        // Temporary file path
        let filePath = FileManager.default.temporaryDirectory.appendingPathComponent("DonationReport.csv")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        // Status text
        let statusText: String
        switch donation.status {
        case 1: statusText = "Pending"
        case 2: statusText = "Accepted"
        case 3: statusText = "Collected"
        case 4: statusText = "Rejected"
        case 5: statusText = "Cancelled"
        default: statusText = "Unknown"
        }
        
        // Full address
        let address = donation.address
        let fullAddress = "Building: \(address.building), Road: \(address.road), Block: \(address.block), Flat: \(address.flat.map { "\($0)" } ?? "0"), Area: \(address.area), Governorate: \(address.governorate)"

        // CSV header
        var csvText = """
        Donation ID,NGO Name,Donor Username,Category,Quantity,Weight,Pickup Date,Pickup Time,Expiry Date,Status,Address,Description,Recurrence
        """
        csvText += "\n"
        
        // CSV row
        let weightString = donation.weight != nil ? "\(donation.weight!)" : "-"
        let descriptionString = donation.description ?? "-"
        let recurrenceString = donation.recurrence > 0 ? "\(donation.recurrence)" : "None"
        
        csvText += "\(donation.donationID),\(donation.ngo.fullName ?? donation.ngo.username),\(donation.donor.username),\(donation.category),\(donation.quantity),\(weightString),\(dateFormatter.string(from: donation.pickupDate.dateValue())),\(donation.pickupTime),\(dateFormatter.string(from: donation.expiryDate.dateValue())),\(statusText),\(fullAddress),\(descriptionString),\(recurrenceString)\n"

        
        // Write CSV to file
        do {
            try csvText.write(to: filePath, atomically: true, encoding: .utf8)
            return filePath
        } catch {
            print("Failed to create CSV: \(error)")
            return nil
        }
    }
    
    // Share CSV using UIActivityViewController
    static func shareCSV(from viewController: UIViewController, donation: Donation) {
        if let fileURL = createDonationCSV(donation: donation) {
            let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = viewController.view
                popover.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            viewController.present(activityVC, animated: true)
        }
    }
}

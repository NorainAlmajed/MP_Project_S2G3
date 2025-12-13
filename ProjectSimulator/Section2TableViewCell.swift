//
//  Section2TableViewCell.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 12/12/2025.
//

import UIKit

class Section2TableViewCell: UITableViewCell {

    @IBOutlet weak var donorLbl: UILabel!
    
    @IBOutlet weak var donationAddressLbl: UILabel!
    
    @IBOutlet weak var governorateLbl: UILabel!
    
    @IBOutlet weak var pickupDatelbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Disable selection
            self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Updated setup method
        func setup(with donation: Donation) {
            // Donor
            donorLbl.text = donation.donor
            
            // Address
            let addressText = """
            Building \(donation.address.building), Flat \(donation.address.flat)
            Road \(donation.address.road), Block \(donation.address.block)
            Area: \(donation.address.area)
            """
            donationAddressLbl.text = addressText
            applyLineSpacing()
            
            // Governorate
            governorateLbl.text = "\(donation.address.area), \(donation.address.governorate) Governorate"
            
            // Pickup date and time
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let pickupDateString = formatter.string(from: donation.pickupDate)
            pickupDatelbl.text = "Date: \(pickupDateString), \(donation.pickupTime)"
        }

        private func applyLineSpacing() {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6

            let attributedString = NSMutableAttributedString(
                string: donationAddressLbl.text ?? ""
            )

            attributedString.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: NSRange(location: 0, length: attributedString.length)
            )

            donationAddressLbl.attributedText = attributedString
        }

}

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
    
    @IBOutlet weak var recurrenceLbl: UILabel!
    
    @IBOutlet weak var locationImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Disable selection
            self.selectionStyle = .none
        
        // Set location image based on current mode
            updateLocationImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with donation: Donation) {
        donorLbl.text = donation.donor.username
        
        //  Setting the format of the address
        var addressParts: [String] = []

        addressParts.append("Building \(donation.address.building)")

        if let flat = donation.address.flat {
            addressParts.append("Flat \(flat)")
        }

        addressParts.append("Road \(donation.address.road)")
        addressParts.append("Block \(donation.address.block)")

        let address = addressParts.joined(separator: ", ")
        
        //Update address
        donationAddressLbl.text = address
        applyLineSpacing()
        
        //Update the city and governorate
        governorateLbl.text = "\(donation.address.area), \(donation.address.governorate) Governorate"
        
        //Update date
        // Convert Timestamp to Date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        pickupDatelbl.text = "\(formatter.string(from: donation.pickupDate.dateValue())), \(donation.pickupTime)"
        
        // Set recurrence label based on integer value
        switch donation.recurrence {
            case 1:
                recurrenceLbl.text = "Recurrence: Repeated Daily"
            case 2:
                recurrenceLbl.text = "Recurrence: Repeated Weekly"
            case 3:
                recurrenceLbl.text = "Recurrence: Repeated Monthly"
            case 4:
                recurrenceLbl.text = "Recurrence: Repeated Yearly"
            default:
                recurrenceLbl.text = "" // 0 or any other value
        }
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
    
    private func updateLocationImage() {
        if traitCollection.userInterfaceStyle == .dark {
            locationImageView.image = UIImage(named: "location2")
        } else {
            locationImageView.image = UIImage(named: "Location")
        }
    }


    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Only update if the interface style actually changed
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            updateLocationImage()
        }
    }

    
}

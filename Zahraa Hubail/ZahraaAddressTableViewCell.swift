//
//  ZahraaAddressTableViewCell.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 27/12/2025.
//

import UIKit

class ZahraaAddressTableViewCell: UITableViewCell {

    
    @IBOutlet weak var addressBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addressBtn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            addressBtn.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func configure(with donation: Donation) {
        
        // 1️⃣ Border like text fields
        addressBtn.layer.borderWidth = 1
        addressBtn.layer.borderColor = UIColor.systemGray4.cgColor
        addressBtn.layer.cornerRadius = 8
        addressBtn.clipsToBounds = true
        
        // ✅ Set text color to black
          addressBtn.setTitleColor(.black, for: .normal)
        
        let address = donation.address
        var addressParts: [String] = []
        
        // Building
        addressParts.append("Building \(address.building)")
        
        // Optional: only show Flat on iPad or if present
        if let flat = address.flat {
            addressParts.append("Flat \(flat)")
        }
        
        // Road & Block
        addressParts.append("Road \(address.road)")
        addressParts.append("Block \(address.block)")
        
        // Area & Governorate
        addressParts.append(address.area)
        addressParts.append("\(address.governorate) Governorate")
        
        var fullAddress = addressParts.joined(separator: ", ")
        
        // ✅ Adjust for device type
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone: shorten the string
            fullAddress = "Building \(address.building), Road \(address.road), Block \(address.block) ..."
        }
        
        addressBtn.setTitle(fullAddress, for: .normal)
        
        // Force single line and truncation
        addressBtn.titleLabel?.lineBreakMode = .byTruncatingTail
        addressBtn.titleLabel?.numberOfLines = 1
        addressBtn.titleLabel?.adjustsFontSizeToFitWidth = false
        addressBtn.titleLabel?.baselineAdjustment = .alignCenters
        addressBtn.contentHorizontalAlignment = .left
        addressBtn.titleLabel?.semanticContentAttribute = .forceLeftToRight
    }




    
    @IBAction func addressBtn(_ sender: Any) {
        print("Address button tapped")
    }
}

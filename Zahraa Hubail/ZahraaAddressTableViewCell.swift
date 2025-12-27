//
//  ZahraaAddressTableViewCell.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 27/12/2025.
//

import UIKit

protocol ZahraaAddressTableViewCellDelegate: AnyObject {
    func didTapAddressButton()
}


class ZahraaAddressTableViewCell: UITableViewCell {

    weak var delegate: ZahraaAddressTableViewCellDelegate?

    
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
        // Full address
        let address = donation.address
        var addressParts: [String] = []
        addressParts.append("Building \(address.building)")
        if let flat = address.flat { addressParts.append("Flat \(flat)") }
        addressParts.append("Road \(address.road)")
        addressParts.append("Block \(address.block)")
        addressParts.append(address.area)
        addressParts.append("\(address.governorate) Governorate")

        var fullAddress = addressParts.joined(separator: ", ")
        if UIDevice.current.userInterfaceIdiom == .phone {
            fullAddress = "Building \(address.building), Road \(address.road), Block \(address.block) ..."
        }

        // ✅ Use UIButton.Configuration for background & text color
        var config = UIButton.Configuration.filled()
        config.title = fullAddress
        config.titleAlignment = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12)
        
        // Dynamic colors for light/dark mode
        config.baseBackgroundColor = UIColor { trait in
            return trait.userInterfaceStyle == .dark ? .black : .white
        }
        config.baseForegroundColor = UIColor { trait in
            return trait.userInterfaceStyle == .dark ? .white : .black
        }
        
        // Border
        config.background.strokeWidth = 0.5
        config.background.strokeColor = UIColor { trait in
            return trait.userInterfaceStyle == .dark ? UIColor.white.withAlphaComponent(0.3) : UIColor.systemGray4
        }
        config.background.cornerRadius = 8

        
        // Apply configuration
        addressBtn.configuration = config
        addressBtn.contentHorizontalAlignment = .leading
        addressBtn.adjustsImageWhenHighlighted = false // prevents text dimming
    }


    
    @IBAction func addressBtn(_ sender: Any) {
        delegate?.didTapAddressButton()
    }

}

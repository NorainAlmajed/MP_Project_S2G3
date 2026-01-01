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
    
    func configure(with address: ZahraaAddress) {
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

        var config = UIButton.Configuration.filled()
        config.title = fullAddress
        config.titleAlignment = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12)
        config.baseBackgroundColor = UIColor { $0.userInterfaceStyle == .dark ? .black : .white }
        config.baseForegroundColor = UIColor { $0.userInterfaceStyle == .dark ? .white : .black }
        config.background.strokeWidth = 1
        config.background.strokeColor = UIColor.systemGray4
        config.background.cornerRadius = 8
        
        addressBtn.configuration = config
    }



    
    @IBAction func addressBtn(_ sender: Any) {
        delegate?.didTapAddressButton()
    }

}

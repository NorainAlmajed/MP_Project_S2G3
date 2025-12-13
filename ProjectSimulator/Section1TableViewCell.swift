//
//  DonationDetailsTableViewCell.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 12/12/2025.
//

import UIKit

class Section1TableViewCell: UITableViewCell {

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

}

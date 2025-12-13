//
//  DonationDetailsTableViewCell.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 12/12/2025.
//

import UIKit

class Section1TableViewCell: UITableViewCell {

    @IBOutlet weak var ngoNameLbl: UILabel!
    
    @IBOutlet weak var donationIDLbl: UILabel!
    
    @IBOutlet weak var creationDateLbl: UILabel!
    
    
    @IBOutlet weak var NgoLogoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Disable selection
            self.selectionStyle = .none
        
        // Make NGO logo rounded
        NgoLogoImageView.layer.cornerRadius = 7.24
        NgoLogoImageView.clipsToBounds = true
        
        // Make image fill the view
            NgoLogoImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with donation: Donation) {
           ngoNameLbl.text = donation.ngo
           donationIDLbl.text = "Donation #\(donation.donationID)"
           
        // Format and display date as "23/10/2025, 9:08 AM"
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy, h:mm a"
            creationDateLbl.text = formatter.string(from: donation.creationDate)
           
           NgoLogoImageView.image = donation.foodImage // or your NGO logo if you have it
       }

}

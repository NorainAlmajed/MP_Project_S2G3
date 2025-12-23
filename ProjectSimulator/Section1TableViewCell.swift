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

        

        // MARK: - Lifecycle
        
        override func awakeFromNib() {
            super.awakeFromNib()

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
        }
        

        // MARK: - Configure Cell
        
        func setup(with donation: Donation) {

            // NGO name
            ngoNameLbl.text = donation.ngo.fullName ?? donation.ngo.username

            // Donation ID (YOUR numeric ID – untouched)
            donationIDLbl.text = "Donation #\(donation.donationID)"

            // Format and display creation date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy, h:mm a"
            creationDateLbl.text = formatter.string(
                from: donation.creationDate.dateValue()
            )

            // Load NGO logo from URL
            if let logoURL = donation.ngo.profile_image_url, !logoURL.isEmpty {
                NgoLogoImageView.loadImage(
                    from: logoURL,
                    placeholder: UIImage(named: "defaultLogo")
                )
            } else {
                NgoLogoImageView.image = UIImage(named: "defaultLogo")
            }
        }
    }

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
        
        // Existing setup
        self.selectionStyle = .none
        NgoLogoImageView.layer.cornerRadius = 7.24
        NgoLogoImageView.clipsToBounds = true

        // Only adjust layout for iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Disable autoresizing mask constraints
            NgoLogoImageView.translatesAutoresizingMaskIntoConstraints = false
            ngoNameLbl.translatesAutoresizingMaskIntoConstraints = false
            donationIDLbl.translatesAutoresizingMaskIntoConstraints = false
            creationDateLbl.translatesAutoresizingMaskIntoConstraints = false

            // Remove existing constraints if any
            NSLayoutConstraint.deactivate(NgoLogoImageView.constraints)
            NSLayoutConstraint.deactivate(ngoNameLbl.constraints)
            NSLayoutConstraint.deactivate(donationIDLbl.constraints)
            NSLayoutConstraint.deactivate(creationDateLbl.constraints)

            // NGO Logo Constraints
            NSLayoutConstraint.activate([
                NgoLogoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 245),
                NgoLogoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                NgoLogoImageView.widthAnchor.constraint(equalToConstant: NgoLogoImageView.frame.width),
                NgoLogoImageView.heightAnchor.constraint(equalToConstant: NgoLogoImageView.frame.height)
            ])

            // Labels Constraints
            NSLayoutConstraint.activate([
                ngoNameLbl.leadingAnchor.constraint(equalTo: NgoLogoImageView.trailingAnchor, constant: 9),
                ngoNameLbl.topAnchor.constraint(equalTo: NgoLogoImageView.topAnchor),

                donationIDLbl.leadingAnchor.constraint(equalTo: NgoLogoImageView.trailingAnchor, constant: 9),
                donationIDLbl.topAnchor.constraint(equalTo: ngoNameLbl.bottomAnchor, constant: 6),

                creationDateLbl.leadingAnchor.constraint(equalTo: NgoLogoImageView.trailingAnchor, constant: 9),
                creationDateLbl.topAnchor.constraint(equalTo: donationIDLbl.bottomAnchor, constant: 6)
            ])
        }
    }


        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
        

        // MARK: - Configure Cell
        
    func setup(with donation: ZahraaDonation) {
        // NGO name
        ngoNameLbl.text = donation.ngo.organization_name ?? donation.ngo.username

        // Donation ID
        donationIDLbl.text = "Donation #\(donation.donationID)"

        // Creation date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, h:mm a"
        creationDateLbl.text = formatter.string(from: donation.creationDate.dateValue())

        // Placeholder image
        let placeholder = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
        NgoLogoImageView.tintColor = .systemGray3

        // Show placeholder immediately
        NgoLogoImageView.image = placeholder

        // Load logo asynchronously
        if let logoURL = donation.ngo.profile_image_url, !logoURL.isEmpty {
            NgoLogoImageView.loadImage(from: logoURL, placeholder: placeholder)
        }
    }

    
    
    }

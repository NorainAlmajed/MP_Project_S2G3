//
//  DonationCollectionViewCell.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 29/11/2025.
//

import UIKit

class DonationCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var donationLogoImageView: UIImageView!
    
    @IBOutlet weak var donationCategoryLbl: UILabel!
    
    @IBOutlet weak var donationIDLbl: UILabel!
    
    @IBOutlet weak var donorNgoLbl: UILabel!
    
    @IBOutlet weak var donationDateLbl: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var donationStatusView: UIView!
    
    @IBOutlet weak var statusColorView: UIView!
    
    @IBOutlet weak var donationStatusLbl: UILabel!
    
    
    
    // MARK: - Configure Cell With Donation Data
    func setup(with donation: ZahraaDonation, currentUser: ZahraaUser) {


        // Set container color
            if traitCollection.userInterfaceStyle == .dark {
                containerView.backgroundColor = UIColor(named: "BeigeCol")?.withAlphaComponent(0.9) // Slightly darker for dark mode
            } else {
                containerView.backgroundColor = UIColor(named: "BeigeCol")
            }
        

        // Make the logo circular
        donationLogoImageView.layer.cornerRadius = donationLogoImageView.frame.height / 2
        donationLogoImageView.clipsToBounds = true

        // Other labels (no change)
        donationCategoryLbl.text = donation.category
        donationIDLbl.text = "Donation #\(donation.donationID)"

        if currentUser.role == 2 {
            donorNgoLbl.text = "NGO: " + (donation.ngo.organization_name ?? donation.ngo.username)
        } else {
            donorNgoLbl.text = "Donor: " + (donation.donor.fullName ?? donation.donor.username)
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, h:mm a"
        donationDateLbl.text = formatter.string(from: donation.creationDate.dateValue())

        // Status
        switch donation.status {
        case 1:
            statusColorView.backgroundColor = UIColor(named: "orangeCol")
            donationStatusLbl.text = "Pending"
        case 2:
            statusColorView.backgroundColor = UIColor(named: "greenCol")
            donationStatusLbl.text = "Accepted"
        case 3:
            statusColorView.backgroundColor = UIColor(named: "blueCol")
            donationStatusLbl.text = "Collected"
        case 4:
            statusColorView.backgroundColor = UIColor(named: "redCol")
            donationStatusLbl.text = "Rejected"
        case 5:
            statusColorView.backgroundColor = UIColor(named: "greyCol")
            donationStatusLbl.text = "Cancelled"
        default:
            statusColorView.backgroundColor = .lightGray
            donationStatusLbl.text = "Unknown"
        }
        
        
        // Text Color for Dark Mode
        donationCategoryLbl.textColor = .black
        donationIDLbl.textColor = .black
        donorNgoLbl.textColor = .black
        donationDateLbl.textColor = .black

        
        // Force donationStatusView background to white, same in light and dark mode
        donationStatusView.backgroundColor = .white

        
        // Make the status label black
        donationStatusLbl.textColor = .black
    }


    
    // MARK: - UI Setup
    
    private func setupUI() {
        // Rounded card-style container
        containerView.layer.cornerRadius = 20 
        containerView.layer.masksToBounds = true
    }
    
    // Called whenever the layout updates (correct place to apply rounded corners)
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Round the container view
        containerView.layer.cornerRadius = 20
        
        // Slightly rounded corners
        donationStatusView.layoutIfNeeded()
        donationStatusView.layer.cornerRadius = donationStatusView.frame.height / 2
        donationStatusView.clipsToBounds = true
    }
    
    // Called when cell is loaded from the storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Make the small status color circle rounded
        statusColorView?.layer.cornerRadius = (statusColorView?.frame.height ?? 0) / 2
        statusColorView?.clipsToBounds = true

    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Update container color dynamically when dark/light mode changes
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            containerView.backgroundColor = UIColor(named: "BeigeCol")
        }
    }

    
}

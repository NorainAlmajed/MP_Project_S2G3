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
    func setup(with donation: Donation)
    {
        // Set logo + make it circular
        donationLogoImageView.image = UIImage(named: "basket") ?? UIImage()
        donationLogoImageView.layer.cornerRadius = donationLogoImageView.frame.height / 2
        donationLogoImageView.clipsToBounds = true
        
        // Set text labels
        donationCategoryLbl.text = donation.Category
        donationIDLbl.text = "Donation #" + String(donation.donationID)
        if user.userType == 2 {
            donorNgoLbl.text = "NGO: " + donation.ngo.fullName
        } else {
            donorNgoLbl.text = "Donor: " + donation.donor.username
        }
        
        
        // Format and display date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, h:mm a"
        donationDateLbl.text = formatter.string(from: donation.creationDate)
        
        //Setting the color of the status name and color
        if donation.status == 1 {
            statusColorView.backgroundColor = UIColor(named: "orangeCol")
            donationStatusLbl.text = "Pending"
        }
        else if donation.status == 2 {
            statusColorView.backgroundColor = UIColor(named: "greenCol")
            donationStatusLbl.text = "Accepted"
        }
        else if donation.status == 3 {
            statusColorView.backgroundColor = UIColor(named: "blueCol")
            donationStatusLbl.text = "Collected"
        }
        else if donation.status == 4 {
            statusColorView.backgroundColor = UIColor(named: "redCol")
            donationStatusLbl.text = "Rejected"
        }
        else if donation.status == 5 {
            statusColorView.backgroundColor = UIColor(named: "greyCol")
            donationStatusLbl.text = "Cancelled"
        }
    }
    
    
    // MARK: - UI Setup
    
    private func setupUI() {
        // Rounded card-style container
        containerView.layer.cornerRadius = 20   // ← adjust this value
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
    
    // Called when cell is loaded from the nib/storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Make the small status color circle rounded
        statusColorView?.layer.cornerRadius = (statusColorView?.frame.height ?? 0) / 2
        statusColorView?.clipsToBounds = true

    }
    
//    //Checking the category name 
//    private func categoryName(for category: Int) -> String {
//        switch category {
//        case 1: return "Bakery"
//        case 2: return "Dairy"
//        case 3: return "Produce"
//        case 4: return "Poultry"
//        case 5: return "Beverages"
//        case 6: return "Canned Food"
//        case 7: return "Others"
//        default: return "Unknown"
//        }
//    }

    
}

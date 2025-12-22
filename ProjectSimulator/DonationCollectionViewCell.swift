//
//  DonationCollectionViewCell.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 29/11/2025.
//

import UIKit

class DonationCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var donationLogoImageView: UIImageView!
    
    @IBOutlet weak var donationCategoryLbl: UILabel!
    
    @IBOutlet weak var donationIDLbl: UILabel!
    
    @IBOutlet weak var donorNgoLbl: UILabel!
    
    @IBOutlet weak var donationDateLbl: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var donationStatusView: UIView!
    
    @IBOutlet weak var statusColorView: UIView!
    
    @IBOutlet weak var donationStatusLbl: UILabel!
    
    
    func setup(with donation: Donation)
    {
        donationLogoImageView.image = UIImage(named: "basket") ?? UIImage()
        donationLogoImageView.layer.cornerRadius = donationLogoImageView.frame.height / 2
        donationLogoImageView.clipsToBounds = true
        
        donationCategoryLbl.text = donation.Category
        donationIDLbl.text = "Donation #" + String(donation.donationID)
        donorNgoLbl.text = "Donor: " + donation.donor
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
    
    
    
    
    private func setupUI() {
        containerView.layer.cornerRadius = 20   // ← adjust this value
        containerView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 20
        
        // Slightly rounded corners
        donationStatusView.layoutIfNeeded()
        donationStatusView.layer.cornerRadius = donationStatusView.frame.height / 2
        donationStatusView.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Make it circular
        statusColorView?.layer.cornerRadius = (statusColorView?.frame.height ?? 0) / 2
        statusColorView?.clipsToBounds = true

    }
    
}

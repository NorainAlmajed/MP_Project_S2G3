//
//  Section3TableViewCell.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 12/12/2025.
//

import UIKit

class Section3TableViewCell: UITableViewCell {

    @IBOutlet weak var foodImageView: UIImageView!
    
    @IBOutlet weak var donationStatusView: UIView!
    
    @IBOutlet weak var statusColorView: UIView!
    
    @IBOutlet weak var donationStatusLbl: UILabel!
    
    @IBOutlet weak var quantityLbl: UILabel!
    
    @IBOutlet weak var categoryLbl: UILabel!
    
    @IBOutlet weak var weightLbl: UILabel!
    
    @IBOutlet weak var expirationDateLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var rejectionReasonLbl: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var rejectBtn: UIButton!
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBOutlet weak var collectedBtn: UIButton!
    
    @IBOutlet weak var cancelSectionView: UIView!
    
    @IBOutlet weak var rejectSectionView: UIView!
    
    @IBOutlet weak var editSectionView: UIView!
    
    @IBOutlet weak var acceptSectionView: UIView!
    
    @IBOutlet weak var collectedSectionView: UIView!
    
    @IBOutlet weak var weightSectionView: UIView!
    
    @IBOutlet weak var descSectionView: UIView!
    
    @IBOutlet weak var rejectionSectionView: UIView!
    
    @IBOutlet weak var foodImageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var foodImageWidthConstraint: NSLayoutConstraint!

    
    // Closure to notify the VC when buttons are tapped
        var onCancelTapped: (() -> Void)?
        var onAcceptTapped: (() -> Void)?
        var onCollectedTapped: (() -> Void)?
        var onRejectTapped: (() -> Void)?


    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()


    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        // Disable selection
            self.selectionStyle = .none
        
        
        // Round the small status color view
        statusColorView.layer.cornerRadius = (statusColorView.frame.height) / 2
        statusColorView.clipsToBounds = true
        
        // Round the food image view
           foodImageView.layer.cornerRadius = 7.24
           foodImageView.clipsToBounds = true
        
        // Add target to the button
            cancelBtn.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
            acceptBtn.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
            collectedBtn.addTarget(self, action: #selector(collectedButtonTapped), for: .touchUpInside)
            rejectBtn.addTarget(self, action: #selector(rejectButtonTapped), for: .touchUpInside)
        
        // Round buttons
            styleActionButton(cancelBtn)
            styleActionButton(rejectBtn)
            styleActionButton(editBtn)
            styleActionButton(acceptBtn)
            styleActionButton(collectedBtn)

        //Add iPad resizing logic.
        adjustImageSizeForDevice()
        
    }
    
    
    
    
    
    //Selectors for the buttons
    @objc private func cancelButtonTapped() {
            onCancelTapped?()
        }
    
    @objc private func acceptButtonTapped() {
        onAcceptTapped?()
    }
    
    @objc private func collectedButtonTapped() {
        onCollectedTapped?()
    }
    
    @objc private func rejectButtonTapped() {
        onRejectTapped?()
    }

    
    //Add iPad resizing logic
    private func adjustImageSizeForDevice() {
//        let isPad = UIDevice.current.userInterfaceIdiom == .pad
//
//        if isPad {
//            // Bigger image on iPad
//            foodImageHeightConstraint.constant = 288
//            foodImageWidthConstraint.constant = 456
//        }
        // iPhone → keep storyboard size
    }

    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        // Disable selection
                self.selectionStyle = .none
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        donationStatusView.layer.cornerRadius = donationStatusView.frame.height / 2
        donationStatusView.clipsToBounds = true

        statusColorView.layer.cornerRadius = statusColorView.frame.height / 2
        statusColorView.clipsToBounds = true

        // Buttons
        styleActionButton(cancelBtn)
        styleActionButton(rejectBtn)
        styleActionButton(editBtn)
        styleActionButton(acceptBtn)
        styleActionButton(collectedBtn)
    }

    

}




extension Section3TableViewCell {

    func setup(with donation: Donation, currentUser: User) {
        
        // Reset buttons visibility first
        hideAllActionSections()
        
        // Reset other sections visibility
        weightSectionView.isHidden = false
        descSectionView.isHidden = false
        rejectionSectionView.isHidden = false
        
        //Set variables for the donation status and user role
        let role = currentUser.role
        let status = donation.status
        
        // Admin + Pending
        if role == 1 && status == 1 {
            cancelSectionView.isHidden = false
            rejectSectionView.isHidden = false
            editSectionView.isHidden = false
            acceptSectionView.isHidden = false
        }
        // Donor + Pending
        else if role == 2 && status == 1 {
            cancelSectionView.isHidden = false
        }
        // NGO + Pending
        else if role == 3 && status == 1 {
            rejectSectionView.isHidden = false
            acceptSectionView.isHidden = false
        }
        // Admin + Accepted
        else if role == 1 && status == 2 {
            cancelSectionView.isHidden = false
            collectedSectionView.isHidden = false
        }
        // NGO + Accepted
        else if role == 3 && status == 2 {
            collectedSectionView.isHidden = false
        }

        // Update the food image
        foodImageView.loadImage(from: donation.foodImageUrl)

        // Update quantity, category, weight, expiration date
        quantityLbl.text = "\(donation.quantity)"
        categoryLbl.text = donation.category
        
        // Update weight
        if let weight = donation.weight {
            weightLbl.text = "\(weight) kg"
            weightSectionView.isHidden = false
        } else {
            weightSectionView.isHidden = true
        }

        // Format expiration date
        let expiryDate: Date = donation.expiryDate.dateValue()
        expirationDateLbl.text = formatter.string(from: expiryDate)


        // Update description
        if let description = donation.description, !description.trimmingCharacters(in: .whitespaces).isEmpty {
            descriptionLbl.text = description
            descSectionView.isHidden = false
        } else {
            descSectionView.isHidden = true
        }

        // Update rejection reason
        if status == 4, let rejectionReason = donation.rejectionReason, !rejectionReason.trimmingCharacters(in: .whitespaces).isEmpty {
            rejectionReasonLbl.text = rejectionReason
            rejectionSectionView.isHidden = false
        } else {
            rejectionSectionView.isHidden = true
        }

        // Update donation status text and color
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
            statusColorView.backgroundColor = UIColor.clear
            donationStatusLbl.text = "Unknown"
        }
    }

    
    private func hideAllActionSections() {
        cancelSectionView.isHidden = true
        rejectSectionView.isHidden = true
        editSectionView.isHidden = true
        acceptSectionView.isHidden = true
        collectedSectionView.isHidden = true
    }
    
    //Method to check the category name
    private func categoryName(for category: Int) -> String {
        switch category {
        case 1: return "Bakery"
        case 2: return "Dairy"
        case 3: return "Produce"
        case 4: return "Poultry"
        case 5: return "Beverages"
        case 6: return "Canned Food"
        case 7: return "Others"
        default: return "Unknown"
        }
    }
    
    //For buttons radius
    private func styleActionButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
    }


}

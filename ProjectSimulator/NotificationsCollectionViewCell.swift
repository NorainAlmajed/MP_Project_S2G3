//
//  DonationCollectionViewCell.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 29/11/2025.
//

import UIKit

class NotificationsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var notificationLogoImageView: UIImageView!
    
    @IBOutlet weak var notificationTitleLbl: UILabel!
    
    @IBOutlet weak var notificationDescriptionLbl: UILabel!
    
    @IBOutlet weak var notificationDateLbl: UILabel!
    
    @IBOutlet weak var containerView: UIView!
            
    
    
    
    // MARK: - Configure Cell With Donation Data
    func setup(with notification: Notification)
    {
        // Make logo circular
        notificationLogoImageView.layer.cornerRadius = notificationLogoImageView.frame.height / 2
        notificationLogoImageView.clipsToBounds = true
        
        // Set text labels
        notificationTitleLbl.text = notification.title
        notificationDescriptionLbl.text = notification.description
        
        // Format and display date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, h:mm a"
        notificationDateLbl.text = formatter.string(from: notification.date)
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
        
    }
    
    // Called when cell is loaded from the nib/storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
}

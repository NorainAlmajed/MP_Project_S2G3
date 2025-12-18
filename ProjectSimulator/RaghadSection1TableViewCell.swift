//
//  RaghadSection1TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 13/12/2025.
//

import UIKit


// ✅ 1) Delegate protocol: the cell tells the ViewController "Upload tapped"
protocol RaghadSection1TableViewCellDelegate: AnyObject {
    func section1DidTapUploadImage(_ cell: RaghadSection1TableViewCell)
}


class RaghadSection1TableViewCell: UITableViewCell {

    @IBOutlet weak var Donation_ImageView: UIImageView!
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblImageError: UILabel!

    
    
//    // ✅ 2) Add delegate variable
     weak var delegate: RaghadSection1TableViewCellDelegate?
 override func awakeFromNib() {
            super.awakeFromNib()

        
        lblImageError.isHidden = true
          lblImageError.text = "Please upload an image"

          Donation_ImageView.contentMode = .scaleAspectFit
          Donation_ImageView.clipsToBounds = true
          Donation_ImageView.layer.cornerRadius = 10
          Donation_ImageView.layer.borderWidth = 1
          Donation_ImageView.layer.borderColor = UIColor.systemGray4.cgColor
          Donation_ImageView.backgroundColor = UIColor.systemGray6
        
        applyBigPlaceholderIcon() // 🟢 NEW: bigger logo
        Donation_ImageView.image = UIImage(systemName: "photo")
        Donation_ImageView.tintColor = .systemGray3


          // ✅ iPad only: make the image view bigger
          adjustImageSizeForDevice()
      }

    
    @IBAction func btnUploadImage(_ sender: Any) {
        // ✅ 3) Tell the VC to open camera/library options
            delegate?.section1DidTapUploadImage(self)
        
    }
 
    func setDonationImage(_ image: UIImage?) {
            if let image = image {
                Donation_ImageView.image = image
                Donation_ImageView.contentMode = .scaleAspectFit
                Donation_ImageView.tintColor = nil
       
                
            } else {
                applyBigPlaceholderIcon() // 🟢 NEW: bigger logo
                Donation_ImageView.image = UIImage(systemName: "photo")
                Donation_ImageView.tintColor = .systemGray3
                Donation_ImageView.contentMode = .center
            }
        }

        func configure(showError: Bool) {
            lblImageError.isHidden = !showError
        }

    
    private func adjustImageSizeForDevice() {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad

        if isPad {
            // ✅ Bigger on iPad
            imgHeightConstraint.constant = 170
            imgWidthConstraint.constant = 420
        } else {
            // ✅ iPhone: keep storyboard sizes (do nothing)
        }
    }
    
    // 🟢 NEW: makes the placeholder icon (logo) bigger
    private func applyBigPlaceholderIcon() {
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .regular) // 🔧 change 60 -> 70 if you want bigger
        Donation_ImageView.preferredSymbolConfiguration = config
    }
    
    
    }

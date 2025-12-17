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
    
    
    
    @IBOutlet weak var lblImageError: UILabel!

    
    
//    // ✅ 2) Add delegate variable
     weak var delegate: RaghadSection1TableViewCellDelegate?
//
//    
//    
//    
//        override func awakeFromNib() {
//              super.awakeFromNib()
//
//              // ✅ UI polish only (safe)
//
//            
//            lblImageError.isHidden = true
//            lblImageError.text = "Please upload an image"
//            Donation_ImageView.contentMode = .scaleAspectFit
//            Donation_ImageView.clipsToBounds = true
//            Donation_ImageView.layer.cornerRadius = 10
//            Donation_ImageView.layer.borderWidth = 1
//            Donation_ImageView.layer.borderColor = UIColor.systemGray4.cgColor
//            Donation_ImageView.backgroundColor = UIColor.systemGray6
//
//            Donation_ImageView.image = UIImage(systemName: "photo")
//            Donation_ImageView.tintColor = .systemGray3
//        }
//  
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//        
//        
//        
//        
//    }
    
    
    
    
    
    
    
    
    
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

            Donation_ImageView.image = UIImage(systemName: "photo")
            Donation_ImageView.tintColor = .systemGray3
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
                Donation_ImageView.image = UIImage(systemName: "photo")
                Donation_ImageView.tintColor = .systemGray3
                Donation_ImageView.contentMode = .center
            }
        }

        func configure(showError: Bool) {
            lblImageError.isHidden = !showError
        }
    }
    
    
    
    
//    // ✅ helper to show image (NO resizing here)
//    func setDonationImage(_ image: UIImage?) {
//        if let image = image {
//            Donation_ImageView.image = image
//            Donation_ImageView.contentMode = .scaleAspectFit
//            Donation_ImageView.tintColor = nil
//        } else {
//            Donation_ImageView.image = UIImage(systemName: "photo")
//            Donation_ImageView.tintColor = .systemGray3
//            Donation_ImageView.contentMode = .center
//        }
//    }
//    
//    
//    // ✅ NEW: show / hide image error (same pattern as Choose Donor)
//    func configure(showError: Bool) {
//        lblImageError.isHidden = !showError
//    }
//
//    
//
//
//}

//
//  RaghadNgoDetailsMissionTableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 17/12/2025.
//

import UIKit

class RaghadNgoDetailsMissionTableViewCell: UITableViewCell {

    @IBOutlet weak var misssionView: UIView!
    @IBOutlet weak var lblMissionText: UILabel!
    
    @IBOutlet weak var misionTitleLbl: UILabel!
    

    override func awakeFromNib() {
            super.awakeFromNib()

            //  White background
            //misssionView.backgroundColor = .secondarySystemBackground
        
        
        //  Light = white | Dark = system background
        misssionView.backgroundColor = UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor.secondarySystemBackground
                : UIColor.white
        }

            //  Light gray border
            misssionView.layer.cornerRadius = 16
            misssionView.layer.borderWidth = 1
            misssionView.layer.borderColor = UIColor.separator.cgColor
            misssionView.clipsToBounds = true

        //  Text: dark-mode friendly
             lblMissionText.numberOfLines = 0
             lblMissionText.textColor = .label
         
        }
    
    
    //  Important: refresh border when switching Light/Dark
       override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
           super.traitCollectionDidChange(previousTraitCollection)

           if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
               misssionView.layer.borderColor = UIColor.separator.cgColor
           }
       }
    

        func configure(mission: String) {
            lblMissionText.text = mission
        }
    }

 

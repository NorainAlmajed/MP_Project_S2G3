//
//  RaghadNgoDetailsContactTableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 17/12/2025.
//

import UIKit

class RaghadNgoDetailsContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var lblPgoneNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var btnEmail: UIButton!

    @IBOutlet weak var lblContact: UILabel!
    
    



    override func awakeFromNib() {
            super.awakeFromNib()

            //  Make cell background clear
            backgroundColor = .clear
            contentView.backgroundColor = .clear

            //  Light = white | Dark = system background (SAME as Mission cell)
            contactView.backgroundColor = UIColor { trait in
                trait.userInterfaceStyle == .dark
                    ? UIColor.secondarySystemBackground
                    : UIColor.white
            }

            //  Card styling
            contactView.layer.cornerRadius = 16
            contactView.layer.borderWidth = 1
            contactView.layer.borderColor = UIColor.separator.cgColor
            contactView.clipsToBounds = true

            //  Text always visible
            lblPgoneNumber.textColor = .label
            lblEmail.textColor = .label
        }

        //  Update border color when switching Light/Dark
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)

            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                contactView.layer.borderColor = UIColor.separator.cgColor
            }
        }

        func configure(phone: String, email: String) {
            lblPgoneNumber.text = phone
            lblEmail.text = email
        }
    }

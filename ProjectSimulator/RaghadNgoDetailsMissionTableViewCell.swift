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

    override func awakeFromNib() {
            super.awakeFromNib()

            // ✅ White background
            misssionView.backgroundColor = .white

            // ✅ Light gray border
            misssionView.layer.cornerRadius = 16
            misssionView.layer.borderWidth = 1
            misssionView.layer.borderColor = UIColor.systemGray4.cgColor
            misssionView.clipsToBounds = true

            // ✅ Dynamic text
            lblMissionText.numberOfLines = 0
        }

        func configure(mission: String) {
            lblMissionText.text = mission
        }
    }

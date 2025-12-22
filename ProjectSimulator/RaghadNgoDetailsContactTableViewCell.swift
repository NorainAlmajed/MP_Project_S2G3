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

    override func awakeFromNib() {
        super.awakeFromNib()

        // ✅ Make cell background clear
               backgroundColor = .clear
               contentView.backgroundColor = .clear

               // ✅ White card background
               contactView.backgroundColor = .white

               // ✅ Light gray border
               contactView.layer.cornerRadius = 16
               contactView.layer.borderWidth = 1
               contactView.layer.borderColor = UIColor.systemGray4.cgColor
               contactView.clipsToBounds = true
           }

           func configure(phone: Int, email: String) {
               lblPgoneNumber.text = "\(phone)"
               lblEmail.text = email
           }
       }

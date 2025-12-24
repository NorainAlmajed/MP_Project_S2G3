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


        override func awakeFromNib() {
                super.awakeFromNib()

                // ✅ Make cell background clear
                backgroundColor = .clear
                contentView.backgroundColor = .clear

                // ✅ Light = white | Dark = system background
                contactView.backgroundColor = UIColor { trait in
                    trait.userInterfaceStyle == .dark
                        ? UIColor.secondarySystemBackground
                        : UIColor.white
                }

                // ✅ Card styling
                contactView.layer.cornerRadius = 16
                contactView.layer.borderWidth = 1
                contactView.layer.borderColor = UIColor.separator.cgColor
                contactView.clipsToBounds = true

                // ✅ Dark-mode friendly text
                lblPgoneNumber.textColor = .label
                lblEmail.textColor = .label

                // 🟢 NEW: apply EXACT SAME logic as Donate button
                applyContactIconColor(btnPhone)
                applyContactIconColor(btnEmail)
            }

            // =====================================================
            // 🟢 NEW — Light: greenCol (#126312) | Dark: systemGreen
            // =====================================================
            private func applyContactIconColor(_ button: UIButton) {

                // 🟢 NEW: same dynamic logic you used in Donate button
                let contactGreen = UIColor { trait in
                    if trait.userInterfaceStyle == .dark {
                        return UIColor.systemGreen                // 🌙 Dark Mode
                    } else {
                        return UIColor(named: "greenCol")         // ☀️ Light Mode (#126312)
                            ?? UIColor(red: 18/255, green: 99/255, blue: 18/255, alpha: 1) // 🛟 fallback = #126312
                    }
                }

                if #available(iOS 15.0, *) {
                    // 🟢 NEW: always force configuration color (prevents overrides)
                    var config = button.configuration ?? .plain()

                    // keep image + force template so tint works
                    let img = config.image ?? button.image(for: .normal)
                    config.image = img?.withRenderingMode(.alwaysTemplate)

                    // 🟢 NEW: this is what actually controls SF symbol color in iOS 15+
                    config.baseForegroundColor = contactGreen

                    button.configuration = config
                } else {
                    // iOS 14 and below
                    button.tintColor = contactGreen
                    if let img = button.image(for: .normal) {
                        button.setImage(img.withRenderingMode(.alwaysTemplate), for: .normal)
                    }
                }

                // 🟢 NEW: extra safety
                button.tintColor = contactGreen
            }
    
    
    func configure(phone: String, email: String) {
        lblPgoneNumber.text = phone
        lblEmail.text = email
    }
       }

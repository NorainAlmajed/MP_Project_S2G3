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
    

    
//    override func awakeFromNib() {
//            super.awakeFromNib()
//
//            // ✅ White background
//            //misssionView.backgroundColor = .secondarySystemBackground
//        
//        
//        // ✅ Light = white | Dark = system background
//        misssionView.backgroundColor = UIColor { trait in
//            trait.userInterfaceStyle == .dark
//                ? UIColor.secondarySystemBackground
//                : UIColor.white
//        }
//
//            // ✅ Light gray border
//            misssionView.layer.cornerRadius = 16
//            misssionView.layer.borderWidth = 1
//            misssionView.layer.borderColor = UIColor.separator.cgColor
//            misssionView.clipsToBounds = true
//
//        // ✅ Text: dark-mode friendly
//             lblMissionText.numberOfLines = 0
//             lblMissionText.textColor = .label
//         
//        }
//    
//    
//    // ✅ Important: refresh border when switching Light/Dark
//       override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//           super.traitCollectionDidChange(previousTraitCollection)
//
//           if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//               misssionView.layer.borderColor = UIColor.separator.cgColor
//           }
//       }
//    
//
//        func configure(mission: String) {
//            lblMissionText.text = mission
//        }
//    }




    //
    //  RaghadNgoDetailsMissionTableViewCell.swift
    //  ProjectSimulator
    //
    //  Created by Raghad Aleskafi on 17/12/2025.
    //

  

    //
    //  RaghadNgoDetailsMissionTableViewCell.swift
    //  ProjectSimulator
    //
    //  Created by Raghad Aleskafi on 17/12/2025.
    //

  

        // iPad-only constraints (widths only)
        private var iPadMissionWidth: NSLayoutConstraint?
        private var iPadMissionTextWidth: NSLayoutConstraint?

        // iPhone constraints (mission fills with margins + label padding)
        private var phoneMissionLeading: NSLayoutConstraint?
        private var phoneMissionTrailing: NSLayoutConstraint?
        private var phoneTextLeading: NSLayoutConstraint?
        private var phoneTextTrailing: NSLayoutConstraint?

        // Alignment constraints (title)
        private var titleLeadingToMissionLeading: NSLayoutConstraint?
        private var titleBottomToMissionTop: NSLayoutConstraint?

        // Always-on fixed height (both iPad + iPhone)
        private var missionHeightFixed: NSLayoutConstraint?

        // To avoid adding constraints twice (cells can re-awake in some cases)
        private var didSetupConstraints = false

        override func awakeFromNib() {
            super.awakeFromNib()

            // ✅ Light = white | Dark = system background
            misssionView.backgroundColor = UIColor { trait in
                trait.userInterfaceStyle == .dark ? .secondarySystemBackground : .white
            }

            // ✅ Border + corner
            misssionView.layer.cornerRadius = 16
            misssionView.layer.borderWidth = 1
            misssionView.layer.borderColor = UIColor.separator.cgColor
            misssionView.clipsToBounds = true

            // ✅ Label setup
            lblMissionText.numberOfLines = 0
            lblMissionText.textColor = .label

            setupConstraintsIfNeeded()
            applyIPadLayoutIfNeeded()
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            lblMissionText.text = nil
        }

        // ✅ Refresh border on theme change + re-apply iPad constraints (rotation/split-view)
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)

            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                misssionView.layer.borderColor = UIColor.separator.cgColor
            }

            applyIPadLayoutIfNeeded()
        }

        func configure(mission: String) {
            lblMissionText.text = mission
        }

        // MARK: - Constraints

        private func setupConstraintsIfNeeded() {
            guard !didSetupConstraints else { return }
            didSetupConstraints = true

            // Use AutoLayout
            misssionView.translatesAutoresizingMaskIntoConstraints = false
            lblMissionText.translatesAutoresizingMaskIntoConstraints = false
            misionTitleLbl.translatesAutoresizingMaskIntoConstraints = false

            // ✅ Always: center missionView + fixed height = 147 for ALL devices
            missionHeightFixed = misssionView.heightAnchor.constraint(equalToConstant: 147)
            missionHeightFixed?.isActive = true

            NSLayoutConstraint.activate([
                misssionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])

            // ✅ Title above mission with 8 spacing + same leading
            titleBottomToMissionTop = misssionView.topAnchor.constraint(equalTo: misionTitleLbl.bottomAnchor, constant: 8)
            titleBottomToMissionTop?.isActive = true

            titleLeadingToMissionLeading = misionTitleLbl.leadingAnchor.constraint(equalTo: misssionView.leadingAnchor)
            titleLeadingToMissionLeading?.isActive = true

            // ✅ iPad widths
            iPadMissionWidth = misssionView.widthAnchor.constraint(equalToConstant: 600)
            iPadMissionTextWidth = lblMissionText.widthAnchor.constraint(equalToConstant: 584)

            // ✅ iPhone mission fills with margins
            phoneMissionLeading = misssionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
            phoneMissionTrailing = misssionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)

            // ✅ iPhone text padding inside missionView
            phoneTextLeading = lblMissionText.leadingAnchor.constraint(equalTo: misssionView.leadingAnchor, constant: 16)
            phoneTextTrailing = lblMissionText.trailingAnchor.constraint(equalTo: misssionView.trailingAnchor, constant: -16)

            // ✅ Label always centered horizontally + vertical padding
            NSLayoutConstraint.activate([
                lblMissionText.centerXAnchor.constraint(equalTo: misssionView.centerXAnchor),
                lblMissionText.topAnchor.constraint(equalTo: misssionView.topAnchor, constant: 12),
                lblMissionText.bottomAnchor.constraint(equalTo: misssionView.bottomAnchor, constant: -12)
            ])
        }

        private func applyIPadLayoutIfNeeded() {
            let isIPad = traitCollection.userInterfaceIdiom == .pad

            if isIPad {
                // ✅ iPad ON
                iPadMissionWidth?.isActive = true
                iPadMissionTextWidth?.isActive = true

                // ✅ iPhone OFF
                phoneMissionLeading?.isActive = false
                phoneMissionTrailing?.isActive = false
                phoneTextLeading?.isActive = false
                phoneTextTrailing?.isActive = false

            } else {
                // ✅ iPhone ON
                phoneMissionLeading?.isActive = true
                phoneMissionTrailing?.isActive = true
                phoneTextLeading?.isActive = true
                phoneTextTrailing?.isActive = true

                // ✅ iPad OFF
                iPadMissionWidth?.isActive = false
                iPadMissionTextWidth?.isActive = false
            }

            // Update layout immediately
            contentView.layoutIfNeeded()
        }
    }

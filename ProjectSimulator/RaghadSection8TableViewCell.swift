//
//  RaghadSection8TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 14/12/2025.
//

import UIKit

class RaghadSection8TableViewCell: UITableViewCell {
    var onProceedTapped: (() -> Void)?
    
    @IBOutlet weak var btnProceedToSchedulePickup: UIButton!
    
    @IBAction func btnProceedTapped(_ sender: Any) {
        onProceedTapped?()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // SAFE: only apply radius if outlet exists
        btnProceedToSchedulePickup?.layer.cornerRadius = 20
        btnProceedToSchedulePickup?.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //
    //
    //
    //}
    //    override func awakeFromNib() {
    //           super.awakeFromNib()
    //
    //           // 🧱 Visuals
    //           btnProceedToSchedulePickup?.layer.cornerRadius = 20
    //           btnProceedToSchedulePickup?.clipsToBounds = true
    //
    //           // 🧲 Make absolutely sure the button is interactive
    //           btnProceedToSchedulePickup?.isUserInteractionEnabled = true
    //           contentView.isUserInteractionEnabled = true
    //
    //           // 🧷 If IB connection was lost, wire it in code too (safe to call even if IBAction is connected)
    //           if let btn = btnProceedToSchedulePickup {
    //               btn.removeTarget(nil, action: nil, for: .allEvents)            // clear any stale connections
    //               btn.addTarget(self, action: #selector(btnProceedTapped(_:)), for: .touchUpInside)
    //               btn.accessibilityIdentifier = "proceedButton"                  // handy for testing/UI checks
    //           }
    //
    //           // 🧭 Nicer margins on iPad
    //           contentView.preservesSuperviewLayoutMargins = true
    //
    //           // 📐 Programmatic constraints (center X, top+bottom, adaptive width)
    //           if let btn = btnProceedToSchedulePickup {
    //               btn.translatesAutoresizingMaskIntoConstraints = false
    //               let g = contentView.layoutMarginsGuide
    //               NSLayoutConstraint.activate([
    //                   btn.centerXAnchor.constraint(equalTo: g.centerXAnchor),
    //                   btn.topAnchor.constraint(equalTo: g.topAnchor, constant: 12),
    //                   btn.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -12),
    //                   btn.leadingAnchor.constraint(greaterThanOrEqualTo: g.leadingAnchor),
    //                   btn.trailingAnchor.constraint(lessThanOrEqualTo: g.trailingAnchor),
    //                   btn.heightAnchor.constraint(greaterThanOrEqualToConstant: 48)
    //               ])
    //               btn.setContentHuggingPriority(.required, for: .vertical)
    //               btn.setContentCompressionResistancePriority(.required, for: .vertical)
    //
    //               // 🥇 Make sure the button is above any background subviews
    //               contentView.bringSubviewToFront(btn)
    //           }
    //       }
    //
    //       override func setSelected(_ selected: Bool, animated: Bool) {
    //           super.setSelected(selected, animated: animated)
    //       }
    //   }
    
}

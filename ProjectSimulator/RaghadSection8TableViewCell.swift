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
    private var didSetupLayout = false //for the button constraints🚘🚘🚘🚘🚘🚘🚘🚘🚘🚘🚘🚘
    
    @IBAction func btnProceedTapped(_ sender: Any) {
        onProceedTapped?()
    }
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        
//        // SAFE: only apply radius if outlet exists
//        btnProceedToSchedulePickup?.layer.cornerRadius = 20
//        btnProceedToSchedulePickup?.clipsToBounds = true
//    }
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        // Configure the view for the selected state
//    }
  
    
    override func awakeFromNib() {
           super.awakeFromNib()

           // style
           btnProceedToSchedulePickup?.layer.cornerRadius = 20
           btnProceedToSchedulePickup?.clipsToBounds = true

           // layout by code (center + wider)
           setupLayoutIfNeeded() //for the button constraints🚘🚘🚘🚘🚘🚘🚘🚘🚘🚘🚘🚘
       }

       private func setupLayoutIfNeeded() {//for the button constraints🚘🚘🚘🚘🚘🚘🚘🚘🚘🚘🚘🚘

           guard !didSetupLayout else { return }
           didSetupLayout = true

           guard btnProceedToSchedulePickup != nil else { return }

           btnProceedToSchedulePickup.translatesAutoresizingMaskIntoConstraints = false

           NSLayoutConstraint.activate([
               // ✅ CENTER horizontally
               btnProceedToSchedulePickup.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

               // ✅ CENTER vertically (so it sits “in the middle” of the row)
               btnProceedToSchedulePickup.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

               // ✅ Make it a bit wider (works on iPhone + iPad)
               btnProceedToSchedulePickup.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.88),

               // ✅ Height (nice button size)
               btnProceedToSchedulePickup.heightAnchor.constraint(equalToConstant: 39),

               // ✅ Safety padding so it never touches edges
               btnProceedToSchedulePickup.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
               btnProceedToSchedulePickup.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
           ])
       }
   }
    
    
    
    
    
    
    
    
    
    
    


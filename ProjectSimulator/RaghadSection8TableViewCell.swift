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



}

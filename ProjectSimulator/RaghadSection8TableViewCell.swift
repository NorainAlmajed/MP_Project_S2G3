//
//  RaghadSection8TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 14/12/2025.
//

import UIKit

class RaghadSection8TableViewCell: UITableViewCell {
    var onProceedTapped: (() -> Void)?
  

    @IBAction func btnProceedToSchedulePickup(_ sender: Any) {
            onProceedTapped?()
        }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

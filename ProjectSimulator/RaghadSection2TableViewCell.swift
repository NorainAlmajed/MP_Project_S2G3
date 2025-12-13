//
//  RaghadSection2TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 13/12/2025.
//

import UIKit

class RaghadSection2TableViewCell: UITableViewCell {

    @IBOutlet weak var lblChooseDonor: UILabel!
    
    
    @IBOutlet weak var btnChooseDonor2: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupChooseDonorButton()
               selectionStyle = .none
        // Initialization code
  }
    
    
    
//    private func setupChooseDonorButton() {
//           // Border
//           btnChooseDonor2.layer.borderWidth = 1
//           btnChooseDonor2.layer.borderColor = UIColor.systemGray4.cgColor
//           btnChooseDonor2.layer.cornerRadius = 8
//           btnChooseDonor2.clipsToBounds = true
//
//        
//        // iOS button configuration
//        var config = UIButton.Configuration.plain()
//            config.title = "Select donor"
//            config.baseForegroundColor = .systemGray
//            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
//
//            btnChooseDonor2.configuration = config
//            btnChooseDonor2.contentHorizontalAlignment = .leading
//       }
//
    
    
    private func setupChooseDonorButton() {
         // Border + shape
         btnChooseDonor2.layer.borderWidth = 1
         btnChooseDonor2.layer.borderColor = UIColor.systemGray4.cgColor
         btnChooseDonor2.layer.cornerRadius = 8
         btnChooseDonor2.clipsToBounds = true

         // ✅ Use a configuration that supports background
         var config = UIButton.Configuration.filled()
         config.title = "Choose Donor"
         config.baseForegroundColor = .systemGray
         config.baseBackgroundColor = .systemGray6   // ✅ light background that stays visible
         config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12)

         // Optional: make the tap highlight look nice (not disappear)
         config.background.cornerRadius = 8

         btnChooseDonor2.configuration = config
         btnChooseDonor2.contentHorizontalAlignment = .leading
     }
    
    
    func configure(donorName: String?) {
           var config = btnChooseDonor2.configuration ?? UIButton.Configuration.filled()
           if let name = donorName, !name.isEmpty {
               config.title = name
               config.baseForegroundColor = .label
               config.baseBackgroundColor = .systemGray6
           } else {
               config.title = "Choose Donor"
               config.baseForegroundColor = .systemGray
               config.baseBackgroundColor = .systemGray6
           }
           btnChooseDonor2.configuration = config
       }
   

    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

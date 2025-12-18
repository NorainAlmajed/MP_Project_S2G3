//
//  RaghadSection2TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 13/12/2025.
//

import UIKit



protocol RaghadSection2TableViewCellDelegate: AnyObject {
    func section2DidTapChooseDonor(_ cell: RaghadSection2TableViewCell)
}

class RaghadSection2TableViewCell: UITableViewCell {

    
    weak var delegate: RaghadSection2TableViewCellDelegate?
    
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var lblChooseDonor: UILabel!
    @IBOutlet weak var btnChooseDonor2: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupChooseDonorButton()
               selectionStyle = .none
        
        // ✅ NEW: hide error by default
                lblError.isHidden = true

        // Initialization code
  }
    
    
    
    
    func configure(donorName: String?, showError: Bool) {
           var config = btnChooseDonor2.configuration ?? UIButton.Configuration.filled()

           if let name = donorName, !name.isEmpty {
               config.title = name
               config.baseForegroundColor = .label
               lblError.isHidden = true   // ✅ hide error when donor exists
           } else {
               config.title = "Choose Donor"
               config.baseForegroundColor = .systemGray
               lblError.isHidden = !showError
               lblError.text = "Please choose a donor"
           }

           btnChooseDonor2.configuration = config
       }
   
    
    
    // ✅ NEW: connect btnChooseDonor2 "Touch Up Inside" to this
    @IBAction func btnChooseDonorTapped(_ sender: Any) {
        delegate?.section2DidTapChooseDonor(self)
    }

  
    
    private func setupChooseDonorButton() {

        // 1️⃣ Border like text fields
        btnChooseDonor2.layer.borderWidth = 1
        btnChooseDonor2.layer.borderColor = UIColor.systemGray4.cgColor
        btnChooseDonor2.layer.cornerRadius = 8
        btnChooseDonor2.clipsToBounds = true

        // 2️⃣ Plain configuration = white background
        var config = UIButton.Configuration.plain()
        config.title = "Choose Donor"
        config.baseForegroundColor = .systemGray
        config.background.backgroundColor = .white   // ✅ same as textfield
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 12,
            bottom: 10,
            trailing: 12
        )

        btnChooseDonor2.configuration = config
        btnChooseDonor2.contentHorizontalAlignment = .leading
    }



    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

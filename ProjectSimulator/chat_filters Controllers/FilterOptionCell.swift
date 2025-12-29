//
//  FilterOptionCellTableViewCell.swift
//  Project
//
//  Created by zainab mahdi on 26/12/2025.
//

import UIKit

class FilterOptionCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .clear
        config.contentInsets = .zero
        
        checkBoxButton.configuration = config
        checkBoxButton.tintColor = .systemGray3
        checkBoxButton.layer.cornerRadius = 6
        checkBoxButton.backgroundColor = .clear
        checkBoxButton.isUserInteractionEnabled = true
        selectionStyle = .none
        
        
        
    }
   
           //checkbox setting checkmark function
    func setChecked(_ checked: Bool) {
                let imageName = checked ? "checkmark.square.fill" : "square"
                let image = UIImage(systemName: imageName)
                checkBoxButton.setImage(image, for: .normal)
                checkBoxButton.tintColor = checked ? .systemGreen : .systemGray3
            }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

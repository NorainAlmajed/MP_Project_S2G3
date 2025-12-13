//
//  RaghadSection5TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 13/12/2025.
//

import UIKit

class RaghadSection5TableViewCell: UITableViewCell {

    @IBOutlet weak var txtWeight: UITextField!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        

        // Initialization code
        
      
        txtWeight.keyboardType = .decimalPad
        txtWeight.inputAccessoryView = makeDoneToolbar()
        
    }
    
    
    private func makeDoneToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        toolbar.items = [flex, done]
        return toolbar
    }

    @objc private func doneTapped() {
        txtWeight.resignFirstResponder()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

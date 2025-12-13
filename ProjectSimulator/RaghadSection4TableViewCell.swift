//
//  RaghadSection4TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 13/12/2025.
//

import UIKit

class RaghadSection4TableViewCell: UITableViewCell {

    @IBOutlet weak var txtQuantity: UITextField!
    
    
    @IBOutlet weak var stepperQuantity: UIStepper!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        txtQuantity.keyboardType = .numberPad
        txtQuantity.inputAccessoryView = makeDoneToolbar() //done button in the keyboard
                txtQuantity.text = "1"
            stepperQuantity.value = 1
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
        txtQuantity.resignFirstResponder()
    }

    
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        txtQuantity.text = "\(value)"
    }

    @IBAction func textChanged(_ sender: UITextField) {
        let value = Int(sender.text ?? "") ?? 1
        stepperQuantity.value = Double(value)
    }


    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

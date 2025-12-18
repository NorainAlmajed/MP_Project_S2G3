//
//  RaghadSection4TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 13/12/2025.
//

import UIKit

class RaghadSection4TableViewCell: UITableViewCell {

    var onQuantityChanged: ((Int?) -> Void)?   // 🔢 callback
    
    @IBOutlet weak var txtQuantity: UITextField!
    
    
    @IBOutlet weak var stepperQuantity: UIStepper!
    
    
    @IBOutlet weak var lblQuantityError: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        txtQuantity.keyboardType = .numberPad
        txtQuantity.inputAccessoryView = makeDoneToolbar() //done button in the keyboard
                txtQuantity.text = "1"
            stepperQuantity.value = 1
        
        
        // ✅🟡 1) Hide error by default
        lblQuantityError.isHidden = true
        lblQuantityError.text = "Please enter a valid quantity"

        // ✅🟡 2) Stepper limits (optional but recommended)
        stepperQuantity.minimumValue = 0
        stepperQuantity.maximumValue = 999
        
        
        
        
        
        txtQuantity.keyboardType = .numberPad
            txtQuantity.inputAccessoryView = makeDoneToolbar()
            txtQuantity.text = "1"
            stepperQuantity.value = 1

            // ✅ MATCH other input fields (Expiration / Choose Donor)
            txtQuantity.layer.borderWidth = 1
            txtQuantity.layer.borderColor = UIColor.systemGray4.cgColor
            txtQuantity.layer.cornerRadius = 8
            txtQuantity.clipsToBounds = true

            // Error label
            lblQuantityError.isHidden = true
            lblQuantityError.text = "Please enter a valid quantity"

            stepperQuantity.minimumValue = 0
            stepperQuantity.maximumValue = 999

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        }
    
    // ✅🟢 VC uses this to show / hide the quantity error label
    func configure(showError: Bool) {
        lblQuantityError.isHidden = !showError
    }

    // ✅🟢 VC uses this to read quantity safely
    func getQuantityValue() -> Int? {
        guard let t = txtQuantity.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !t.isEmpty,
              let v = Int(t) else {
            return nil
        }
        return v
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
        onQuantityChanged?(value)   // ✅ notify VC
    }

    @IBAction func textChanged(_ sender: UITextField) {
        
            
            let t = sender.text ?? ""
            
            // 🔴 Empty → invalid
            if t.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                stepperQuantity.value = 0
                onQuantityChanged?(nil)   // ✅ notify VC: invalid
                return
            }
            
            // 🔴 Not a number → invalid
            guard let value = Int(t) else {
                stepperQuantity.value = 0
                onQuantityChanged?(nil)   // ✅ notify VC: invalid
                return
            }
            
            // 🔴 Negative → invalid
            if value < 0 {
                sender.text = "0"
                stepperQuantity.value = 0
                onQuantityChanged?(nil)   // ✅ notify VC: invalid
                return
            }
            
            // ✅ Valid quantity
            stepperQuantity.value = Double(value)
            onQuantityChanged?(value)    // ✅ notify VC: valid
        }
    }
    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//    }

//}

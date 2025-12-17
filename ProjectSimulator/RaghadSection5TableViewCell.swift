//
//  RaghadSection5TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 13/12/2025.
//

import UIKit

class RaghadSection5TableViewCell: UITableViewCell {

    @IBOutlet weak var lblWeightError: UILabel!   // 🔴 error label

   
    @IBOutlet weak var txtWeight: UITextField!
    var onWeightChanged: ((Double?, Bool) -> Void)?   // 🧩WEIGHT_OPTIONAL_CELL

    

    override func awakeFromNib() {
        super.awakeFromNib()
        
     

            lblWeightError?.isHidden = true
            lblWeightError?.text = "Please enter a valid weight (e.g., 1 or 1.5)"
            txtWeight?.keyboardType = .decimalPad
            txtWeight?.inputAccessoryView = makeDoneToolbar()
        }

    func configure(showError: Bool) {   // 🧩WEIGHT_OPTIONAL_CELL
        lblWeightError.isHidden = !showError
        if showError {
            lblWeightError.text = "Invalid weight format. Use 1 or 1.5"
        }
    }
    // ✅ Accepts: "1", "1.5", "0.5", "10.25"
    // ❌ Rejects: ".", "1.", ".5", "1..2", letters, negative
    private func parseWeight() -> (value: Double?, invalidFormat: Bool) {   // 🧩WEIGHT_OPTIONAL_CELL
        guard let raw = txtWeight.text else { return (nil, false) }
        let t = raw.trimmingCharacters(in: .whitespacesAndNewlines)

        // ✅ Empty is allowed (optional)
        if t.isEmpty { return (nil, false) }

        // ❌ invalid formats
        if t == "." { return (nil, true) }
        if t.hasSuffix(".") { return (nil, true) }
        if t.hasPrefix(".") { return (nil, true) }
        if t.filter({ $0 == "." }).count > 1 { return (nil, true) }

        let allowed = CharacterSet(charactersIn: "0123456789.")
        if t.rangeOfCharacter(from: allowed.inverted) != nil { return (nil, true) }

        guard let value = Double(t), value > 0 else { return (nil, true) }
        return (value, false)
    }

    
    
    
    
    
    
    
    
    
    @IBAction func weightTextChanged(_ sender: UITextField) {  // ⌨️
        let result = parseWeight()
           onWeightChanged?(result.value, result.invalidFormat)
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
}

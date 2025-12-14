//
//  RaghadSection5TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 13/12/2025.
//

import UIKit

class RaghadSection5TableViewCell: UITableViewCell {

    @IBOutlet weak var lblWeightError: UILabel!   // 🔴 error label

    var onWeightChanged: ((Double?) -> Void)?     // ⚖️ send value to
    
    
    @IBOutlet weak var txtWeight: UITextField!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblWeightError.isHidden = true   // 🙈 hide at start
        lblWeightError.text = "Please enter a valid weight (e.g., 1 or 1.5)"
        txtWeight.keyboardType = .decimalPad

        // Initialization code
        
      
        txtWeight.keyboardType = .decimalPad
        txtWeight.inputAccessoryView = makeDoneToolbar()
        
    }
    
    // ✅ Accepts: "1", "1.5", "0.5", "10.25"
    // ❌ Rejects: ".", "1.", ".5", "1..2", letters, negative
    func getWeightValue() -> Double? {
        guard let raw = txtWeight.text else { return nil }
        let t = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if t.isEmpty { return nil }

        // ❌ not allowed patterns
        if t == "." { return nil }            // dot only
        if t.hasSuffix(".") { return nil }    // "1."
        if t.hasPrefix(".") { return nil }    // ".5" (strict)
        if t.filter({ $0 == "." }).count > 1 { return nil } // "1..2"

        // ✅ only digits and dot
        let allowed = CharacterSet(charactersIn: "0123456789.")
        if t.rangeOfCharacter(from: allowed.inverted) != nil { return nil }

        // ✅ numeric + positive
        guard let value = Double(t), value > 0 else { return nil }

        return value
    }
    @IBAction func weightTextChanged(_ sender: UITextField) {  // ⌨️
        onWeightChanged?(getWeightValue())
    }

    
    
    
    
    func configure(showError: Bool) {             // 🔴
        lblWeightError.isHidden = !showError
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

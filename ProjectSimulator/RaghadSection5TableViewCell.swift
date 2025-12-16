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
    var onWeightChanged: ((Double?) -> Void)?     // ⚖️ send value to
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
     

            lblWeightError?.isHidden = true
            lblWeightError?.text = "Please enter a valid weight (e.g., 1 or 1.5)"
            txtWeight?.keyboardType = .decimalPad
            txtWeight?.inputAccessoryView = makeDoneToolbar()
        }

        func configure(showError: Bool) {
            lblWeightError?.isHidden = !showError
        }
    // ✅ Accepts: "1", "1.5", "0.5", "10.25"
    // ❌ Rejects: ".", "1.", ".5", "1..2", letters, negative
    func getWeightValue() -> Double? {
          guard let raw = txtWeight.text else { return nil }
          let t = raw.trimmingCharacters(in: .whitespacesAndNewlines)
          if t.isEmpty { return nil }

          if t == "." { return nil }
          if t.hasSuffix(".") { return nil }
          if t.hasPrefix(".") { return nil }
          if t.filter({ $0 == "." }).count > 1 { return nil }

          let allowed = CharacterSet(charactersIn: "0123456789.")
          if t.rangeOfCharacter(from: allowed.inverted) != nil { return nil }

          guard let value = Double(t), value > 0 else { return nil }
          return value
      }
    @IBAction func weightTextChanged(_ sender: UITextField) {  // ⌨️
        onWeightChanged?(getWeightValue())
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

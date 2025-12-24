//
//  RaghadSection7TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 14/12/2025.
//

import UIKit

class RaghadSection7TableViewCell: UITableViewCell, UITextViewDelegate {

    
//    @IBOutlet weak var lblWeightError: UILabel!   //  error label
//
//    var onWeightChanged: ((Double?) -> Void)?     // ⚖️ send value to
    
    
   

    
    // 🟣 BEGIN EDIT CALLBACK
    var onBeginEditing: (() -> Void)?
    // ✅ SEND TEXT TO VIEW CONTROLLER
    var onTextChanged: ((String?) -> Void)?


    
    @IBOutlet weak var lblCounter: UILabel!
    private let maxCharacters = 90
    
    
    @IBOutlet weak var txtDescription: UITextView!

        private let placeholder = "Enter a Short Description"

        override func awakeFromNib() {
            super.awakeFromNib()

            backgroundColor = .clear
            contentView.backgroundColor = .clear
            
            //  MATCH other input fields (Quantity / Weight / Expiration / Choose Donor)
                txtDescription.layer.borderWidth = 1
                txtDescription.layer.borderColor = UIColor.systemGray4.cgColor
                txtDescription.layer.cornerRadius = 8
                txtDescription.clipsToBounds = true
            txtDescription.backgroundColor = UIColor { trait in
                trait.userInterfaceStyle == .dark ? .black : .white
            }
            txtDescription.textColor = .label

                // Padding inside the text view
                txtDescription.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)

                txtDescription.delegate = self

                setPlaceholder()
                updateCounter(currentCount: 0)
                //addDoneButton()
            
            

            if txtDescription.inputAccessoryView == nil { addDoneButton() }

            

            
            
            }
    

    private func setPlaceholder() {
        txtDescription.text = placeholder
        txtDescription.textColor = .systemGray3
        updateCounter(currentCount: 0)
    }
    
    private func updateCounter(currentCount: Int) {
        lblCounter.text = "\(currentCount) / \(maxCharacters)"
    }



    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
            textView.textColor = .label
            updateCounter(currentCount: 0)
        }
        onBeginEditing?()
      


    }


    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            setPlaceholder()
        }
        
        let t = txtDescription.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if t.isEmpty || t == placeholder {
            onTextChanged?(nil)
        }

        
    }

    

    
    
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {

        // Treat placeholder as empty
        let existing = (textView.textColor == .systemGray3) ? "" : (textView.text ?? "")

        // Build the would-be text after the change
        guard let stringRange = Range(range, in: existing) else { return false }
        let updated = existing.replacingCharacters(in: stringRange, with: text)

        // Enforce hard limit (90 characters)
        if updated.count > maxCharacters {
            // Optional: allow partial paste up to 90
            if text.count > 1 { // paste case
                let allowed = maxCharacters - existing.count + (existing[stringRange].count)
                if allowed > 0 {
                    let prefix = String(text.prefix(allowed))
                    textView.text = existing.replacingCharacters(in: stringRange, with: prefix)
                    updateCounter(currentCount: textView.text.count)
                }
            }
            return false
        }

        updateCounter(currentCount: updated.count)
        return true
    }

    
    
    func textViewDidChange(_ textView: UITextView) {
        // If placeholder is active, don't count it
        if textView.textColor == .systemGray3 { return }

        if textView.text.count > maxCharacters {
            textView.text = String(textView.text.prefix(maxCharacters))
        }
        updateCounter(currentCount: textView.text.count)
        // ✅ send updated text (nil if empty)
//        let t = txtDescription.text.trimmingCharacters(in: .whitespacesAndNewlines)
//        onTextChanged?(t.isEmpty ? nil : t)
        
        
        let t = txtDescription.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if t.isEmpty || t == placeholder {
            onTextChanged?(nil)
        } else {
            onTextChanged?(t)
        }


    }

    
    
    

    
    private func addDoneButton() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.autoresizingMask = [.flexibleWidth]
        toolbar.sizeToFit()

        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        toolbar.items = [flex, done]

        txtDescription.inputAccessoryView = toolbar
    }

    
    
        @objc private func doneTapped() {
            txtDescription.resignFirstResponder()
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

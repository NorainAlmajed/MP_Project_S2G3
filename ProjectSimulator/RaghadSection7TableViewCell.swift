//
//  RaghadSection7TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 14/12/2025.
//

import UIKit

class RaghadSection7TableViewCell: UITableViewCell, UITextViewDelegate {

    
    @IBOutlet weak var lblWeightError: UILabel!   // 🔴 error label

    var onWeightChanged: ((Double?) -> Void)?     // ⚖️ send value to
    
    @IBOutlet weak var lblCounter: UILabel!
    private let maxCharacters = 90
    
    
    @IBOutlet weak var txtDescription: UITextView!

        private let placeholder = "Enter a Short Description"

        override func awakeFromNib() {
            super.awakeFromNib()

            txtDescription.layer.cornerRadius = 10
                txtDescription.layer.borderWidth = 1
                txtDescription.layer.borderColor = UIColor.systemGray4.cgColor
                txtDescription.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)

                txtDescription.delegate = self

                setPlaceholder()
                updateCounter(currentCount: 0)
                addDoneButton()
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
    }


    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            setPlaceholder()
        }
    }

    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {

        // If placeholder is showing, treat current text as empty
        let currentText = (textView.textColor == .systemGray3) ? "" : (textView.text ?? "")
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        updateCounter(currentCount: updatedText.count)
        return updatedText.count <= maxCharacters
    }


    

        private func addDoneButton() {
            let toolbar = UIToolbar()
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

//
//  ZHRejectionReasonViewController.swift
//  ProjectSimulator
//

import UIKit

class ZHRejectionReasonViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var rejectionTextArea: UITextView!
    
    @IBOutlet weak var counterLbl: UILabel!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    private let maxCharacters = 90
    private let placeholderText = "Enter a rejection reason (optional)"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Border & corner radius (like UITextField)
        rejectionTextArea.layer.borderColor = UIColor.lightGray.cgColor
        rejectionTextArea.layer.borderWidth = 1.0
        rejectionTextArea.layer.cornerRadius = 8.0
        rejectionTextArea.layer.masksToBounds = true
        rejectionTextArea.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        
        // Set delegate
        rejectionTextArea.delegate = self
        
        // Set placeholder and initial counter
        setPlaceholder()
        
        // Add Done button to keyboard
        addDoneButton()
    }
    
    // MARK: - Placeholder and Counter
    
    private func setPlaceholder() {
        rejectionTextArea.text = placeholderText
        rejectionTextArea.textColor = UIColor.systemGray3
        updateCounter(currentCount: 0)
    }
    
    private func updateCounter(currentCount: Int) {
        counterLbl.text = "\(currentCount) / \(maxCharacters)"
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText && textView.textColor == UIColor.systemGray3 {
            textView.text = ""
            textView.textColor = UIColor.label
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

        // Treat placeholder as empty
        let currentText = (textView.textColor == UIColor.systemGray3) ? "" : (textView.text ?? "")
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // Update counter with the new text length
        let count = min(updatedText.count, maxCharacters)
        updateCounter(currentCount: count)

        // Allow typing only up to maxCharacters
        return updatedText.count <= maxCharacters
    }


    
    // MARK: - Done Button
    
    private func addDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        toolbar.items = [flex, done]
        rejectionTextArea.inputAccessoryView = toolbar
    }
    
    @objc private func doneTapped() {
        rejectionTextArea.resignFirstResponder()
    }
}

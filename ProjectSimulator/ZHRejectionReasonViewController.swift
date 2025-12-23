//
//  ZHRejectionReasonViewController.swift
//  ProjectSimulator
//

import UIKit
import FirebaseFirestore


class ZHRejectionReasonViewController: UIViewController, UITextViewDelegate {

    var donation: Donation?
    var onRejectionCompleted: (() -> Void)?
    
    @IBOutlet weak var rejectionTextArea: UITextView!
    
    @IBOutlet weak var counterLbl: UILabel!
    
    @IBOutlet weak var submitBtn: UIButton!
    


        private let placeholderText = "Enter a rejection reason"
        private let maxCharacters = 90

        override func viewDidLoad() {
            super.viewDidLoad()

            self.title = "Rejection Reason"
            navigationController?.navigationBar.prefersLargeTitles = false

            // Styling
            rejectionTextArea.layer.borderWidth = 1
            rejectionTextArea.layer.borderColor = UIColor.systemGray4.cgColor
            rejectionTextArea.layer.cornerRadius = 8

            submitBtn.layer.cornerRadius = 8

            // Delegate
            rejectionTextArea.delegate = self

            // Placeholder setup
            setPlaceholder()
            updateCounter(count: 0)
        }

        // MARK: - Placeholder Logic (THIS IS THE FIX)

        private func setPlaceholder() {
            rejectionTextArea.text = placeholderText
            rejectionTextArea.textColor = .systemGray3
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == placeholderText {
                textView.text = ""
                textView.textColor = .label // black
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                setPlaceholder()
                updateCounter(count: 0)
            }
        }

        func textView(
            _ textView: UITextView,
            shouldChangeTextIn range: NSRange,
            replacementText text: String
        ) -> Bool {

            let currentText = textView.text == placeholderText ? "" : textView.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

            updateCounter(count: updatedText.count)
            return updatedText.count <= maxCharacters
        }

        private func updateCounter(count: Int) {
            counterLbl.text = "\(count) / \(maxCharacters)"
        }

        // MARK: - Submit

        @IBAction func submitTapped(_ sender: UIButton) {

            guard let donation = donation,
                  let firestoreID = donation.firestoreID else {
                print("No donation or firestoreID")
                return
            }

            let text = rejectionTextArea.text.trimmingCharacters(in: .whitespacesAndNewlines)

            // Ignore placeholder
            if text.isEmpty || text == placeholderText {
                let alert = UIAlertController(
                    title: "Error",
                    message: "Please enter a rejection reason.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                present(alert, animated: true)
                return
            }

            let donationRef = Firestore.firestore()
                .collection("Donation")
                .document(firestoreID)

            donationRef.updateData([
                "status": 4,
                "rejectionReason": text
            ]) { [weak self] error in
                guard let self = self else { return }

                if let error = error {
                    print("Firestore error:", error.localizedDescription)
                    return
                }

                // Update local object
                donation.status = 4
                donation.rejectionReason = text

                self.onRejectionCompleted?()

                let successAlert = UIAlertController(
                    title: "Success",
                    message: "The donation has been rejected successfully.",
                    preferredStyle: .alert
                )

                successAlert.addAction(UIAlertAction(title: "Dismiss", style: .default) { _ in
                    self.dismiss(animated: true)
                })

                self.present(successAlert, animated: true)
            }
        }
    }

//
//  ZHRejectionReasonViewController.swift
//  ProjectSimulator
//

import UIKit
import FirebaseFirestore


class ZHRejectionReasonViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var rejectionTextArea: UITextView!
    
    @IBOutlet weak var counterLbl: UILabel!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    private let maxCharacters = 90
    private let placeholderText = "Enter a rejection reason (optional)"
    
        
        // Add this property to receive the donation from the previous screen
        var donation: Donation?
        var onRejectionCompleted: (() -> Void)?
        
        // Add this property to store the current user
        var currentUser: User?

        
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
            
            // Dismiss keyboard when tapping outside
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)

        }
        
    @IBAction func submitTapped(_ sender: Any) {
        dismissKeyboard()

        // Ensure donation and current user exist
        guard let donation = donation, let currentUser = currentUser else { return }

        let text = rejectionTextArea.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let rejectionReason = text.isEmpty || text == placeholderText ? nil : text
        let currentDate = Date()
        let db = Firestore.firestore()

        // 1️⃣ Update donation in Firestore
        let donationRef = db.collection("Donation").document("\(donation.donationID)")
        var donationData: [String: Any] = ["status": 4]
        if let reason = rejectionReason {
            donationData["rejectionReason"] = reason
        } else {
            donationData["rejectionReason"] = NSNull()
        }

        donationRef.updateData(donationData) { [weak self] error in
            if let error = error {
                print("Error updating donation: \(error.localizedDescription)")
                return
            }

            print("Donation updated successfully in Firestore")

            // 2️⃣ Prepare notifications
            var notificationsToSend: [[String: Any]] = []

            switch currentUser.role {
            case 1: // Admin
                if donation.donor.enableNotification {
                    notificationsToSend.append([
                        "title": "Donation Rejected",
                        "description": "Donation #\(donation.donationID) has been rejected by the admin.",
                        "date": currentDate,
                        "userID": donation.donor.userID
                    ])
                }
                if donation.ngo.enableNotification {
                    notificationsToSend.append([
                        "title": "Donation Rejected",
                        "description": "Donation #\(donation.donationID) has been rejected by the admin.",
                        "date": currentDate,
                        "userID": donation.ngo.userID
                    ])
                }

            case 3: // NGO
                if donation.donor.enableNotification {
                    notificationsToSend.append([
                        "title": "Donation Rejected",
                        "description": "Donation #\(donation.donationID) has been rejected by \(donation.ngo.fullName ?? "NGO").",
                        "date": currentDate,
                        "userID": donation.donor.userID
                    ])
                }

            default:
                break
            }

            // 3️⃣ Send notifications to Firestore
            for notification in notificationsToSend {
                db.collection("Notification").addDocument(data: notification) { error in
                    if let error = error {
                        print("Error sending notification: \(error.localizedDescription)")
                    } else {
                        print("Notification sent successfully")
                    }
                }
            }

            // 4️⃣ Show success alert
            let alert = UIAlertController(
                title: "Success",
                message: "The donation has been rejected successfully",
                preferredStyle: .alert
            )
            alert.addAction(
                UIAlertAction(title: "Dismiss", style: .default) { _ in
                    self?.onRejectionCompleted?()
                    self?.dismiss(animated: true)
                }
            )
            self?.present(alert, animated: true)
        }
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
        
        //Allow closing keyboard
        @objc private func dismissKeyboard() {
            view.endEditing(true)
        }
    }

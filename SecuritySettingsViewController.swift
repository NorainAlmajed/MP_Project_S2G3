//
//  SecuritySettingsViewController.swift
//  ProjectSimulator
//

import UIKit
import FirebaseAuth

class SecuritySettingsViewController: UIViewController {

    
    
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var newEmailField: UITextField!

    @IBOutlet weak var updatePasswordButton: UIButton!
    @IBOutlet weak var updateEmailButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Security Settings"
        styleActionButton(updatePasswordButton)
        styleActionButton(updateEmailButton)
    }

    // MARK: - Change Password
    @IBAction func updatePasswordTapped(_ sender: UIButton) {

        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            showAlert("Error", "User not logged in")
            return
        }

        let currentPassword = currentPasswordField.text ?? ""
        let newPassword = newPasswordField.text ?? ""
        let confirmPassword = confirmPasswordField.text ?? ""

        guard !currentPassword.isEmpty,
              !newPassword.isEmpty,
              !confirmPassword.isEmpty else {
            showAlert("Missing Fields", "Please fill in all password fields")
            return
        }

        guard newPassword == confirmPassword else {
            showAlert("Password Mismatch", "New passwords do not match")
            return
        }

        guard newPassword.count >= 6 else {
            showAlert("Weak Password", "Password must be at least 6 characters")
            return
        }

        let credential = EmailAuthProvider.credential(
            withEmail: email,
            password: currentPassword
        )

        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                self.showAlert("Authentication Failed", error.localizedDescription)
                return
            }

            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    self.showAlert("Error", error.localizedDescription)
                } else {
                    self.showAlert("Success", "Password updated successfully")
                    self.clearPasswordFields()
                }
            }
        }
    }

    @IBAction func updateEmailTapped(_ sender: UIButton) {

        guard let user = Auth.auth().currentUser else {
            showAlert("Error", "User not logged in")
            return
        }

        let newEmail = newEmailField.text ?? ""

        guard !newEmail.isEmpty else {
            showAlert("Missing Email", "Please enter a new email")
            return
        }

        user.sendEmailVerification(beforeUpdatingEmail: newEmail) { error in
            if let error = error {
                self.showAlert("Error", error.localizedDescription)
            } else {
                self.showAlert(
                    "Verification Sent",
                    "A verification email has been sent to \(newEmail). Please verify to complete the email change."
                )
                self.newEmailField.text = ""
            }
        }
    }

    func clearPasswordFields() {
        currentPasswordField.text = ""
        newPasswordField.text = ""
        confirmPasswordField.text = ""
    }

    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func styleActionButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
    }
}

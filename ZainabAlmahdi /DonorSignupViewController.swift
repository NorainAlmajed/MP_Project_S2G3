//
//  DonorSignupViewController.swift
//  ProjectSimulator
//
//  Created by BP-36-201-02 on 20/12/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DonorSignupViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleActionButton(signupButton)
    }

    @IBAction func goToLoginTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard validateInputs() else { return }
        createDonorAccount()
    }


    func validateInputs() -> Bool {

        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let confirm = confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let phone = phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !email.isEmpty else {
            showAlert(title: "Missing Email", message: "Please enter an email address.")
            return false
        }

        guard !password.isEmpty else {
            showAlert(title: "Missing Password", message: "Please enter a password.")
            return false
        }

        guard password == confirm else {
            showAlert(title: "Password Mismatch", message: "Passwords do not match.")
            return false
        }

        guard password.count >= 6 else {
            showAlert(title: "Weak Password", message: "Password must be at least 6 characters long.")
            return false
        }

        guard !phone.isEmpty else {
            showAlert(title: "Missing Phone Number", message: "Please enter your phone number.")
            return false
        }

        guard phone.allSatisfy({ $0.isNumber }) else {
            showAlert(title: "Invalid Phone Number", message: "Phone number must contain digits only.")
            return false
        }

        guard phone.count >= 8 else {
            showAlert(title: "Invalid Phone Number", message: "Phone number must be at least 8 digits.")
            return false
        }

        return true
    }
    
    func createDonorAccount() {
        signupButton.isEnabled = false

        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.signupButton.isEnabled = true
                self.showAlert(title: "Registration Failed", message: error.localizedDescription)
                return
            }

            guard let uid = result?.user.uid else {
                self.signupButton.isEnabled = true
                return
            }

            self.saveDonorToFirestore(uid: uid, email: email)
        }
    }

    func saveDonorToFirestore(uid: String, email: String) {

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .setData([
                "role": "2",
                "username": usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                "name": nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                "phone_number": phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                "email": email,
                "profile_completed": false,
                "created_at": Timestamp()
            ]) { [weak self] error in

                guard let self = self else { return }

                if let error = error {
                    self.signupButton.isEnabled = true
                    self.showAlert(title: "Registration Failed", message: error.localizedDescription)
                    return
                }

                let vc = UIStoryboard(name: "Authentication", bundle: nil)
                    .instantiateViewController(withIdentifier: "SetupProfileViewController")
                    as! SetupProfileViewController

                vc.userRole = "2"   // Donor
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func styleActionButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
    }
}

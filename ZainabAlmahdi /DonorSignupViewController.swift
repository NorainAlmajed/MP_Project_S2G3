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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Firebase test:", Auth.auth())
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {

        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Missing Email", message: "Please enter an email address.")
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Missing Password", message: "Please enter a password.")
            return
        }

        guard let confirmPassword = confirmPasswordTextField.text,
              !confirmPassword.isEmpty else {
            showAlert(title: "Missing Confirmation", message: "Please confirm your password.")
            return
        }

        guard password == confirmPassword else {
            showAlert(title: "Password Mismatch", message: "Passwords do not match.")
            return
        }

        guard password.count >= 6 else {
            showAlert(title: "Weak Password", message: "Password must be at least 6 characters long.")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in

            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Registration Failed", message: error.localizedDescription)
                return
            }

            guard let uid = authResult?.user.uid else { return }

            // Create Firestore user document
            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "role": "Donor",
                "profileCompleted": false,
                "createdAt": Timestamp()
            ]) { error in

                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }

                // Go to setup profile
                let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
                let setupVC = storyboard.instantiateViewController(
                    withIdentifier: "SetupProfileViewController"
                ) as! SetupProfileViewController

                setupVC.userRole = "Donor"
                self.navigationController?.pushViewController(setupVC, animated: true)
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

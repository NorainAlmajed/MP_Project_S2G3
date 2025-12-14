//
//  LoginViewController.swift
//  ProjectSimulator
//
//  Created by BP-36-201-12 on 14/12/2025.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {

        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(
                title: "Missing Email",
                message: "Please enter your email address."
            )
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(
                title: "Missing Password",
                message: "Please enter your password."
            )
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in

            if let error = error {
                self?.showAlert(
                    title: "Login Failed",
                    message: error.localizedDescription
                )
                return
            }

            // Login successful
            self?.performSegue(withIdentifier: "Home", sender: sender)
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

    /*

     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

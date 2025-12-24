//
//  LoginViewController.swift
//  ProjectSimulator
//
//  Created by BP-36-201-02 on 20/12/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        styleActionButton(loginButton)
    }


    @IBAction func signupButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRoleSelection", sender: self)
    }

    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(
                title: "Email Required",
                message: "Please enter your email to reset your password."
            )
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
                return
            }

            self?.showAlert(
                title: "Email Sent",
                message: "A password reset link has been sent to your email."
            )
        }
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {

        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Missing Email", message: "Please enter your email.")
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Missing Password", message: "Please enter your password.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Login Failed", message: error.localizedDescription)
                return
            }

            SessionManager.shared.fetchUserRole { success in
                DispatchQueue.main.async {
                    if success {
                        self.performSegue(withIdentifier: "goToAccount", sender: nil)
                    } else {
                        self.showAlert(title: "Error", message: "Could not load user role.")
                    }
                }
            }
        }

    }
    
    enum UserRole: String {
        case admin = "1"
        case donor = "2"
        case ngo = "3"
    }

    func routeUserByRole(uid: String) {
        let db = Firestore.firestore()

        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }

            guard
                let roleString = snapshot?.data()?["role"] as? String,
                let role = UserRole(rawValue: roleString)
            else {
                self.showAlert(title: "Error", message: "Invalid user role.")
                return
            }

            switch role {
            case .admin:
                self.goToAdminHome()
            case .ngo:
                self.goToNGOHome()
            case .donor:
                self.goToDonorHome()
            }
        }
    }
    
    func goToAdminHome() {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "AdminHomeViewController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    func goToNGOHome() {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "NGOHomeViewController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    func goToDonorHome() {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "DonorHomeViewController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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

    private func styleActionButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
    }
}

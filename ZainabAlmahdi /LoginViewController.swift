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

    override func viewDidLoad() {
        super.viewDidLoad()
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

            let uid = result!.user.uid
            self.routeUserByRole(uid: uid)
        }
    }

    func routeUserByRole(uid: String) {

        let db = Firestore.firestore()

        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }

            let role = snapshot?.data()?["role"] as? String ?? "donor"

            if role == "ngo" {
                self.goToNGOHome()
            } else {
                self.goToDonorHome()
            }
        }
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
}

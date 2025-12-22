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
            showAlert(title: "Email Required",
                      message: "Please enter your email to reset your password.")
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
                return
            }

            self?.showAlert(title: "Email Sent",
                            message: "A password reset link has been sent to your email.")
        }
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {

        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Missing Email", message: "Please enter your email address.")
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Missing Password", message: "Please enter your password.")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in

            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Login Failed", message: error.localizedDescription)
                return
            }

            guard let uid = authResult?.user.uid else { return }

            self.handleFirestoreRouting(uid: uid)
        }
    }

    // 🔥 FIRESTORE ROUTING LOGIC
    func handleFirestoreRouting(uid: String) {

        let db = Firestore.firestore()

        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in

            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }

            guard let data = snapshot?.data() else {
                self.showAlert(title: "Error", message: "User data not found.")
                return
            }

            let role = data["role"] as? String ?? ""
            let profileCompleted = data["profileCompleted"] as? Bool ?? false

            if profileCompleted == false {
                self.goToSetupProfile(role: role)
            } else {
                self.routeToDashboard(role: role)
            }
        }
    }

    // ➡️ Setup Profile
    func goToSetupProfile(role: String) {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let setupVC = storyboard.instantiateViewController(
            withIdentifier: "SetupProfileViewController"
        ) as! SetupProfileViewController

        setupVC.userRole = role
        navigationController?.pushViewController(setupVC, animated: true)
    }

    // ➡️ Dashboard (handled by teammate)
    func routeToDashboard(role: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let identifier: String
        if role == "NGO" {
            identifier = "NGOHomeViewController"
        } else {
            identifier = "DonorHomeViewController"
        }

        let homeVC = storyboard.instantiateViewController(withIdentifier: identifier)

        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = homeVC
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


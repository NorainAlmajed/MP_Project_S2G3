import UIKit
import FirebaseAuth

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
        navigationItem.title = ""
    }

    // MARK: - Forgot Password
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty else {
            showAlert(title: "Email Required", message: "Please enter your email.")
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            self?.showAlert(title: "Email Sent", message: "Check your inbox.")
        }
    }

    // MARK: - Login
    @IBAction func loginButtonTapped(_ sender: UIButton) {

        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty else {
            showAlert(title: "Missing Email", message: "Enter your email.")
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Missing Password", message: "Enter your password.")
            return
        }

        loginButton.isEnabled = false

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else { return }

            if let error = error {
                self.loginButton.isEnabled = true
                self.showAlert(title: "Login Failed", message: error.localizedDescription)
                return
            }

            SessionManager.shared.fetchUserRole { success in
                DispatchQueue.main.async {
                    self.loginButton.isEnabled = true

                    if success {
                        self.routeToHome()
                    } else {
                        self.showAlert(title: "Error", message: "Failed to load user role.")
                    }
                }
            }
        }
    }

    // MARK: - Routing
    func routeToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier: String

        if SessionManager.shared.isAdmin {
            identifier = "AdminHomeViewController"
        } else if SessionManager.shared.isNGO {
            identifier = "NGOHomeViewController"
        } else if SessionManager.shared.isDonor {
            identifier = "DonorHomeViewController"
        } else {
            showAlert(title: "Error", message: "Unknown role.")
            return
        }

        let homeVC = storyboard.instantiateViewController(withIdentifier: identifier)

        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = homeVC
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }

    // MARK: - Helpers
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

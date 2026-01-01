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
    }

    // MARK: - Forgot Password
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty else {
            showAlert(title: "Email Required", message: "Please enter your email.")
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                self?.showAlert(title: "Email Sent", message: "Check your inbox.")
            }
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

            if let error = error as NSError? {
                DispatchQueue.main.async {
                    self.loginButton.isEnabled = true

                    if let authError = AuthErrorCode(rawValue: error.code) {
                        switch authError {

                        case .wrongPassword:
                            self.passwordTextField.text = ""
                            self.showAlert(
                                title: "Incorrect Password",
                                message: "The password you entered is incorrect. Please try again."
                            )

                        case .userNotFound:
                            self.showAlert(
                                title: "Account Not Found",
                                message: "No account is associated with this email."
                            )

                        case .invalidEmail:
                            self.showAlert(
                                title: "Invalid Email",
                                message: "Please enter a valid email address."
                            )

                        case .networkError:
                            self.showAlert(
                                title: "Network Error",
                                message: "Please check your internet connection."
                            )

                        default:
                            self.showAlert(
                                title: "Login Failed",
                                message: error.localizedDescription
                            )
                        }
                    }
                }
                return
            }

            DispatchQueue.main.async {
                self.loginButton.isEnabled = true
                self.routeToHome()
            }
        }
    }

    // MARK: - Routing
    func routeToHome() {
        let tabStoryboard = UIStoryboard(name: "Main", bundle: nil)

        guard let tabBarVC = tabStoryboard.instantiateInitialViewController() else {
            showAlert(title: "Error", message: "Tab Bar not found")
            return
        }

        guard let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate else { return }

        sceneDelegate.window?.rootViewController = tabBarVC
        sceneDelegate.window?.makeKeyAndVisible()
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

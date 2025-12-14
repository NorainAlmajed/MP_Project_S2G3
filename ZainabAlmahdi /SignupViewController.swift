import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {

        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(
                title: "Missing Email",
                message: "Please enter an email address."
            )
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(
                title: "Missing Password",
                message: "Please enter a password."
            )
            return
        }

        guard let confirmPassword = confirmPasswordTextField.text,
              !confirmPassword.isEmpty else {
            showAlert(
                title: "Missing Confirmation",
                message: "Please confirm your password."
            )
            return
        }

        guard password == confirmPassword else {
            showAlert(
                title: "Password Mismatch",
                message: "Passwords do not match. Please try again."
            )
            return
        }

        guard password.count >= 6 else {
            showAlert(
                title: "Weak Password",
                message: "Password must be at least 6 characters long."
            )
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in

            if let error = error {
                self?.showAlert(
                    title: "Registration Failed",
                    message: error.localizedDescription
                )
                return
            }

            self?.navigationController?.popViewController(animated: true)
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

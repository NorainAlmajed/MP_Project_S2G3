import UIKit
import FirebaseAuth

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
                self?.showAlert(
                    title: "Error",
                    message: error.localizedDescription
                )
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

            // Login successful - save user ID to UserDefaults
            if let userID = authResult?.user.uid {
                UserDefaults.standard.set(userID, forKey: "userID")
            }

            // Navigate to home screen
            // temp for Fatima
            self?.switchToDashboard()


            // temp commented
            //self?.performSegue(withIdentifier: "goToHome", sender: sender)
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
    // For Fatima, Temp to move to dashboard
    private func switchToDashboard() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate else {
            return
        }

        let storyboard = UIStoryboard(name: "DonorDashboard_Fatima", bundle: nil)

        // IMPORTANT: load the TAB BAR CONTROLLER
        let tabBarController = storyboard.instantiateInitialViewController()

        sceneDelegate.window?.rootViewController = tabBarController
        sceneDelegate.window?.makeKeyAndVisible()
    }



}

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
        navigationItem.title = "Sign Up"
    }

    // MARK: - Navigation

    @IBAction func goToLoginTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard validateInputs() else { return }

        let username = usernameTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !username.isEmpty else {
            showAlert(title: "Missing Username", message: "Please enter a username.")
            return
        }

        signupButton.isEnabled = false

        checkUsernameAvailability(username) { [weak self] available in
            DispatchQueue.main.async {
                guard let self = self else { return }

                if !available {
                    self.signupButton.isEnabled = true
                    self.showAlert(
                        title: "Username Taken",
                        message: "This username is already in use. Please choose another one."
                    )
                    return
                }

                // ✅ Username is unique → proceed
                self.createDonorAccount()
            }
        }
    }

    
    func checkUsernameAvailability(
        _ username: String,
        completion: @escaping (Bool) -> Void
    ) {
        Firestore.firestore()
            .collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments { snapshot, error in

                if let error = error {
                    print("❌ Username check error:", error.localizedDescription)
                    completion(false)
                    return
                }

                // Username is available if no documents exist
                completion(snapshot?.documents.isEmpty == true)
            }
    }


    // MARK: - Validation

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

    // MARK: - Firebase Signup

    func createDonorAccount() {
        signupButton.isEnabled = false

        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.signupButton.isEnabled = true
                self.showAlert(
                    title: "Registration Failed",
                    message: error.localizedDescription
                )
                return
            }

            guard let uid = result?.user.uid else {
                self.signupButton.isEnabled = true
                return
            }

            self.saveDonorToFirestore(uid: uid, email: email)
        }
    }

    // MARK: - Firestore

    func saveDonorToFirestore(uid: String, email: String) {

        let donorData: [String: Any] = [
            "role": 2,
            "username": usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            "full_name": nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            "number": phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            "email": email,
            "profile_image_url": "",          // ✅ REQUIRED
            "profile_completed": false,
            "created_at": Timestamp()
        ]

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .setData(donorData) { [weak self] error in
                guard let self = self else { return }

                if let error = error {
                    self.signupButton.isEnabled = true
                    self.showAlert(
                        title: "Registration Failed",
                        message: error.localizedDescription
                    )
                    return
                }

                self.sendAdminNotification(
                    for: self.usernameTextField.text ?? ""
                )

                self.loadSessionAndRoute()
            }
    }

    // MARK: - Session + Routing

    func loadSessionAndRoute() {

        SessionManager.shared.loadUserSession { [weak self] success in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if success {

                    let vc = UIStoryboard(
                        name: "Authentication",
                        bundle: nil
                    ).instantiateViewController(
                        withIdentifier: "SetupProfileViewController"
                    )

                    let nav = UINavigationController(rootViewController: vc)

                    if let sceneDelegate = UIApplication.shared.connectedScenes
                        .first?.delegate as? SceneDelegate {

                        sceneDelegate.window?.rootViewController = nav
                        sceneDelegate.window?.makeKeyAndVisible()
                    }

                } else {
                    self.signupButton.isEnabled = true
                    self.showAlert(
                        title: "Error",
                        message: "Unable to load user session."
                    )
                }
            }
        }
    }

    // MARK: - Helpers

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

    // MARK: - Admin Notification

    func sendAdminNotification(for username: String) {
        let adminID = "TwWqBSGX4ec4gxCWCZcbo7WocAI2"

        let notificationData: [String: Any] = [
            "date": Timestamp(date: Date()),
            "title": "New Donor Registration",
            "description": "\(username) has just signed up to the system.",
            "userID": adminID
        ]

        Firestore.firestore()
            .collection("Notification")
            .addDocument(data: notificationData)
    }
}

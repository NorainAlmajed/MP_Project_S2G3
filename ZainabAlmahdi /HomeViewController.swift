import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = Auth.auth().currentUser {
            print("Logged in as: \(user.email ?? "No email")")
            print("User ID: \(user.uid)")
            print("Email verified: \(user.isEmailVerified)")
        } else {
            print("No authenticated user")
        }
    }

    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        do {
            // Sign out user
            try Auth.auth().signOut()

            // Clear saved user ID
            UserDefaults.standard.removeObject(forKey: "userID")

            // Navigate to Login
            navigateToLogin()
        } catch {
            print("Sign out failed")
        }
    }

    private func navigateToLogin() {
        let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        if let loginVC = authStoryboard.instantiateViewController(
            withIdentifier: "LoginViewController"
        ) as? LoginViewController {

            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true)
        }
    }
    
    func checkIfUserIsLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }

    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }

    func getCurrentUserEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
}

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = Auth.auth().currentUser {
            print("Logged in as: \(user.email ?? "No email")")
            print("User ID: \(user.uid)")
        }
    }

    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()

            SessionManager.shared.clear()

            navigateToLogin()
        } catch {
            print("Sign out failed: \(error.localizedDescription)")
        }
    }

    private func navigateToLogin() {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let loginVC = storyboard.instantiateViewController(
            withIdentifier: "LoginViewController"
        )

        loginVC.modalPresentationStyle = .fullScreen

        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate {

            sceneDelegate.window?.rootViewController = loginVC
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}

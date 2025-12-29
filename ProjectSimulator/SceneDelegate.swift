import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var authListenerHandle: AuthStateDidChangeListenerHandle?
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let loginVC = storyboard.instantiateViewController(
            withIdentifier: "LoginViewController"
        )

        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
    }



    // ✅ PUBLIC so LoginVC can call it
    func startAuthListener() {
        // Prevent duplicate listeners
        if authListenerHandle != nil { return }

        authListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }

            if user == nil {
                self.showLogin()
            } else {
                self.showDashboard()
            }
        }
    }

    func showLogin() {
        let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        let loginVC = authStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        window?.rootViewController = loginVC
    }

    func showDashboard() {
        let dashboardStoryboard = UIStoryboard(name: "Dashboard_Fatima", bundle: nil)
        let dashboardVC = dashboardStoryboard.instantiateInitialViewController()
        window?.rootViewController = dashboardVC
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

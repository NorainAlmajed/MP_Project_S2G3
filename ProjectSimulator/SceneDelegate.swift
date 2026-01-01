import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Create window
        let window = UIWindow(windowScene: windowScene)

        // Tab bar appearance (safe here)
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor(named: "tabBarColor")
        tabBarAppearance.unselectedItemTintColor =
            UIColor(named: "tabBarColor")?.withAlphaComponent(0.4)

        // Load Login screen
        let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        let loginVC = authStoryboard.instantiateViewController(
            withIdentifier: "LoginViewController"
        )

        // Wrap login in Navigation Controller
        let navController = UINavigationController(rootViewController: loginVC)

        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
}

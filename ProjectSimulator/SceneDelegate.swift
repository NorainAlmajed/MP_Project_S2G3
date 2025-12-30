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

        // Load Authentication storyboard
        let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)

        // Initial screen: Login
        let loginVC = authStoryboard.instantiateViewController(
            withIdentifier: "LoginViewController"
        )

        // embed in UINavigationController
        let navController = UINavigationController(rootViewController: loginVC)

        // Set as root
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
}

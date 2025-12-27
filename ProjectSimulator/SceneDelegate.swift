import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        setRootViewController()
        window?.makeKeyAndVisible()
    }

    private func setRootViewController() {

        if Auth.auth().currentUser != nil {
            // Logged in → Main app
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootVC = storyboard.instantiateInitialViewController()
            window?.rootViewController = rootVC
        } else {
            // Not logged in → Authentication flow
            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            let rootVC = storyboard.instantiateInitialViewController()
            window?.rootViewController = rootVC
        }
    }

    // MARK: - Scene lifecycle (empty is fine)
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        let loginVC = authStoryboard.instantiateViewController(
            withIdentifier: "LoginViewController"
        )

        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
    }
}

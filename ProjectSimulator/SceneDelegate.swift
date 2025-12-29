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

//        let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
//        let loginVC = authStoryboard.instantiateViewController(
//            withIdentifier: "LoginViewController"
//        )

        let storyboard = UIStoryboard(name: "Raghad1", bundle: nil)

        guard let rootVC = storyboard.instantiateInitialViewController() else {
            fatalError("❌ Raghad1 storyboard has NO Initial View Controller")
        }

        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()

        
        //window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
    }
}

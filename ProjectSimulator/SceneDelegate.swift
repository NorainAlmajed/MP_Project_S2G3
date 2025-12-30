import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

//    func scene(
//        _ scene: UIScene,
//        willConnectTo session: UISceneSession,
//        options connectionOptions: UIScene.ConnectionOptions
//    ) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//
//        window = UIWindow(windowScene: windowScene)
//
//        let authStoryboard = UIStoryboard(name: "norain-schedule-pickup", bundle: nil)
//        let loginVC = authStoryboard.instantiateViewController(
//            withIdentifier: "SchedulePickupViewController"
//        )
//
//        window?.rootViewController = loginVC
//        window?.makeKeyAndVisible()
//    }
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let storyboard = UIStoryboard(name: "norain-schedule-pickup", bundle: nil)
        let rootVC = storyboard.instantiateViewController(withIdentifier: "SchedulePickupViewController")
        
        // MUST wrap the root in a Navigation Controller
        let navVC = UINavigationController(rootViewController: rootVC)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navVC
        self.window = window
        window.makeKeyAndVisible()
    }
}

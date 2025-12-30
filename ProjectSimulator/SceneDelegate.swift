import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Create window
        let window = UIWindow(windowScene: windowScene)

        // Load Authentication storyboard
        let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)

        // Initial screen: Login
        let loginVC = authStoryboard.instantiateViewController(
        withIdentifier: "LoginViewController"
        
        )

<<<<<<< HEAD
        // Embed UINvigationController
        let navController = UINavigationController(rootViewController: loginVC)

        // Set as root
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
        
        }
=======
//        let storyboard = UIStoryboard(name: "Raghad1", bundle: nil)
//
//        guard let rootVC = storyboard.instantiateInitialViewController() else {
//            fatalError("❌ Raghad1 storyboard has NO Initial View Controller")
//        }
//
//        window?.rootViewController = rootVC
//        window?.makeKeyAndVisible()

        
        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
>>>>>>> main
    }
    
//    Norain schedule pickup tests
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        
//        let storyboard = UIStoryboard(name: "norain-schedule-pickup", bundle: nil)
//        let rootVC = storyboard.instantiateViewController(withIdentifier: "SchedulePickupViewController")
//        
//        // MUST wrap the root in a Navigation Controller
//        let navVC = UINavigationController(rootViewController: rootVC)
//        
//        let window = UIWindow(windowScene: windowScene)
//        window.rootViewController = navVC
//        self.window = window
//        window.makeKeyAndVisible()
//    }


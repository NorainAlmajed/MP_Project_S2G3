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

        let authStoryboard = UIStoryboard(name: "norain-schedule-pickup", bundle: nil)
        let loginVC = authStoryboard.instantiateViewController(
            withIdentifier: "SchedulePickupViewController"
        )

        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
    }
    
}

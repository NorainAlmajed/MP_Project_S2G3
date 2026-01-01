import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
       
        // Tab bar appearance (safe here)
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor(named: "tabBarColor")
        tabBarAppearance.unselectedItemTintColor =
        UIColor(named: "tabBarColor")?.withAlphaComponent(0.4)
        
        
        
        
    }
}

import UIKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
       
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor(named: "tabBarColor")
        tabBarAppearance.unselectedItemTintColor =
        UIColor(named: "tabBarColor")?.withAlphaComponent(0.4)
        
        let backAppearance = UIBarButtonItemAppearance()
        backAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        backAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.clear]
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.backButtonAppearance = backAppearance
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        
        UINavigationBar.appearance().tintColor = .label
    }
}


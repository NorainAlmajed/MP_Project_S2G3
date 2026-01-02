import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        
        let backAppearance = UIBarButtonItemAppearance()
        backAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        backAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        let navAppearance = UINavigationBarAppearance()
    
        navAppearance.configureWithTransparentBackground()
        navAppearance.backgroundEffect = nil

        
        navAppearance.backButtonAppearance = backAppearance
        
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        
        // Back arrow color (adapts in Dark Mode automatically)
        UINavigationBar.appearance().tintColor = .label
    }
}

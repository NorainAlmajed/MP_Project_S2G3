//
//  SceneDelegate.swift
//  ProjectSimulator
//

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

    // ✅ WORKING FIREBASE-BASED ROOT LOGIC (ACTIVE)
    func setRootViewController() {
        let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)

        if Auth.auth().currentUser != nil {
            // User already logged in
            let homeVC = authStoryboard.instantiateViewController(
                withIdentifier: "HomeViewController"
            )
            window?.rootViewController = homeVC
        } else {
            // User NOT logged in → show Login
            let loginVC = authStoryboard.instantiateViewController(
                withIdentifier: "LoginViewController"
            )
            window?.rootViewController = loginVC
        }
    }

    /*
    // ❌ NEW DASHBOARD-BASED ROOT LOGIC (COMMENTED – KEEP FOR LATER)
    private func setRootViewController_NewDashboardFlow() {

        if Auth.auth().currentUser != nil {
            let dashboardStoryboard = UIStoryboard(name: "Dashboard_Fatima", bundle: nil)
            let dashboardVC = dashboardStoryboard.instantiateInitialViewController()
            window?.rootViewController = dashboardVC
        } else {
            let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            let loginVC = authStoryboard.instantiateInitialViewController()
            window?.rootViewController = loginVC
        }
    }
    */

    // MARK: - Scene lifecycle
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

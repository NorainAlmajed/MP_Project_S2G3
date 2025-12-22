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

    func setRootViewController() {
        let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)

        if Auth.auth().currentUser != nil {
            // User logged in
            let homeVC = authStoryboard.instantiateViewController(
                withIdentifier: "HomeViewController"
            )
            window?.rootViewController = homeVC
        } else {
            // User NOT logged in
            let loginVC = authStoryboard.instantiateViewController(
                withIdentifier: "LoginViewController"
            )
            window?.rootViewController = loginVC
        }
    }

    // MARK: - Scene lifecycle

    func sceneDidDisconnect(

//
//  SceneDelegate.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 28/11/2025.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        setRootViewController()
        window?.makeKeyAndVisible()
    }
    
    func setRootViewController() {
        
        let storyboard = UIStoryboard(name: "norain-admin-controls1", bundle: nil)
        
//        if Auth.auth().currentUser != nil {
            // Logged in → Noorain screen
            let noorainVC = storyboard.instantiateViewController(
                withIdentifier: "NourishUsersViewController"
            )
            window?.rootViewController = noorainVC
            
            //        } else {
            //            // Not logged in → Login
            //            let loginVC = storyboard.instantiateViewController(
            //                withIdentifier: "LoginViewController"
            //            )
            //            window?.rootViewController = loginVC
            //        }
//        }
    }
}

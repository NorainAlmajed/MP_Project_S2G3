//
//  SplashViewController.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 01/01/2026.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        animateTitle()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.goToAuth()
        }
    }

    // MARK: - Title animation
    private func setupInitialState() {
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
    }

    private func animateTitle() {
        UIView.animate(
            withDuration: 1.2,
            delay: 0.3,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.6,
            options: .curveEaseOut,
            animations: {
                self.titleLabel.alpha = 1
                self.titleLabel.transform = .identity
            }
        )
    }

    // MARK: - Navigation
    private func goToAuth() {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let authVC = storyboard.instantiateInitialViewController()!

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        UIView.transition(
            with: window,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                window.rootViewController = authVC
            }
        )
    }
}

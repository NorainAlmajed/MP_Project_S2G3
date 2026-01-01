//
//  SplashViewController.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 01/01/2026.
//

import UIKit

class SplashViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialState()
        animateSplash()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.goToAuth()
        }
    }

    // MARK: - Initial State
    private func setupInitialState() {
        // Logo starts hidden and slightly down
        logoImageView.alpha = 0
        logoImageView.transform = CGAffineTransform(translationX: 0, y: 20)

        // Title starts hidden and slightly smaller
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
    }

    // MARK: - Animations
    private func animateSplash() {

        // Logo animation
        UIView.animate(
            withDuration: 0.8,
            delay: 0.1,
            options: .curveEaseOut,
            animations: {
                self.logoImageView.alpha = 1
                self.logoImageView.transform = .identity
            }
        )

        // Title animation (staggered)
        UIView.animate(
            withDuration: 1.0,
            delay: 0.4,
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

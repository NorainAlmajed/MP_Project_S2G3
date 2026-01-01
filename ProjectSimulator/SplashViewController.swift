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

        // ✅ Add this label in Storyboard (small label under the title) and connect it
        @IBOutlet weak var loadingLabel: UILabel!


        // MARK: - Gradient
        private var gradientLayer: CAGradientLayer?

        // MARK: - Loading Dots
        private var loadingTimer: Timer?
        private var dotCount = 0

        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()

            addGradientBackground()
            styleLogo()

            setupInitialState()
            animateSplash()
            startLoadingDots()

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.goToAuth()
            }
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            gradientLayer?.frame = view.bounds
        }

        deinit {
            stopLoadingDots()
        }

        // MARK: - UI Enhancements

        private func addGradientBackground() {
            let g = CAGradientLayer()

            let beige = UIColor(named: "BeigeCol") ?? UIColor.systemBackground

            g.colors = [
                beige.cgColor,
                UIColor.secondarySystemBackground.cgColor
            ]

            g.startPoint = CGPoint(x: 0, y: 0)
            g.endPoint   = CGPoint(x: 1, y: 1)
            g.frame = view.bounds

            view.layer.insertSublayer(g, at: 0)
            gradientLayer = g
        }

        private func styleLogo() {
            logoImageView.layer.shadowColor = UIColor.black.cgColor
            logoImageView.layer.shadowOpacity = 0.15
            logoImageView.layer.shadowRadius = 12
            logoImageView.layer.shadowOffset = CGSize(width: 0, height: 6)
        }

        // MARK: - Initial State
        private func setupInitialState() {

            logoImageView.alpha = 0
            logoImageView.transform = CGAffineTransform(translationX: 0, y: 20)

            titleLabel.alpha = 0
            titleLabel.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)

            loadingLabel.alpha = 0
            loadingLabel.text = "Loading"
        }

        // MARK: - Animations
        private func animateSplash() {

            UIView.animate(
                withDuration: 0.8,
                delay: 0.1,
                options: .curveEaseOut,
                animations: {
                    self.logoImageView.alpha = 1
                    self.logoImageView.transform = .identity
                },
                completion: { _ in
                    UIView.animate(withDuration: 0.25, animations: {
                        self.logoImageView.transform = CGAffineTransform(scaleX: 1.04, y: 1.04)
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.25) {
                            self.logoImageView.transform = .identity
                        }
                    })
                }
            )

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

            UIView.animate(
                withDuration: 0.5,
                delay: 0.75,
                options: .curveEaseOut,
                animations: {
                    self.loadingLabel.alpha = 1
                }
            )
        }

        // MARK: - Loading Dots
        private func startLoadingDots() {
            dotCount = 0
            loadingTimer?.invalidate()

            loadingTimer = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.dotCount = (self.dotCount + 1) % 4
                self.loadingLabel.text = "Loading" + String(repeating: ".", count: self.dotCount)
            }
        }

        private func stopLoadingDots() {
            loadingTimer?.invalidate()
            loadingTimer = nil
        }

        // MARK: - Navigation
        private func goToAuth() {
            stopLoadingDots()

            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            let authVC = storyboard.instantiateInitialViewController()!

            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }

            UIView.animate(withDuration: 0.25, animations: {
                self.view.alpha = 0
            }, completion: { _ in
                UIView.transition(
                    with: window,
                    duration: 0.5,
                    options: .transitionCrossDissolve,
                    animations: {
                        window.rootViewController = authVC
                    }
                )
            })
        }
    }

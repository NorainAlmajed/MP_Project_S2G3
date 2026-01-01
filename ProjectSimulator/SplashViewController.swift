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


        // MARK: - Layers
        private var gradientLayer: CAGradientLayer?
        private var sparkleLayer: CAEmitterLayer?

        // MARK: - Loading
        private var loadingTimer: Timer?
        private var dotCount = 0

        // MARK: - Extra UI (added programmatically, no storyboard needed)
        private let activity = UIActivityIndicatorView(style: .medium)

        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()

            addGradientBackground()
            animateGradientBackground()

            styleLogo()
            setupActivityIndicator()

            setupInitialState()
            animateSplash()

            startLoadingDots()

            // Smooth transition timing
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                self?.goToAuth()
            }
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            gradientLayer?.frame = view.bounds
            // keep sparkles around logo correctly if layout changes
            updateSparklesPosition()
        }

        deinit {
            stopLoadingDots()
        }

        // MARK: - UI Enhancements

        private func addGradientBackground() {
            let g = CAGradientLayer()
            let beige = UIColor(named: "BeigeCol") ?? UIColor.systemBackground

            // Slightly more “designed” than systemBackground
            g.colors = [
                beige.cgColor,
                UIColor.secondarySystemBackground.cgColor,
                beige.withAlphaComponent(0.92).cgColor
            ]
            g.locations = [0.0, 0.6, 1.0]
            g.startPoint = CGPoint(x: 0.0, y: 0.0)
            g.endPoint   = CGPoint(x: 1.0, y: 1.0)
            g.frame = view.bounds

            view.layer.insertSublayer(g, at: 0)
            gradientLayer = g
        }

        /// Slow-moving gradient = premium feel
        private func animateGradientBackground() {
            guard UIAccessibility.isReduceMotionEnabled == false else { return }
            guard let g = gradientLayer else { return }

            let anim = CABasicAnimation(keyPath: "startPoint")
            anim.fromValue = CGPoint(x: 0.0, y: 0.0)
            anim.toValue   = CGPoint(x: 0.2, y: 0.2)
            anim.duration = 3.2
            anim.autoreverses = true
            anim.repeatCount = .infinity
            anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            g.add(anim, forKey: "gradient.startPoint")

            let anim2 = CABasicAnimation(keyPath: "endPoint")
            anim2.fromValue = CGPoint(x: 1.0, y: 1.0)
            anim2.toValue   = CGPoint(x: 0.85, y: 0.95)
            anim2.duration = 3.2
            anim2.autoreverses = true
            anim2.repeatCount = .infinity
            anim2.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            g.add(anim2, forKey: "gradient.endPoint")
        }

        private func styleLogo() {
            logoImageView.layer.shadowColor = UIColor.black.cgColor
            logoImageView.layer.shadowOpacity = 0.18
            logoImageView.layer.shadowRadius = 14
            logoImageView.layer.shadowOffset = CGSize(width: 0, height: 8)

            // Make logo edges smoother if it’s not already
            logoImageView.layer.masksToBounds = false
        }

        private func setupActivityIndicator() {
            activity.translatesAutoresizingMaskIntoConstraints = false
            activity.hidesWhenStopped = true

            view.addSubview(activity)

            // Place it below loadingLabel (no storyboard changes)
            NSLayoutConstraint.activate([
                activity.topAnchor.constraint(equalTo: loadingLabel.bottomAnchor, constant: 10),
                activity.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }

        // MARK: - Initial State
        private func setupInitialState() {
            // Logo starts hidden and slightly down
            logoImageView.alpha = 0
            logoImageView.transform = CGAffineTransform(translationX: 0, y: 26).scaledBy(x: 0.98, y: 0.98)

            // Title starts hidden and slightly smaller
            titleLabel.alpha = 0
            titleLabel.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)

            loadingLabel.alpha = 0
            loadingLabel.text = "Loading"

            activity.stopAnimating()
        }

        // MARK: - Animations
        private func animateSplash() {
            // Respect Reduce Motion
            let reduceMotion = UIAccessibility.isReduceMotionEnabled

            // 1) Logo reveal + tiny “shine” feel
            UIView.animate(
                withDuration: reduceMotion ? 0.35 : 0.85,
                delay: 0.05,
                options: [.curveEaseOut],
                animations: {
                    self.logoImageView.alpha = 1
                    self.logoImageView.transform = .identity
                },
                completion: { _ in
                    if !reduceMotion {
                        self.startFloatingLogo()
                        self.addSparklesBehindLogo()
                    }
                }
            )

            // 2) Title spring in
            UIView.animate(
                withDuration: reduceMotion ? 0.25 : 1.0,
                delay: 0.32,
                usingSpringWithDamping: 0.82,
                initialSpringVelocity: 0.55,
                options: [.curveEaseOut],
                animations: {
                    self.titleLabel.alpha = 1
                    self.titleLabel.transform = .identity
                },
                completion: nil
            )

            // 3) Loading label + activity indicator
            UIView.animate(
                withDuration: reduceMotion ? 0.2 : 0.55,
                delay: 0.68,
                options: [.curveEaseOut],
                animations: {
                    self.loadingLabel.alpha = 1
                },
                completion: { _ in
                    self.activity.startAnimating()
                }
            )
        }

        /// Subtle float = very “app store” vibe
        private func startFloatingLogo() {
            guard UIAccessibility.isReduceMotionEnabled == false else { return }

            let float = CAKeyframeAnimation(keyPath: "transform.translation.y")
            float.values = [0, -6, 0, 4, 0]
            float.keyTimes = [0, 0.25, 0.55, 0.8, 1.0]
            float.duration = 2.8
            float.repeatCount = .infinity
            float.timingFunctions = [
                CAMediaTimingFunction(name: .easeInEaseOut),
                CAMediaTimingFunction(name: .easeInEaseOut),
                CAMediaTimingFunction(name: .easeInEaseOut),
                CAMediaTimingFunction(name: .easeInEaseOut)
            ]
            logoImageView.layer.add(float, forKey: "logo.float")

            // Tiny pulse (very subtle)
            let pulse = CABasicAnimation(keyPath: "transform.scale")
            pulse.fromValue = 1.0
            pulse.toValue = 1.025
            pulse.duration = 1.2
            pulse.autoreverses = true
            pulse.repeatCount = .infinity
            pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            logoImageView.layer.add(pulse, forKey: "logo.pulse")
        }

        // MARK: - Sparkles (Elegant particles behind logo)

        private func addSparklesBehindLogo() {
            // Remove old
            sparkleLayer?.removeFromSuperlayer()

            let emitter = CAEmitterLayer()
            emitter.emitterShape = .circle
            emitter.renderMode = .additive

            // Put it behind the logo (above gradient, below logo)
            view.layer.insertSublayer(emitter, above: gradientLayer)
            sparkleLayer = emitter

            // Configure cells (very light sparkles)
            let cell = CAEmitterCell()
            cell.birthRate = 1.2                 // low = elegant
            cell.lifetime = 2.6
            cell.velocity = 18
            cell.velocityRange = 10
            cell.scale = 0.02
            cell.scaleRange = 0.02
            cell.alphaSpeed = -0.35
            cell.emissionRange = .pi * 2

            // Use a tiny circle image generated in code
            cell.contents = makeSparkleDotImage()?.cgImage
            cell.color = UIColor.white.withAlphaComponent(0.85).cgColor

            emitter.emitterCells = [cell]
            updateSparklesPosition()
        }

        private func updateSparklesPosition() {
            guard let emitter = sparkleLayer else { return }
            // Sparkles around logo center
            let centerInView = logoImageView.superview?.convert(logoImageView.center, to: view) ?? logoImageView.center
            emitter.emitterPosition = centerInView
            emitter.emitterSize = CGSize(width: 120, height: 120)
        }

        private func makeSparkleDotImage() -> UIImage? {
            let size = CGSize(width: 10, height: 10)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            defer { UIGraphicsEndImageContext() }

            let ctx = UIGraphicsGetCurrentContext()
            let rect = CGRect(origin: .zero, size: size)
            ctx?.setFillColor(UIColor.white.cgColor)
            ctx?.fillEllipse(in: rect)

            return UIGraphicsGetImageFromCurrentImageContext()
        }

        // MARK: - Loading Dots
        private func startLoadingDots() {
            dotCount = 0
            loadingTimer?.invalidate()

            loadingTimer = Timer.scheduledTimer(withTimeInterval: 0.33, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.dotCount = (self.dotCount + 1) % 4
                self.loadingLabel.text = "Loading" + String(repeating: ".", count: self.dotCount)
            }
        }

        private func stopLoadingDots() {
            loadingTimer?.invalidate()
            loadingTimer = nil
            activity.stopAnimating()
        }

        // MARK: - Navigation
    private func goToAuth() {
        stopLoadingDots()

        // Clean up layers
        sparkleLayer?.removeFromSuperlayer()
        sparkleLayer = nil

        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let authVC = storyboard.instantiateInitialViewController()!

        let window = (view.window ?? UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first)

        guard let window else { return }

        // ✅ Prevent any black fallback color
        let beige = UIColor(named: "BeigeCol") ?? UIColor.systemBackground
        window.backgroundColor = beige

        // ✅ Ensure auth view is ready and starts hidden (we will fade it IN)
        _ = authVC.view
        authVC.view.frame = window.bounds
        authVC.view.backgroundColor = beige
        authVC.view.alpha = 0
        authVC.view.layoutIfNeeded()

        // ✅ Snapshot of splash stays visible while we swap roots
        let snapshot = view.snapshotView(afterScreenUpdates: true) ?? UIView()
        snapshot.frame = window.bounds
        snapshot.alpha = 1

        // Put snapshot on top of window
        window.addSubview(snapshot)

        // ✅ Switch root immediately (auth is behind snapshot)
        window.rootViewController = authVC
        window.makeKeyAndVisible()

        // ✅ Crossfade: splash snapshot OUT while auth IN (no black in between)
        UIView.animate(withDuration: 0.55, delay: 0, options: [.curveEaseInOut], animations: {
            snapshot.alpha = 0
            authVC.view.alpha = 1
            snapshot.transform = CGAffineTransform(scaleX: 1.02, y: 1.02) // subtle premium push
        }, completion: { _ in
            snapshot.removeFromSuperview()
        })
    }


    }

    // MARK: - UIWindowScene helper (stays in this file only)
    private extension UIWindowScene {
        var keyWindow: UIWindow? {
            return windows.first(where: { $0.isKeyWindow })
        }
    }


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
        //@IBOutlet weak var loadingLabel: UILabel!



        // MARK: - Layers
        private var gradientLayer: CAGradientLayer?
        private var sparkleLayer: CAEmitterLayer?

        // MARK: - Modern Loader (3 bars wave)
        private let loaderStack = UIStackView()
        private var loaderBars: [UIView] = []

        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()

            addGradientBackground()
            animateGradientBackground()

            styleLogo()
            setupModernLoaderBars()

            setupInitialState()
            animateSplash()

            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                self?.goToAuth()
            }
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            gradientLayer?.frame = view.bounds
            updateSparklesPosition()
        }

        deinit {
            stopModernLoaderBars()
        }

        // MARK: - UI Enhancements

    private func addGradientBackground() {
        let g = CAGradientLayer()
        g.startPoint = CGPoint(x: 0, y: 0)
        g.endPoint   = CGPoint(x: 1, y: 1)
        g.locations  = [0.0, 0.5, 1.0]
        g.frame = view.bounds

        view.layer.insertSublayer(g, at: 0)
        gradientLayer = g

        applyThemeForCurrentStyle()
    }


    private func applyThemeForCurrentStyle() {
        let beige = UIColor(named: "BeigeCol") ?? UIColor.systemBackground
        let green = UIColor(named: "greenCol") ?? UIColor.systemGreen

        // ✅ Beige in both light & dark (dynamic from Assets)
        gradientLayer?.colors = [
            beige.cgColor,
            beige.withAlphaComponent(0.96).cgColor,
            beige.cgColor
        ]

        // ✅ Shadow tuned for mode (no black blob)
        if traitCollection.userInterfaceStyle == .dark {
            logoImageView.layer.shadowColor = green.withAlphaComponent(0.35).cgColor
            logoImageView.layer.shadowOpacity = 0.22
            logoImageView.layer.shadowRadius = 18
            logoImageView.layer.shadowOffset = CGSize(width: 0, height: 10)
        } else {
            logoImageView.layer.shadowColor = UIColor.black.cgColor
            logoImageView.layer.shadowOpacity = 0.18
            logoImageView.layer.shadowRadius = 14
            logoImageView.layer.shadowOffset = CGSize(width: 0, height: 8)
        }
    }


    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            applyThemeForCurrentStyle()
        }
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
            logoImageView.layer.masksToBounds = false
        }

        // MARK: - Initial State
        private func setupInitialState() {
            logoImageView.alpha = 0
            logoImageView.transform = CGAffineTransform(translationX: 0, y: 26).scaledBy(x: 0.98, y: 0.98)

            titleLabel.alpha = 0
            titleLabel.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)

            loaderStack.alpha = 0
            stopModernLoaderBars()
        }

        // MARK: - Animations
        private func animateSplash() {
            let reduceMotion = UIAccessibility.isReduceMotionEnabled

            // 1) Logo reveal
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
                }
            )

            // 3) Modern loader bars only (clean)
            UIView.animate(
                withDuration: reduceMotion ? 0.2 : 0.55,
                delay: 0.68,
                options: [.curveEaseOut],
                animations: {
                    self.loaderStack.alpha = 1
                },
                completion: { _ in
                    self.startModernLoaderBars()
                }
            )
        }

        /// Subtle float + tiny pulse
        private func startFloatingLogo() {
            guard UIAccessibility.isReduceMotionEnabled == false else { return }

            let float = CAKeyframeAnimation(keyPath: "transform.translation.y")
            float.values = [0, -6, 0, 4, 0]
            float.keyTimes = [0, 0.25, 0.55, 0.8, 1.0]
            float.duration = 2.8
            float.repeatCount = .infinity
            float.timingFunctions = Array(repeating: CAMediaTimingFunction(name: .easeInEaseOut), count: 4)
            logoImageView.layer.add(float, forKey: "logo.float")

            let pulse = CABasicAnimation(keyPath: "transform.scale")
            pulse.fromValue = 1.0
            pulse.toValue = 1.025
            pulse.duration = 1.2
            pulse.autoreverses = true
            pulse.repeatCount = .infinity
            pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            logoImageView.layer.add(pulse, forKey: "logo.pulse")
        }

        // MARK: - Sparkles (light, elegant)

        private func addSparklesBehindLogo() {
            sparkleLayer?.removeFromSuperlayer()

            let emitter = CAEmitterLayer()
            emitter.emitterShape = .circle
            emitter.renderMode = .additive

            view.layer.insertSublayer(emitter, above: gradientLayer)
            sparkleLayer = emitter

            let cell = CAEmitterCell()
            cell.birthRate = 1.0
            cell.lifetime = 2.4
            cell.velocity = 16
            cell.velocityRange = 10
            cell.scale = 0.02
            cell.scaleRange = 0.02
            cell.alphaSpeed = -0.35
            cell.emissionRange = .pi * 2
            cell.contents = makeSparkleDotImage()?.cgImage
            cell.color = UIColor.white.withAlphaComponent(0.85).cgColor

            emitter.emitterCells = [cell]
            updateSparklesPosition()
        }

        private func updateSparklesPosition() {
            guard let emitter = sparkleLayer else { return }
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

        // MARK: - Modern Loader Bars (clean)

        private func setupModernLoaderBars() {
            loaderStack.axis = .horizontal
            loaderStack.alignment = .center
            loaderStack.distribution = .equalSpacing
            loaderStack.spacing = 6
            loaderStack.translatesAutoresizingMaskIntoConstraints = false

            let green = UIColor(named: "greenCol") ?? UIColor.systemGreen

            // Create 3 bars
            loaderBars = (0..<3).map { _ in
                let v = UIView()
                v.translatesAutoresizingMaskIntoConstraints = false
                v.layer.cornerRadius = 3
                v.backgroundColor = green.withAlphaComponent(0.85)
                NSLayoutConstraint.activate([
                    v.widthAnchor.constraint(equalToConstant: 6),
                    v.heightAnchor.constraint(equalToConstant: 12)
                ])
                return v
            }

            loaderBars.forEach { loaderStack.addArrangedSubview($0) }
            view.addSubview(loaderStack)

            // ✅ Now that loadingLabel is deleted, pin loader under titleLabel
            NSLayoutConstraint.activate([
                loaderStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
                loaderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }

        private func startModernLoaderBars() {
            guard UIAccessibility.isReduceMotionEnabled == false else { return }

            for (i, bar) in loaderBars.enumerated() {
                let anim = CABasicAnimation(keyPath: "transform.scale.y")
                anim.fromValue = 1.0
                anim.toValue = 1.8
                anim.duration = 0.55
                anim.autoreverses = true
                anim.repeatCount = .infinity
                anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                anim.beginTime = CACurrentMediaTime() + (Double(i) * 0.12) // wave delay
                bar.layer.add(anim, forKey: "barWave")
            }
        }

        private func stopModernLoaderBars() {
            loaderBars.forEach { $0.layer.removeAnimation(forKey: "barWave") }
        }

        // MARK: - Navigation (Crossfade with NO black screen)

        private func goToAuth() {
            stopModernLoaderBars()

            sparkleLayer?.removeFromSuperlayer()
            sparkleLayer = nil

            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            let authVC = storyboard.instantiateInitialViewController()!

            let window = (view.window ?? UIApplication.shared
                .connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .first)

            guard let window else { return }

            // Prevent any black fallback
            let beige = UIColor(named: "BeigeCol") ?? UIColor.systemBackground
            window.backgroundColor = beige

            // Prepare auth view (fade IN)
            _ = authVC.view
            authVC.view.frame = window.bounds
            authVC.view.backgroundColor = beige
            authVC.view.alpha = 0
            authVC.view.layoutIfNeeded()

            // Snapshot splash stays visible while swapping roots
            let snapshot = view.snapshotView(afterScreenUpdates: true) ?? UIView()
            snapshot.frame = window.bounds
            snapshot.alpha = 1
            window.addSubview(snapshot)

            // Swap root behind snapshot
            window.rootViewController = authVC
            window.makeKeyAndVisible()

            // Crossfade: snapshot OUT + auth IN
            UIView.animate(withDuration: 0.55, delay: 0, options: [.curveEaseInOut], animations: {
                snapshot.alpha = 0
                authVC.view.alpha = 1
                snapshot.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        }
    }

    // MARK: - UIWindowScene helper (stays in this file only)
    private extension UIWindowScene {
        var keyWindow: UIWindow? { windows.first(where: { $0.isKeyWindow }) }
    }

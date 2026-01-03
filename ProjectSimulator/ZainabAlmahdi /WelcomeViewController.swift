//
//  WelcomeViewController.swift
//  ProjectSimulator
//
//  Created by BP-36-201-02 on 18/12/2025.

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleActionButton(loginButton)
        styleActionButton(signupButton)
    }

    @IBAction func LoginButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    @IBAction func SignupButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignup", sender: self)
    }
    
    private func styleActionButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
    }
}



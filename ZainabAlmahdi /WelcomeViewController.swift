//
//  WelcomeViewController.swift
//  ProjectSimulator
//
//  Created by BP-36-201-02 on 18/12/2025.
//

import UIKit

class WelcomeViewController: UIViewController {

override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
}
    @IBAction func LoginButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    @IBAction func SignupButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToSignup", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

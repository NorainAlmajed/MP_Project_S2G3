//
//  RoleSelectionViewController.swift
//  ProjectSimulator
//
//  Created by BP-36-201-02 on 20/12/2025.
//

import UIKit

class RoleSelectionViewController: UIViewController {
    @IBAction func donorSignupTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToDonorSignup", sender: self)
    }
    @IBAction func ngoSignupTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToNGOSignup", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

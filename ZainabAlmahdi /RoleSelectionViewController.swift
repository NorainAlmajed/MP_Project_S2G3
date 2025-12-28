//
//  RoleSelectionViewController.swift
//  ProjectSimulator
//
//  Created by BP-36-201-02 on 20/12/2025.
//

import UIKit

class RoleSelectionViewController: UIViewController {
    
    
    @IBOutlet weak var donorSignup: UIButton!
    @IBOutlet weak var ngoSignup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleActionButton(donorSignup)
        styleActionButton(ngoSignup)

    }
    
    private func styleActionButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
    }
   
    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

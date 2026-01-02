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
        navigationItem.title = "Select your role"

    }
    
    private func styleActionButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
    }

}

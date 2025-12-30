//
//  RejectionPopupViewController.swift
//  ProjectSimulator
//
//  Created by Norain  on 26/12/2025.
//

import UIKit

protocol RejectionDelegate: AnyObject {
    func didProvideReason(_ reason: String)
}

class RejectionPopupViewController: UIViewController {

    
    @IBOutlet weak var reasonTextField: UITextField!
    weak var delegate: RejectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reasonTextField.layer.borderWidth = 1
        reasonTextField.layer.borderColor = UIColor.lightGray.cgColor
        reasonTextField.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    

    @IBAction func submitTapped(_ sender: Any) {
        let reason = reasonTextField.text ?? ""
                delegate?.didProvideReason(reason)
                self.dismiss(animated: true)
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

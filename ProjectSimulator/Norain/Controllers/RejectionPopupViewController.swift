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

    @IBOutlet weak var reasonTextView: UITextView!
    weak var delegate: RejectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reasonTextView.layer.borderWidth = 1
        reasonTextView.layer.borderColor = UIColor.lightGray.cgColor
        reasonTextView.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    

    @IBAction func submitTapped(_ sender: Any) {
        let reason = reasonTextView.text ?? ""
                delegate?.didProvideReason(reason)
                self.dismiss(animated: true)
    }
    
    
    @IBAction func doneTapped(_ sender: Any) {
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

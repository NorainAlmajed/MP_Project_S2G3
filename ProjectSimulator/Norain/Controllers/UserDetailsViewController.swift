//
//  DetailsViewController.swift
//  ProjectSimulator
//
//  Created by Norain  on 21/12/2025.
//

import UIKit

protocol UserUpdateDelegate: AnyObject {
    func didUpdateUser()
}

class UserDetailsViewController: UIViewController {
    var currentUser: AppUser?
    weak var delegate: UserUpdateDelegate?
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var bioOrDescLbl: UILabel!
    
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var bioOrDesctxt: UITextView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var userImgV: UIImageView!
    @IBOutlet weak var phoneOrStatusLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = currentUser {
                    configure(appUser: user)
                }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configure(appUser:AppUser){

        
        guard isViewLoaded else { return }
        self.currentUser = appUser
        
        nameLbl.text = appUser.name
        emailLbl.text = appUser.email
        
        if !appUser.userImg.isEmpty {
                AppData.fetchImage(from: appUser.userImg) { [weak self] downloadedImage in
                    self?.userImgV.image = downloadedImage
                }
            } else {
                self.userImgV.image = UIImage(systemName: "person.circle.fill")
            }
        if let donor = appUser as? Donor{
            phoneOrStatusLbl.text = donor.phoneNumber.description
            bioOrDescLbl.text = "Bio"
            bioOrDesctxt.text = donor.bio
            acceptBtn.isHidden = true
            rejectBtn.isHidden = true
            reasonLabel.isHidden = true
            
        }else if let ngo = appUser as? NGO{
            bioOrDescLbl.text = "Mission"
            bioOrDesctxt.text = ngo.mission
            if (ngo.status == .pending){
                phoneOrStatusLbl.text = "Pending"
                phoneOrStatusLbl.textColor = .orangeCol
                reasonLabel.isHidden = true

            }
            else if (ngo.status == .rejected)
            {
                phoneOrStatusLbl.text = "Rejected"
                phoneOrStatusLbl.textColor = .redCol
                reasonLabel.text = "Reason: \(ngo.rejectionReason ?? "None")"
                reasonLabel.isHidden = false
                
                acceptBtn.isHidden = true
                rejectBtn.isHidden = true
            }
            else{
                phoneOrStatusLbl.text = "Approved"
                phoneOrStatusLbl.textColor = .greenCol
                reasonLabel.isHidden = true
                acceptBtn.isHidden = true
                rejectBtn.isHidden = true
                

            }
        }
        
        
    }
    //FIX CODE LATER (SUPER IMPORTANT)
    @IBAction func acceptBtn(_ sender: Any) {
        if let ngo = currentUser as? NGO
        {
            ngo.status = .approved
            self.configure(appUser: ngo)
            delegate?.didUpdateUser()
                    
        }
      }
      @IBAction func rejectBtn(_ sender: Any) {
          Alerts.confirmation(on: self, title: "NGO Rejction", message: "Are You Sure you want to Reject this NGO?") {
              if let ngo = self.currentUser as? NGO{
                  ngo.status = .rejected

                  self.configure(appUser: ngo)
                  self.showRejectionPopup()
              }
          }


      }
      
    @IBAction func editBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "norain-admin-controls1", bundle: nil)
        
        guard let editVC = storyboard.instantiateViewController(withIdentifier: "EditUsersViewController") as? EditUsersViewController else { return }

        // 1. Double check what we are passing
        if let user = self.currentUser {
            print("Passing user: \(user.name) of type: \(type(of: user))")
            editVC.userToEdit = user
        }
        
        // 2. Wrap and present
        let nav = UINavigationController(rootViewController: editVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
  
    
    func showRejectionPopup() {
        let storyboard = UIStoryboard(name: "norain-admin-controls1", bundle: nil)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: "RejectionPopupViewController") as? RejectionPopupViewController {
            
            // This is the "handshake" that connects the two screens
            popupVC.delegate = self
            
            popupVC.modalPresentationStyle = .overCurrentContext
            self.present(popupVC, animated: true)
        }
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
extension UserDetailsViewController: RejectionDelegate {
    func didProvideReason(_ reason: String) {
        if let ngo = self.currentUser as? NGO {
            ngo.status = .rejected
            ngo.rejectionReason = reason
            
            // Refresh the UI to show "Rejected" status
            self.configure(appUser: ngo)
            
            // Sync with the main table view
            delegate?.didUpdateUser()
        }
    }
}

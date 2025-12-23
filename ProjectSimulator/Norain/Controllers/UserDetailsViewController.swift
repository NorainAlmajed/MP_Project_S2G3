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
            
        }else if let ngo = appUser as? NGO{
            bioOrDescLbl.text = "Mission"
            bioOrDesctxt.text = ngo.mission
            if (ngo.isPending){
                phoneOrStatusLbl.text = "Pending"
                phoneOrStatusLbl.textColor = .orangeCol

            }
            else if (ngo.isRejected)
            {
                phoneOrStatusLbl.text = "Rejected"
                phoneOrStatusLbl.textColor = .redCol
                
                acceptBtn.isHidden = true
                rejectBtn.isHidden = true
            }
            else{
                phoneOrStatusLbl.text = "Approved"
                phoneOrStatusLbl.textColor = .greenCol
                
                acceptBtn.isHidden = true
                rejectBtn.isHidden = true
            }
        }
        
        
    }
    //FIX CODE LATER (SUPER IMPORTANT)
    @IBAction func acceptBtn(_ sender: Any) {
        if let ngo = currentUser as? NGO
        {
            ngo.isPending = false
            ngo.isApproved = true
            ngo.isRejected = false
            self.configure(appUser: ngo)
            delegate?.didUpdateUser()
                    
        }
      }
      @IBAction func rejectBtn(_ sender: Any) {
          Alerts.confirmation(on: self, title: "NGO Rejction", message: "Are You Sure you want to Reject this NGO?") {
              if let ngo = self.currentUser as? NGO{
                  ngo.isPending = false
                  ngo.isApproved = false
                  ngo.isRejected = true
                  self.configure(appUser: ngo)
              }
          }


      }
      
      @IBAction func editBtn(_ sender: Any) {
          if let editVC = storyboard?.instantiateViewController(withIdentifier: "EditUsersViewController") as? EditUsersViewController {
                      editVC.modalPresentationStyle = .fullScreen
                      editVC.userToEdit = self.currentUser
                      self.navigationController?.pushViewController(editVC, animated: true)
                  }      }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

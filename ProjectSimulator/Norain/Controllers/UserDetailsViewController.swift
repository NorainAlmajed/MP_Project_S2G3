//
//  DetailsViewController.swift
//  ProjectSimulator
//
//  Created by Norain  on 21/12/2025.
//

import UIKit

class UserDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneOrStatusLbl: UILabel!
    @IBOutlet weak var bioOrDescLbl: UILabel!
    @IBOutlet weak var bioOrDesctxt: UITextView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    

    
    
    
    func configure(appUser:AppUser){
        nameLbl.text = appUser.name
        emailLbl.text = appUser.email
        
        if let donor = appUser as? Donor{
            phoneOrStatusLbl.text = donor.phoneNumber.description
            bioOrDescLbl.text = "Bio"
            //bioOrDesctxt.text = donor.bio
            acceptBtn.isHidden = true
            rejectBtn.isHidden = true
            
        }else if let ngo = appUser as? NGO{
            bioOrDescLbl.text = "Mission"
            //bioOrDesctxt.text = ngo.bio
            if (ngo.IsPending){
                phoneOrStatusLbl.text = "Pending"
                phoneOrStatusLbl.textColor = .orangeCol

            }
            else if (ngo.IsRejected)
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
        //ngo.IsPending = False
        //ngo.IsApproved = True
        //ngo.IsRejected = False
      }
      @IBAction func rejectBtn(_ sender: Any) {
          //ngo.IsPending = False
          //ngo.IsApproved = False
          //ngo.IsRejected = True
      }
      
      @IBAction func editBtn(_ sender: Any) {
          //showDetailViewController(EditUsersViewController, sender: self)
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

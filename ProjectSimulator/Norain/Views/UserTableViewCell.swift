//
//  UserTableViewCell.swift
//  ProjectSimulator
//
//  Created by Norain  on 18/12/2025.
//

import UIKit

class UserTableViewCell: UITableViewCell {


    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneOrStatusLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    func configure(appUser:AppUser){
        nameLbl.text = appUser.name
        emailLbl.text = appUser.email
        
        
        if let donor = appUser as? Donor{
            phoneOrStatusLbl.text = "Phone Number: "
            phoneOrStatusLbl.text = donor.phoneNumber.description
        }else if let ngo = appUser as? NGO{
            
            if (ngo.IsPending){
                phoneOrStatusLbl.text = "Pending"
                phoneOrStatusLbl.textColor = .orangeCol
                
            }
            else if (ngo.IsRejected)
            {
                phoneOrStatusLbl.text = "Rejected"
                phoneOrStatusLbl.textColor = .redCol

            }
            else{
                phoneOrStatusLbl.text = "Approved"
                phoneOrStatusLbl.textColor = .greenCol

            }
        }
        
        
    }
    
}

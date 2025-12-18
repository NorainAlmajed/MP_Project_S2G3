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
        nameLbl.text = AppUser.name
        emailLbl.text = AppUser.email
        
        if let donor = appUser as? Donor{
            phoneOrStatusLbl.text = Donor.phoneNumber
        }else if let ngo = AppUser as? NGO{
            if (NGO.IsPending){
                phoneOrStatusLbl.text = "Pending"
            }
            else if (NGO.IsRejected)
            {
                phoneOrStatusLbl.text = "Rejected"
            }
            else{
                phoneOrStatusLbl.text = "Approved"
            }
        }
        
        
    }
    
}

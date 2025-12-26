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
    @IBOutlet weak var imgUserPhoto: UIImageView!
    
    @IBOutlet weak var statusLbl: UILabel!
    
    
    
    func configure(appUser:AppUser){
        nameLbl.text = appUser.name
        emailLbl.text = ("Email: " + appUser.email)
//        imgUserPhoto.image =
        
        if let donor = appUser as? Donor{

            statusLbl.text = ""
            phoneOrStatusLbl.text = ("Phone Number: " + donor.phoneNumber.description)

        }else if let ngo = appUser as? NGO{
            phoneOrStatusLbl.text = "Status: "
            if (ngo.status == .pending){
                statusLbl.text = "Pending"
                statusLbl.textColor = .orangeCol
                
            }
            else if (ngo.status == .rejected)
            {
                statusLbl.text = "Rejected"
                statusLbl.textColor = .redCol

            }
            else{
                statusLbl.text = "Approved"
                statusLbl.textColor = .greenCol

            }
        }
        
        
    }
    
}

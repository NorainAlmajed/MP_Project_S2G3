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
    
    private var currentImageURL: String?

    
    func configure(appUser:NorainAppUser){
        nameLbl.text = appUser.name
        emailLbl.text = ("Email: " + appUser.email)
        
        currentImageURL = appUser.userImg
        if !appUser.userImg.isEmpty {
            imgUserPhoto?.image = UIImage(systemName: "person.circle.fill") // placeholder
            
            FetchImage.fetchImage(from: appUser.userImg) { [weak self] image in
                // ✅ Only set the image if this cell is still showing the same user
                guard let self = self,
                      self.currentImageURL == appUser.userImg else {
                    return
                }
                
                self.imgUserPhoto?.image = image ?? UIImage(systemName: "person.circle.fill")
            }
        } else {
            imgUserPhoto?.image = UIImage(systemName: "person.circle.fill")
        }
        
        if let donor = appUser as? NorainDonor{

            statusLbl.text = ""
            phoneOrStatusLbl.text = ("Phone Number: " + donor.phoneNumber.description)

        }else if let ngo = appUser as? NorainNGO{
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
    override func prepareForReuse() {
        super.prepareForReuse()

        imgUserPhoto?.image = UIImage(systemName: "person.circle.fill")
        currentImageURL = nil
    }
    
}

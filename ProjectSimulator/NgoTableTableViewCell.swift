//
//  NgoTableTableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 11/12/2025.
//

import UIKit

class NgoTableTableViewCell: UITableViewCell {

    @IBOutlet weak var imgNgoPhotot: UIImageView!
    @IBOutlet weak var lblNgoName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func setupCell(photoUrl: String, name: String, category: String) {
        lblNgoName.text = name
        lblCategory.text = category

        // ✅ make system icon gray (not blue)
        imgNgoPhotot.tintColor = .systemGray3

        let placeholder = UIImage(systemName: "photo")?
            .withRenderingMode(.alwaysTemplate)

        imgNgoPhotot.setImageFromUrl(
            photoUrl,
            placeholder: placeholder
            
        )
        
        
        imgNgoPhotot.layer.cornerRadius = 7   // 🔵 change this value as you like
           imgNgoPhotot.clipsToBounds = true
    }



    override func prepareForReuse() {
        super.prepareForReuse()
        imgNgoPhotot.image = UIImage(named: "placeholder")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   

}

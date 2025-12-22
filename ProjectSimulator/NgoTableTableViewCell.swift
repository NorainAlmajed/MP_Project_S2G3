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

//    func setupCell(photo: UIImage, name:String, category: String){
//        
//        imgNgoPhotot.image = photo
//        lblNgoName.text = name
//        lblCategory.text = category
//        
//    }
    
    
    
    func setupCell(photoUrl: String, name: String, category: String) {

        lblNgoName.text = name
        lblCategory.text = category

        imgNgoPhotot.contentMode = .scaleAspectFit
        imgNgoPhotot.clipsToBounds = true

        // ✅ load from URL string
        imgNgoPhotot.setImageFromUrl(photoUrl, placeholder: UIImage(named: "placeholder"))
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

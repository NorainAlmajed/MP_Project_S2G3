//
//  RaghadNgoDetailsHeaderTableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 17/12/2025.
//
import UIKit
class RaghadNgoDetailsHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var lblNgoName: UILabel!
    @IBOutlet weak var lblNgoCategory: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        img_logo.layer.cornerRadius = 12
        img_logo.layer.borderWidth = 1
        img_logo.layer.borderColor = UIColor.systemGray4.cgColor
        img_logo.clipsToBounds = true
    }

//    func configure(ngo: NGO) {
//        lblNgoName.text = ngo.name
//        lblNgoCategory.text = ngo.category
//        img_logo.image = ngo.photo
//    }
    
    
//    func configure(ngo: NGO) {
//        lblNgoName.text = ngo.name
//        lblNgoCategory.text = ngo.category
//
//        img_logo.contentMode = .scaleAspectFit
//        img_logo.setImageFromUrl(ngo.photo, placeholder: UIImage(named: "placeholder"))
//    }

    func configure(ngo: NGO) {
        lblNgoName.text = ngo.name
        lblNgoCategory.text = ngo.category

        img_logo.contentMode = .scaleAspectFit
        img_logo.tintColor = .systemGray3

        let placeholder = UIImage(systemName: "photo")?
            .withRenderingMode(.alwaysTemplate)

        img_logo.setImageFromUrl(ngo.photo, placeholder: placeholder)
    }

    
    
}

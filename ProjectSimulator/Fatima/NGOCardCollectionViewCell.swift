import UIKit

class NGOCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ngoImageView: UIImageView!
    @IBOutlet weak var ngoNameLabel: UILabel!
    @IBOutlet weak var ngoTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        contentView.backgroundColor = UIColor(named: "BeigeCol")

        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true

        ngoImageView.contentMode = .scaleAspectFill
    }


    func configure(with ngo: NGO) {
        ngoNameLabel.text = ngo.organizationName
        ngoTypeLabel.text = ngo.cause

        // Image placeholder for now
        ngoImageView.image = UIImage(systemName: "building.2")

        // Later, when profile_image_url is available:
        // loadImage(from: ngo.profileImageURL)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = 16
        layer.masksToBounds = false
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)
    }

}

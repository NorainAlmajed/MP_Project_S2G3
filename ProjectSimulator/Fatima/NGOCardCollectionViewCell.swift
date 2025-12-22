import UIKit

class NGOCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ngoImageView: UIImageView!
    @IBOutlet weak var ngoNameLabel: UILabel!
    @IBOutlet weak var ngoTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        contentView.backgroundColor = .impactBeige

        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true

        ngoImageView.contentMode = .scaleAspectFill
    }


    func configure(with ngo: NGO) {
        ngoNameLabel.text = ngo.name
        ngoTypeLabel.text = ngo.type

        ngoImageView.image =
            UIImage(named: ngo.logoName)
            ?? UIImage(systemName: "building.2")
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

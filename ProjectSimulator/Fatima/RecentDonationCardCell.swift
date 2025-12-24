import UIKit

class RecentDonationCardCell: UICollectionViewCell {

    @IBOutlet weak var donationCardView: UIView!

    @IBOutlet weak var basketImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var donationIDLabel: UILabel!
    @IBOutlet weak var donorNamelabel: UILabel!
    @IBOutlet weak var donationTimeLabel: UILabel!

    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusColor: UIView!
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Card styling
        donationCardView.layer.cornerRadius = 20
        donationCardView.clipsToBounds = true

        // Status pill styling
        statusView.layer.cornerRadius = 12
        statusView.clipsToBounds = true
        statusColor.layer.cornerRadius = statusColor.frame.height / 2

        // Fixed basket image from Assets
        basketImage.image = UIImage(named: "basket")
        basketImage.contentMode = .scaleAspectFit
    }

    // MARK: - Configure
    func configure(with donation: Donation1) {

        categoryLabel.text = donation.category
        donationIDLabel.text = "Donation #\(donation.donationID)"
        donorNamelabel.text = donation.donorDisplayName
        donationTimeLabel.text = donation.formattedDate

        switch donation.status {
        case 1:
            statusLabel.text = "Pending"
            statusColor.backgroundColor = .systemOrange
        case 2:
            statusLabel.text = "Accepted"
            statusColor.backgroundColor = .systemGreen
        case 3:
            statusLabel.text = "Collected"
            statusColor.backgroundColor = .systemBlue
        case 4:
            statusLabel.text = "Rejected"
            statusColor.backgroundColor = .systemRed
        case 5:
            statusLabel.text = "Cancelled"
            statusColor.backgroundColor = .systemGray
        default:
            statusLabel.text = "Unknown"
            statusColor.backgroundColor = .systemGray2
        }
    }
}

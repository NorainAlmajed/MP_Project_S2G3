import UIKit

class RecentDonationCardCell: UICollectionViewCell {

    // MARK: - Outlets
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

        // Disable autoresizing masks
        contentView.translatesAutoresizingMaskIntoConstraints = false
        donationCardView.translatesAutoresizingMaskIntoConstraints = false

        // Pin contentView to cell
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Pin card view
        NSLayoutConstraint.activate([
            donationCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            donationCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            donationCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            donationCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        // Styling
        donationCardView.layer.cornerRadius = 20
        donationCardView.backgroundColor = .secondarySystemBackground
        donationCardView.clipsToBounds = true

        statusView.layer.cornerRadius = 12
        statusView.clipsToBounds = true

        basketImage.image = UIImage(named: "basket")
        basketImage.contentMode = .scaleAspectFit
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        statusColor.layer.cornerRadius = statusColor.bounds.height / 2
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

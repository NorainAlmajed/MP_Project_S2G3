import UIKit

class RecentDonationCardCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var donationCardView: UIView!
    @IBOutlet weak var basketImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var donationIDLabel: UILabel!
   // @IBOutlet weak var donorNamelabel: UILabel!
    @IBOutlet weak var donationTimeLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusColor: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    //private let textStack = UIStackView()

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
        statusView.backgroundColor = UIColor.white
        statusView.layer.cornerRadius = 12
        statusView.clipsToBounds = true
        //textStack.axis = .vertical
        //textStack.spacing = 6
        //textStack.translatesAutoresizingMaskIntoConstraints = false

        //textStack.addArrangedSubview(categoryLabel)
        //textStack.addArrangedSubview(donationIDLabel)
        //textStack.addArrangedSubview(donationTimeLabel)

        //donationCardView.addSubview(textStack)
        categoryLabel.numberOfLines = 2
        categoryLabel.lineBreakMode = .byTruncatingTail

        // Pin card view
        NSLayoutConstraint.activate([
            donationCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            donationCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            donationCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            donationCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        donationCardView.layer.shadowColor = UIColor.black.cgColor
        donationCardView.layer.shadowOpacity = 0.08
        donationCardView.layer.shadowRadius = 8
        donationCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        donationCardView.layer.masksToBounds = false
        // this to set the label font and color inside the card
        //
        categoryLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        donationIDLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        //donorNamelabel.font = .systemFont(ofSize: 14, weight: .medium)
        //donorNamelabel.textColor = .secondaryLabel

        donationTimeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        // greyCol
        donationTimeLabel.textColor = .black

        // Styling
        donationCardView.layer.cornerRadius = 20
        donationCardView.backgroundColor =  UIColor(named: "BeigeCol")
        donationCardView.clipsToBounds = true

        statusView.layer.cornerRadius = 12
        statusView.clipsToBounds = true
        
        // constraints and setting the size of the basket image
        //basketImage.translatesAutoresizingMaskIntoConstraints = false

        basketImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            basketImage.leadingAnchor.constraint(equalTo: donationCardView.leadingAnchor, constant: 16),
            basketImage.centerYAnchor.constraint(equalTo: donationCardView.centerYAnchor),
            
            basketImage.widthAnchor.constraint(equalToConstant: 75),
            basketImage.heightAnchor.constraint(equalToConstant: 75)
        ])
        basketImage.layer.cornerRadius = 37.5 // half of 75
        basketImage.clipsToBounds = true
        basketImage.image = UIImage(named: "basket")
        basketImage.contentMode = .scaleAspectFill

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        statusColor.layer.cornerRadius = statusColor.bounds.height / 2
    }

    // MARK: - Configure
    func configure(with donation: Donation1) {
        categoryLabel.text = donation.category
        donationIDLabel.text = "Donation #\(donation.donationID)"
       //donorNamelabel.text = donation.donorDisplayName
        donationTimeLabel.text = donation.formattedDate

        switch donation.status {
        case 1:
            statusLabel.text = "Pending"
            statusColor.backgroundColor = UIColor(named: "orangeCol")
        case 2:
            statusLabel.text = "Accepted"
            statusColor.backgroundColor = UIColor(named: "greenCol")
        case 3:
            statusLabel.text = "Collected"
            statusColor.backgroundColor = UIColor(named: "blueCol")
        case 4:
            statusLabel.text = "Rejected"
            statusColor.backgroundColor = UIColor(named: "redCol")
        case 5:
            statusLabel.text = "Cancelled"
            statusColor.backgroundColor = UIColor(named: "greyCol")
        default:
            statusLabel.text = "Unknown"
            statusColor.backgroundColor = .lightGray
        }
    }
}

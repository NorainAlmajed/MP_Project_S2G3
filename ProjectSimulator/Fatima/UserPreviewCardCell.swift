import UIKit

class UserPreviewCardCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusColorView: UIView!
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.translatesAutoresizingMaskIntoConstraints = false
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        // Pin contentView
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Pin card
        NSLayoutConstraint.activate([
            cardContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        // Card styling
        cardContainerView.layer.cornerRadius = 20
        cardContainerView.backgroundColor = UIColor(named: "BeigeCol")
        cardContainerView.layer.shadowColor = UIColor.black.cgColor
        cardContainerView.layer.shadowOpacity = 0.09
        cardContainerView.layer.shadowRadius = 8
        cardContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardContainerView.layer.masksToBounds = false

        // Image constraints
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: cardContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 70),
            iconImageView.heightAnchor.constraint(equalToConstant: 70)
        ])

        // Circular image
        iconImageView.layer.cornerRadius = 35
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill

        // Status pill styling
        statusView.backgroundColor = .white
        statusView.layer.cornerRadius = 12
        statusView.clipsToBounds = true

        // Typography polish
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        numberLabel.font = .systemFont(ofSize: 14, weight: .medium)
        emailLabel.font = .systemFont(ofSize: 14, weight: .regular)

        numberLabel.textColor = .black
        emailLabel.textColor = .black

        // ⭐️ KEY FIX: prevent overlap with status pill
        nameLabel.trailingAnchor.constraint(
            lessThanOrEqualTo: statusView.leadingAnchor,
            constant: -8
        ).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        statusColorView.layer.cornerRadius = statusColorView.bounds.height / 2
    }

    // MARK: - Configure
    func configure(with user: userFatima) {

        nameLabel.text = user.name
        numberLabel.text = user.phone
        emailLabel.text = user.email
        statusLabel.text = user.statusText

        switch user.statusText {
        case "NGO":
            statusColorView.backgroundColor = .systemGreen
        case "Donor":
            statusColorView.backgroundColor = .systemBlue
        case "Admin":
            statusColorView.backgroundColor = .systemPurple
        default:
            statusColorView.backgroundColor = .systemGray
        }

        iconImageView.image = UIImage(systemName: "person.circle.fill")

        if !user.imageURL.isEmpty,
           let url = URL(string: user.imageURL) {
            FetchImage.fetchImage(from: url.absoluteString) { [weak self] image in
                DispatchQueue.main.async {
                    if let image = image {
                        self?.iconImageView.image = image
                    }
                }
            }
        }
    }
}

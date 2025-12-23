import UIKit

class RecentDonationTableViewCell: UITableViewCell {

    private let container = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let statusLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 16

        titleLabel.font = .boldSystemFont(ofSize: 16)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        statusLabel.font = .systemFont(ofSize: 13)

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, statusLabel])
        stack.axis = .vertical
        stack.spacing = 6

        container.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(container)
        container.addSubview(stack)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
        ])
    }

    func configure(with donation: Donation1) {
        titleLabel.text = donation.category
        subtitleLabel.text = "Donation #\(donation.donationID)"

        switch donation.status {
        case 1: statusLabel.text = "Pending"
        case 2: statusLabel.text = "Accepted"
        case 3: statusLabel.text = "Collected"
        case 4: statusLabel.text = "Rejected"
        case 5: statusLabel.text = "Cancelled"
        default: statusLabel.text = "Unknown"
        }
    }
}

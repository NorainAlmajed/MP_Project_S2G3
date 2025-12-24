import UIKit

class RecentDonationTableViewCell: UITableViewCell,
                                  UICollectionViewDelegate,
                                  UICollectionViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var recentDonationsCollectionView: UICollectionView!

    // MARK: - Empty State
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No donations made yet"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var donations: [Donation1] = []

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupEmptyStateLabel()
        setupCollectionView()
    }

    // MARK: - Setup
    private func setupEmptyStateLabel() {
        contentView.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emptyStateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }

    private func setupCollectionView() {
        recentDonationsCollectionView.delegate = self
        recentDonationsCollectionView.dataSource = self
        recentDonationsCollectionView.isHidden = true
    }

    // MARK: - Configure
    func configure(with donations: [Donation1]) {
        self.donations = Array(donations.prefix(3))

        let hasDonations = !self.donations.isEmpty
        recentDonationsCollectionView.isHidden = !hasDonations
        emptyStateLabel.isHidden = hasDonations

        recentDonationsCollectionView.reloadData()
    }

    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        donations.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RecentDonationCardCell",
            for: indexPath
        ) as! RecentDonationCardCell

        cell.configure(with: donations[indexPath.item])
        return cell
    }
}

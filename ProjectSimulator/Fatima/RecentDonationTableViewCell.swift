import UIKit

class RecentDonationTableViewCell: UITableViewCell,
                                  UICollectionViewDelegate,
                                  UICollectionViewDataSource {

    // MARK: - Outlet
    @IBOutlet weak var recentDonationsCollectionView: UICollectionView!

    @IBOutlet weak var recentDonationContent: UIView!
    // MARK: - Data
    private var donations: [Donation1] = []
    @IBOutlet weak var headerView: UILabel!
    
    // MARK: - Empty State
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No donations made yet"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        setupCollectionView()
        setupLayoutConstraints()
        setupEmptyState()
        print("🧪 recentDonationContent is nil:", recentDonationContent == nil)

    }

    // MARK: - Setup
    private func setupCollectionView() {
        recentDonationsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        recentDonationsCollectionView.delegate = self
        recentDonationsCollectionView.dataSource = self
        recentDonationsCollectionView.backgroundColor = .clear
        recentDonationsCollectionView.showsHorizontalScrollIndicator = false

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 385, height: 120)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

        recentDonationsCollectionView.collectionViewLayout = layout
    }

    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([

            // Header
            headerView.topAnchor.constraint(equalTo: recentDonationContent.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: recentDonationContent.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: recentDonationContent.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 36),

            // Collection view BELOW header
            recentDonationsCollectionView.topAnchor.constraint(
                equalTo: headerView.bottomAnchor,
                constant: 8
            ),
            recentDonationsCollectionView.leadingAnchor.constraint(
                equalTo: recentDonationContent.leadingAnchor
            ),
            recentDonationsCollectionView.trailingAnchor.constraint(
                equalTo: recentDonationContent.trailingAnchor
            ),
            recentDonationsCollectionView.bottomAnchor.constraint(
                equalTo: recentDonationContent.bottomAnchor
            )
        ])
    }

   

    private func setupEmptyState() {
        contentView.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emptyStateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }

    // MARK: - Configure
    func configure(with donations: [Donation1]) {
        self.donations = Array(donations.prefix(3))

        let hasData = !self.donations.isEmpty
        recentDonationsCollectionView.isHidden = !hasData
        emptyStateLabel.isHidden = hasData

        guard hasData else { return }

        DispatchQueue.main.async {
            self.recentDonationsCollectionView.reloadData()
            self.recentDonationsCollectionView.collectionViewLayout.invalidateLayout()
            self.layoutIfNeeded()
        }
        print("🧪 recentDonations:", donations.count)

    }

    // MARK: - Collection View DataSource
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return donations.count
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

import UIKit

class RecommendedNGOsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    //@IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerView: UIView!
    // MARK: - Data
    private var ngos: [NGO] = []

    // Callbacks
    var onSeeAllTapped: (() -> Void)?
    var onNGOSelected: ((NGO) -> Void)?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        setupCollectionView()
        setupTapGesture()
        setupLayoutConstraints()
    }

    // MARK: - Layout
    private func setupLayoutConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Header at top
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Collection view BELOW header
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // MARK: - Collection View Setup
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.itemSize = CGSize(width: 145, height: 160)

        collectionView.collectionViewLayout = layout
    }

    // MARK: - Header Tap
    private func setupTapGesture() {
        headerView.isUserInteractionEnabled = true
        headerView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(seeAllTapped))
        )
    }

    @objc private func seeAllTapped() {
        onSeeAllTapped?()
    }

    // MARK: - Data (Random + Limit)
    func configure(with ngos: [NGO]) {
        self.ngos = Array(ngos.shuffled().prefix(6))
        collectionView.reloadData()
    }
}

// MARK: - Collection View Delegates
extension RecommendedNGOsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        ngos.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "NGOCardCell",
            for: indexPath
        ) as! NGOCardCollectionViewCell

        cell.configure(with: ngos[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        onNGOSelected?(ngos[indexPath.item])
    }
}

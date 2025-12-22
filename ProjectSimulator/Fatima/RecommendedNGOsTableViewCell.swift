import UIKit

class RecommendedNGOsTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!

    private var ngos: [NGO] = []

    // Callbacks to the dashboard
    var onSeeAllTapped: (() -> Void)?
    var onNGOSelected: ((NGO) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        //contentView.backgroundColor = .impactBeige
        setupCollectionView()
        setupTapGesture()
    }


    // MARK: - Collection View Setup
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        // Make the whole scrolling area same beige
        //collectionView.backgroundColor = .impactBeige
        //contentView.backgroundColor = .impactBeige
        //backgroundColor = .impactBeige

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16

        // Padding left/right
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        layout.itemSize = CGSize(width: 145, height: 160)

        collectionView.collectionViewLayout = layout
    }


    // MARK: - Tap on "Recommended NGO's"
    private func setupTapGesture() {
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(seeAllTapped))
        )
    }

    @objc private func seeAllTapped() {
        onSeeAllTapped?()
    }

    // MARK: - Data
    func configure(with ngos: [NGO]) {
        self.ngos = ngos
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

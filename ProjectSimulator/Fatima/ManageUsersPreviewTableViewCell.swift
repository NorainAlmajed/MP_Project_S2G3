//
//  ManageUsersPreviewTableViewCell.swift
//  ProjectSimulator
//
//  Created by Ahmed on 12/30/25.
//

import UIKit
import FirebaseFirestore

class ManageUsersPreviewTableViewCell: UITableViewCell,
                                      UICollectionViewDelegate,
                                      UICollectionViewDataSource {

    // MARK: - Outlets (UNCHANGED)
    @IBOutlet weak var manageUserContent: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Firebase
    private let db = Firestore.firestore()
    var onHeaderTapped: (() -> Void)?
    var onUserSelected: ((userFatima) -> Void)?

    // MARK: - Data
    private var users: [userFatima] = []
    @objc private func headerTapped() {
        onHeaderTapped?()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.item]
        onUserSelected?(user)
    }

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        headerView.isUserInteractionEnabled = true
        headerView.addGestureRecognizer(tap)

        setupCollectionView()
        setupLayoutConstraints()
        fetchUsers()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Setup CollectionView (same as Recent Donations)
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 385, height: 120)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

        collectionView.collectionViewLayout = layout
    }

    // MARK: - Constraints (mirrors RecentDonationTableViewCell)
    private func setupLayoutConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            // Header
            headerView.topAnchor.constraint(equalTo: manageUserContent.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: manageUserContent.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: manageUserContent.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),

            // CollectionView below header
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: manageUserContent.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: manageUserContent.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: manageUserContent.bottomAnchor)
        ])
    }

    // MARK: - Firebase Fetch (REAL DATA)
    private func fetchUsers() {
        db.collection("users")
            .order(by: "created_at", descending: true)
            .limit(to: 3)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ Failed to fetch users:", error)
                    return
                }

                self.users = snapshot?.documents.compactMap { doc in
                    let data = doc.data()

                    let role = data["role"] as? Int ?? 0
                    let statusText: String = {
                        switch role {
                        case 3: return "NGO"
                        case 2: return "Donor"
                        case 1: return "Admin"
                        default: return "User"
                        }
                    }()

                    return userFatima(
                        id: doc.documentID,
                        name: data["full_name"] as? String ?? "Unknown",
                        phone: data["phone_number"] as? String
                            ?? data["number"] as? String
                            ?? "-",
                        email: data["email"] as? String ?? "-",
                        imageURL: data["profile_image_url"] as? String ?? "",
                        statusText: statusText
                    )
                } ?? []

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
    }

    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "UserPreviewCardCell",
            for: indexPath
        ) as! UserPreviewCardCell

        cell.configure(with: users[indexPath.item])
        return cell
    }
}

//
//  DonationViewController.swift
//  ProjectSimulator
//
//  Created by zahraa Hubail on 29/11/2025.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class DonationViewController: UIViewController {

    // Outlet connected to the collection view in the storyboard
    @IBOutlet weak var donationsCollectionView: UICollectionView!
    
    @IBOutlet weak var statusCollectionView: UICollectionView!
    

        var currentUserData: [String: Any]?
        let db = Firestore.firestore()

        let statuses = ["All", "Pending", "Accepted", "Collected", "Rejected", "Cancelled"]
        var selectedIndex = 0

        var allDonations: [Donation] = []
        var displayedDonations: [Donation] = []
        var allUsers: [User] = []

        private var searchBar: UISearchBar!
        private var filterButton: UIButton!
        private var searchHeaderView: UIView!

        private let noDonationsLabel: UILabel = {
            let label = UILabel()
            label.text = "No donations available"
            label.textAlignment = .center
            label.textColor = .gray
            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            label.isHidden = true
            return label
        }()

        override func viewDidLoad() {
            super.viewDidLoad()

            fetchCurrentUser { success in
                if success {
                    self.fetchDonations()
                } else {
                    self.updateNoDonationsLabel()
                }
            }

            displayedDonations = allDonations.sorted { $0.creationDate > $1.creationDate }

            title = "Donations"

            donationsCollectionView.dataSource = self
            donationsCollectionView.delegate = self
            statusCollectionView.dataSource = self
            statusCollectionView.delegate = self

            setupStatusCollectionLayout()
            setupNavigationBarAppearance()
            view.addSubview(noDonationsLabel)
            setupNoDonationsLabel()
            setupSearchHeaderUnderNavBar()
            setupDonationsCollectionLayout()
        }

        // MARK: - UI Setup

        private func setupStatusCollectionLayout() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 8
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            statusCollectionView.collectionViewLayout = layout
        }

        private func setupNavigationBarAppearance() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = view.backgroundColor
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
        }

        private func setupNoDonationsLabel() {
            noDonationsLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                noDonationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                noDonationsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }

        private func setupDonationsCollectionLayout() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 16
            let isIPad = UIDevice.current.userInterfaceIdiom == .pad
            layout.sectionInset = UIEdgeInsets(
                top: 12,
                left: isIPad ? 40 : 0,
                bottom: 12,
                right: isIPad ? 40 : 0
            )
            donationsCollectionView.collectionViewLayout = layout
        }

        // MARK: - Search Header

        private func setupSearchHeaderUnderNavBar() {
            searchHeaderView = UIView()
            searchHeaderView.translatesAutoresizingMaskIntoConstraints = false
            searchHeaderView.backgroundColor = .systemBackground

            searchBar = UISearchBar()
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            searchBar.placeholder = "Search donations..."
            searchBar.searchBarStyle = .minimal
            searchBar.autocapitalizationType = .none
            searchBar.autocorrectionType = .no
            searchBar.delegate = self

            filterButton = UIButton(type: .system)
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            filterButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
            filterButton.tintColor = .label
            filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)

            searchHeaderView.addSubview(searchBar)
            searchHeaderView.addSubview(filterButton)
            view.addSubview(searchHeaderView)

            NSLayoutConstraint.activate([
                searchHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                searchHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                searchHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                searchHeaderView.heightAnchor.constraint(equalToConstant: 56),

                searchBar.leadingAnchor.constraint(equalTo: searchHeaderView.leadingAnchor, constant: 8),
                searchBar.topAnchor.constraint(equalTo: searchHeaderView.topAnchor, constant: 8),
                searchBar.bottomAnchor.constraint(equalTo: searchHeaderView.bottomAnchor, constant: -8),

                filterButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 8),
                filterButton.trailingAnchor.constraint(equalTo: searchHeaderView.trailingAnchor, constant: -12),
                filterButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
                filterButton.widthAnchor.constraint(equalToConstant: 40),
                filterButton.heightAnchor.constraint(equalToConstant: 40)
            ])

            deactivateTopConstraints(of: statusCollectionView)
            statusCollectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                statusCollectionView.topAnchor.constraint(equalTo: searchHeaderView.bottomAnchor, constant: 6),
                statusCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                statusCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }

        private func deactivateTopConstraints(of view: UIView) {
            if let superview = view.superview {
                for c in superview.constraints {
                    let isTop =
                        (c.firstItem as? UIView) == view && c.firstAttribute == .top ||
                        (c.secondItem as? UIView) == view && c.secondAttribute == .top
                    if isTop { c.isActive = false }
                }
            }
            for c in view.constraints {
                let isTop = c.firstAttribute == .top || c.secondAttribute == .top
                if isTop { c.isActive = false }
            }
        }

        @objc private func filterButtonTapped() {
            // TODO
        }

        // MARK: - Label update

        private func updateNoDonationsLabel() {
            if displayedDonations.isEmpty {
                noDonationsLabel.isHidden = false
                donationsCollectionView.isHidden = true
            } else {
                noDonationsLabel.isHidden = true
                donationsCollectionView.isHidden = false
            }
        }

        private func updateNoDonationsLabelDuringSearch() {
            let isSearching = !((searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            if displayedDonations.isEmpty {
                noDonationsLabel.text = isSearching ? "No results found" : "No donations available"
                noDonationsLabel.isHidden = false
                donationsCollectionView.isHidden = true
            } else {
                noDonationsLabel.isHidden = true
                donationsCollectionView.isHidden = false
            }
        }

        // MARK: - Firebase

        func fetchCurrentUser(completion: @escaping (Bool) -> Void) {
            guard let currentUser = Auth.auth().currentUser else {
                print("No user is logged in")
                completion(false)
                return
            }

            let uid = currentUser.uid
            db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching current user: \(error)")
                    completion(false)
                    return
                }
                if let data = snapshot?.data() {
                    self?.currentUserData = data
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }

        func fetchDonations() {
            db.collection("donations").getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching donations: \(error)")
                    return
                }
                guard let documents = snapshot?.documents else { return }

                self.allDonations = documents.compactMap { doc in
                    let data = doc.data()
                    guard
                        let userID = data["userID"] as? String,
                        let donorID = data["donorID"] as? String,
                        let creationTimestamp = data["creationDate"] as? Timestamp,
                        let pickupTimestamp = data["pickupDate"] as? Timestamp,
                        let pickupTime = data["pickupTime"] as? String,
                        let foodImageUrl = data["foodImageUrl"] as? String,
                        let status = data["status"] as? Int,
                        let category = data["Category"] as? String,
                        let quantity = data["quantity"] as? Int,
                        let expiryTimestamp = data["expiryDate"] as? Timestamp,
                        let ngo = self.getUser(by: userID),
                        let donor = self.getUser(by: donorID)
                    else { return nil }

                    let addressData = data["address"] as? [String: Any] ?? [:]
                    let address = Address(
                        building: addressData["building"] as? Int ?? 0,
                        road: addressData["road"] as? Int ?? 0,
                        block: addressData["block"] as? Int ?? 0,
                        flat: addressData["flat"] as? Int,
                        area: addressData["area"] as? String ?? "",
                        governorate: addressData["governorate"] as? String ?? ""
                    )

                    return Donation(
                        donationID: Int(doc.documentID) ?? 0,
                        ngo: ngo,
                        creationDate: creationTimestamp.dateValue(),
                        donor: donor,
                        address: address,
                        pickupDate: pickupTimestamp.dateValue(),
                        pickupTime: pickupTime,
                        foodImageUrl: foodImageUrl,
                        status: status,
                        Category: category,
                        quantity: quantity,
                        weight: data["weight"] as? Double,
                        expiryDate: expiryTimestamp.dateValue(),
                        description: data["description"] as? String,
                        rejectionReason: data["rejectionReason"] as? String,
                        recurrence: data["recurrence"] as? Int ?? 0
                    )
                }

                self.displayedDonations = self.allDonations.sorted { $0.creationDate > $1.creationDate }
                self.donationsCollectionView.reloadData()
                self.updateNoDonationsLabel()
            }
        }

        func getUser(by id: String) -> User? {
            return allUsers.first { $0.username == id }
        }

        // MARK: - Lifecycle Overrides

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            title = "Donations"

            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = view.backgroundColor
            appearance.shadowColor = .clear
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance

            donationsCollectionView.reloadData()
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showDonationDetails",
               let detailsVC = segue.destination as? DonationDetailsViewController,
               let indexPath = donationsCollectionView.indexPathsForSelectedItems?.first {
                let donation = displayedDonations[indexPath.row]
                detailsVC.donation = donation
                detailsVC.hidesBottomBarWhenPushed = true
            }
        }
    }

    // MARK: - UISearchBarDelegate
    extension DonationViewController: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            filterDonations()
        }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

    // MARK: - Collection DataSource
    extension DonationViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return collectionView == statusCollectionView ? statuses.count : displayedDonations.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == statusCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusCell", for: indexPath) as! StatusCollectionViewCell
                cell.configure(title: statuses[indexPath.item], isSelected: indexPath.item == selectedIndex)
                cell.onStatusTapped = { [weak self] in
                    guard let self = self else { return }
                    self.selectedIndex = indexPath.item
                    self.filterDonations()
                    self.statusCollectionView.reloadData()
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DonationCollectionViewCell", for: indexPath) as! DonationCollectionViewCell
                let donation = displayedDonations[indexPath.row]
                cell.setup(with: donation)
                return cell
            }
        }
    }

    // MARK: - Collection Layout
    extension DonationViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView == statusCollectionView {
                return CGSize(width: 100, height: 36)
            }
            let isIPad = UIDevice.current.userInterfaceIdiom == .pad
            let width = collectionView.bounds.width - (isIPad ? 80 : 16)
            let height: CGFloat = isIPad ? 150 : 124
            return CGSize(width: width, height: height)
        }
    }

// MARK: - Filtering
extension DonationViewController {

    func filterDonations() {
        var filtered = allDonations

        // Filter by status
        if selectedIndex != 0 {
            filtered = filtered.filter { $0.status == selectedIndex }
        }

        // Filter by search text
        let searchText = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if !searchText.isEmpty {
            let text = searchText.lowercased()
            filtered = filtered.filter {
                $0.ngo.username.lowercased().contains(text) ||
                String($0.donationID).contains(text) ||
                $0.donor.username.lowercased().contains(text) ||
                $0.Category.lowercased().contains(text)
            }
        }

        displayedDonations = filtered.sorted { $0.creationDate > $1.creationDate }
        donationsCollectionView.reloadData()
        updateNoDonationsLabelDuringSearch()
    }
}


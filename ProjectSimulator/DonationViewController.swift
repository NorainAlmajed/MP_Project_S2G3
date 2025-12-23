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
    

        // MARK: - Properties
        var currentUser: User?
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

        // MARK: - View Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()

            fetchCurrentUser { success in
                guard success else {
                    self.updateNoDonationsLabel()
                    return
                }
                self.fetchAllUsers {
                    self.fetchDonations()
                }
            }

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
            // TODO: implement filter UI
        }

        // MARK: - Label Updates
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
        let tempUserID = "EApETXLDaQaG1Az0T9nbastpMtG2" // temporary user

        db.collection("users").document(tempUserID).getDocument { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching user: \(error)")
                completion(false)
                return
            }
            guard let data = snapshot?.data(),
                  let username = data["username"] as? String,
                  let role = data["role"] as? Int
            else {
                print("User data missing or invalid")
                completion(false)
                return
            }

            self?.currentUser = User(
                userID: tempUserID,
                fullName: data["fullName"] as? String,
                username: username,
                role: role,
                enableNotification: data["enableNotification"] as? Bool ?? true,
                profile_image_url: data["profile_image_url"] as? String,
                organization_name: data["organization_name"] as? String
            )

            completion(true)
        }
    }

    func fetchAllUsers(completion: @escaping () -> Void) {
        db.collection("users").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("❌ Error fetching users:", error)
                completion()
                return
            }

            guard let documents = snapshot?.documents else {
                print("❌ No user documents found")
                completion()
                return
            }

            self.allUsers = documents.compactMap { doc -> User? in
                let data = doc.data()
                guard let username = data["username"] as? String,
                      let role = data["role"] as? Int else { return nil }

                return User(
                    userID: doc.documentID,
                    fullName: data["fullName"] as? String,
                    username: username,
                    role: role,
                    enableNotification: data["enableNotification"] as? Bool ?? true,
                    profile_image_url: data["profile_image_url"] as? String,
                    organization_name: data["organization_name"] as? String
                )

            }

            print("Users loaded:", self.allUsers.count)
            completion()
        }
    }


    func fetchDonations() {
        guard let currentUser = currentUser else {
            print("Current user not set")
            return
        }

        var query: Query = db.collection("Donation")
        switch currentUser.role {
        case 1: break // Admin: fetch all donations
        case 2:
            query = query.whereField("donor", isEqualTo: db.collection("users").document(currentUser.userID))
        case 3:
            query = query.whereField("ngo", isEqualTo: db.collection("users").document(currentUser.userID))
        default:
            print("Unknown role")
            return
        }

        query.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching donations: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No donations found")
                return
            }

            self.allDonations.removeAll() // Clear previous data

            let group = DispatchGroup() // For async fetching of addresses

            for doc in documents {
                let data = doc.data()

                // Safely unwrap required fields
                guard
                    let ngoRef = data["ngo"] as? DocumentReference,
                    let donorRef = data["donor"] as? DocumentReference,
                    let creationTimestamp = data["creationDate"] as? Timestamp,
                    let pickupTimestamp = data["pickupDate"] as? Timestamp,
                    let pickupTime = data["pickupTime"] as? String,
                    let foodImageUrl = data["foodImageUrl"] as? String,
                    let status = data["status"] as? Int,
                    let category = data["Category"] as? String,
                    let quantity = data["quantity"] as? Int,
                    let expiryTimestamp = data["expiryDate"] as? Timestamp
                else {
                    print("Skipping donation document \(doc.documentID) due to missing fields")
                    continue
                }

                // Fetch users from cached list
                guard let ngo = self.getUser(by: ngoRef.documentID),
                      let donor = self.getUser(by: donorRef.documentID)
                else {
                    print("Skipping donation document \(doc.documentID) because NGO or donor not found")
                    continue
                }

                // Firestore auto-generated ID
                let firestoreID = data["firestoreID"] as? String ?? doc.documentID

                // User-friendly numeric donationID
                let donationID = data["donationID"] as? Int ?? 0

                // Fetch address reference
                if let addressRef = data["address"] as? DocumentReference {
                    group.enter() // Start async task

                    addressRef.getDocument { addressSnapshot, error in
                        defer { group.leave() } // Ensure group leave

                        guard let addressData = addressSnapshot?.data(), error == nil else {
                            print("Failed to fetch address for donation \(donationID)")
                            return
                        }

                        let address = Address(
                            building: addressData["building"] as? Int ?? 0,
                            road: addressData["road"] as? Int ?? 0,
                            block: addressData["block"] as? Int ?? 0,
                            flat: addressData["flat"] as? Int,
                            area: addressData["area"] as? String ?? "",
                            governorate: addressData["governorate"] as? String ?? ""
                        )

                        let donation = Donation(
                            firestoreID: firestoreID,
                            donationID: donationID,
                            ngo: ngo,
                            creationDate: creationTimestamp,
                            donor: donor,
                            address: address,
                            pickupDate: pickupTimestamp,
                            pickupTime: pickupTime,
                            foodImageUrl: foodImageUrl,
                            status: status,
                            category: category,
                            quantity: quantity,
                            weight: data["weight"] as? Double,
                            expiryDate: expiryTimestamp,
                            description: data["description"] as? String,
                            rejectionReason: data["rejectionReason"] as? String,
                            recurrence: data["recurrence"] as? Int ?? 0
                        )

                        self.allDonations.append(donation)
                    }
                }
            }

            // Once all addresses are fetched, update displayedDonations and reload
            group.notify(queue: .main) {
                self.displayedDonations = self.allDonations.sorted {
                    $0.creationDate.dateValue() > $1.creationDate.dateValue()
                }
                self.donationsCollectionView.reloadData()
                self.updateNoDonationsLabel()
            }
        }
    }





        func getUser(by id: String) -> User? {
            return allUsers.first { $0.userID == id }
        }

        // MARK: - Segue
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showDonationDetails",
               let detailsVC = segue.destination as? DonationDetailsViewController,
               let indexPath = donationsCollectionView.indexPathsForSelectedItems?.first {
                let donation = displayedDonations[indexPath.row]
                detailsVC.donation = donation
                detailsVC.currentUser = currentUser
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

    // MARK: - UICollectionViewDataSource
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
                if let currentUser = currentUser {
                    cell.setup(with: donation, currentUser: currentUser)
                }
                return cell
            }
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout
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
            if selectedIndex != 0 {
                filtered = filtered.filter { $0.status == selectedIndex }
            }

            let searchText = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            if !searchText.isEmpty {
                let text = searchText.lowercased()
                filtered = filtered.filter {
                    ($0.ngo.organization_name?.lowercased().contains(text) ?? false) ||
                    String($0.donationID).contains(text) ||
                    $0.donor.username.lowercased().contains(text) ||
                    $0.category.lowercased().contains(text)
                }

            }

            displayedDonations = filtered.sorted {
                $0.creationDate.dateValue() > $1.creationDate.dateValue()
            }
            donationsCollectionView.reloadData()
            updateNoDonationsLabelDuringSearch()
        }
    }

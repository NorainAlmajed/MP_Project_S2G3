//
//  DonationViewController.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 29/11/2025.
//

import UIKit

class DonationViewController: UIViewController {

    // Outlet connected to the collection view in the storyboard
    @IBOutlet weak var donationsCollectionView: UICollectionView!
    
    @IBOutlet weak var statusCollectionView: UICollectionView!
    


        let statuses = ["All", "Pending", "Accepted", "Collected", "Rejected", "Cancelled"]
        var selectedIndex = 0

        // Arrays for filtering donations
        var allDonations: [Donation] = []
        var displayedDonations: [Donation] = []

        // ✅ New: Search UI under navigation bar (like Donor List)
        private var searchBar: UISearchBar!
        private var filterButton: UIButton!
        private var searchHeaderView: UIView!

        // ✅ Empty label
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

            // Initialize fake data. Remove later !!!! ‼️‼️‼️‼️‼️‼️‼️
            user.donations = [
                Donation(donationID: 91475, ngo: ngo1, creationDate: Date(), donor: user, address: Address(building: 1311, road: 3027, block: 430, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "8AM - 9PM", foodImage: "https://media.self.com/photos/5b6b0b0cbb7f036f7f5cbcfa/4:3/w_2560%2Cc_limit/apples.jpg", status: 1, Category: "Bakery", quantity: 30, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor", recurrence: 1),

                Donation(donationID: 88888, ngo: ngo2, creationDate: Date().addingTimeInterval(-1200), donor: user, address: Address(building: 1111, road: 2222, block: 3333, flat: 402, area: "Seef", governorate: "North"), pickupDate: Date(), pickupTime: "12AM - 2PM", foodImage: "https://media.self.com/photos/5b6b0b0cbb7f036f7f5cbcfa/4:3/w_2560%2Cc_limit/apples.jpg", status: 2, Category: "Dairy", quantity: 88, weight: 8.8, expiryDate: Date(), rejectionReason: "The food does not meet the quality standards.", recurrence: 3),

                Donation(donationID: 91475, ngo: ngo2, creationDate: Date().addingTimeInterval(-350), donor: user, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: "https://media.self.com/photos/5b6b0b0cbb7f036f7f5cbcfa/4:3/w_2560%2Cc_limit/apples.jpg", status: 3, Category: "Produce", quantity: 30, weight: nil, expiryDate: Date(), description: "   ", rejectionReason: "   "),

                Donation(donationID: 91475, ngo: ngo1, creationDate: Date().addingTimeInterval(-300), donor: user, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: "https://media.self.com/photos/5b6b0b0cbb7f036f7f5cbcfa/4:3/w_2560%2Cc_limit/apples.jpg", status: 4, Category: "Poultry", quantity: 30, weight: 18.8, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor, bahraini and great for cooking and baking!", rejectionReason: "The food does not meet the quality standards, it's not ripe enough."),

                Donation(donationID: 91475, ngo: ngo2, creationDate: Date().addingTimeInterval(-200), donor: user, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: "https://media.self.com/photos/5b6b0b0cbb7f036f7f5cbcfa/4:3/w_2560%2Cc_limit/apples.jpg", status: 5, Category: "Beverages", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),

                Donation(donationID: 91475, ngo: ngo1, creationDate: Date().addingTimeInterval(-800), donor: user, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: "https://media.self.com/photos/5b6b0b0cbb7f036f7f5cbcfa/4:3/w_2560%2Cc_limit/apples.jpg", status: 1, Category: "Canned Food", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),

                Donation(donationID: 91475, ngo: ngo1, creationDate: Date().addingTimeInterval(-500), donor: user, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: "https://media.self.com/photos/5b6b0b0cbb7f036f7f5cbcfa/4:3/w_2560%2Cc_limit/apples.jpg", status: 2, Category: "Others", quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor")
            ]

            // Initializing the donations list
            allDonations = user.donations ?? []
            displayedDonations = allDonations.sorted { $0.creationDate > $1.creationDate }

            // Sort donations by creationDate (newest first)
            user.donations?.sort { $0.creationDate > $1.creationDate }

            // Title
            title = "Donations"

            // Collection views
            donationsCollectionView.dataSource = self
            donationsCollectionView.delegate = self

            statusCollectionView.dataSource = self
            statusCollectionView.delegate = self

            // Status collection view layout
            let layout2 = UICollectionViewFlowLayout()
            layout2.scrollDirection = .horizontal
            layout2.minimumLineSpacing = 8
            layout2.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout2.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            statusCollectionView.collectionViewLayout = layout2

            // Navigation bar appearance (no weird white while scrolling)
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = view.backgroundColor
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance

            // Empty label
            view.addSubview(noDonationsLabel)
            noDonationsLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                noDonationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                noDonationsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            updateNoDonationsLabel()

            // ✅ NEW: Add search header under navigation bar and push statusCollectionView down
            setupSearchHeaderUnderNavBar()

            // Donations list layout
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

        // ✅ Search header (SearchBar + Filter icon) under navigation bar
        private func setupSearchHeaderUnderNavBar() {
            // Container
            searchHeaderView = UIView()
            searchHeaderView.translatesAutoresizingMaskIntoConstraints = false
            searchHeaderView.backgroundColor = .systemBackground

            // Search bar
            searchBar = UISearchBar()
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            searchBar.placeholder = "Search donations..."
            searchBar.searchBarStyle = .minimal
            searchBar.autocapitalizationType = .none
            searchBar.autocorrectionType = .no
            searchBar.delegate = self

            // Filter button (icon)
            filterButton = UIButton(type: .system)
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            filterButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
            filterButton.tintColor = .label
            filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)

            searchHeaderView.addSubview(searchBar)
            searchHeaderView.addSubview(filterButton)
            view.addSubview(searchHeaderView)

            // Header constraints
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

            // ✅ Move statusCollectionView to be under the header (deactivate old top constraint if exists)
            deactivateTopConstraints(of: statusCollectionView)
            statusCollectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                statusCollectionView.topAnchor.constraint(equalTo: searchHeaderView.bottomAnchor, constant: 6),
                statusCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                statusCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])

            // (Optional) if donationsCollectionView top was tied to safeArea, keep it as-is in storyboard.
            // If your UI overlaps, we can also programmatically anchor donationsCollectionView under statusCollectionView.
        }

        // ✅ Utility: remove existing top constraints that conflict
        private func deactivateTopConstraints(of view: UIView) {
            // constraints on superview
            if let superview = view.superview {
                for c in superview.constraints {
                    let isTop =
                    (c.firstItem as? UIView) == view && c.firstAttribute == .top ||
                    (c.secondItem as? UIView) == view && c.secondAttribute == .top

                    if isTop { c.isActive = false }
                }
            }

            // constraints on itself (rare)
            for c in view.constraints {
                let isTop = c.firstAttribute == .top || c.secondAttribute == .top
                if isTop { c.isActive = false }
            }
        }

        // Filter button
        @objc private func filterButtonTapped() {
            // TODO: implement later
        }

        // Label when no donations
        private func updateNoDonationsLabel() {
            if (user.donations ?? []).isEmpty {
                noDonationsLabel.isHidden = false
                donationsCollectionView.isHidden = true
            } else {
                noDonationsLabel.isHidden = true
                donationsCollectionView.isHidden = false
            }
        }

        // Big title
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            navigationController?.setNavigationBarHidden(false, animated: animated)
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            title = "Donations"

            // Remove bottom shadow/line
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = view.backgroundColor
            appearance.shadowColor = .clear

            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance

            donationsCollectionView.reloadData()
        }

        // Prepare segue
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showDonationDetails" {
                if let detailsVC = segue.destination as? DonationDetailsViewController {
                    if let indexPath = donationsCollectionView.indexPathsForSelectedItems?.first {
                        let donation = displayedDonations[indexPath.row]
                        detailsVC.donation = donation
                    }
                    detailsVC.hidesBottomBarWhenPushed = true
                }
            }
        }

        // Filtering donations
        private func filterDonations() {
            var filtered = allDonations

            // Filter by status
            if selectedIndex != 0 {
                let statusToFilter = selectedIndex
                filtered = filtered.filter { $0.status == statusToFilter }
            }

            // Filter by search text (✅ now from searchBar)
            let searchText = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            if !searchText.isEmpty {
                let text = searchText.lowercased()

                filtered = filtered.filter {
                    $0.ngo.ngoName.lowercased().contains(text) ||
                    String($0.donationID).contains(text) ||
                    $0.donor.username.lowercased().contains(text) ||
                    $0.Category.lowercased().contains(text)
                }
            }

            displayedDonations = filtered.sorted { $0.creationDate > $1.creationDate }
            donationsCollectionView.reloadData()
            updateNoDonationsLabelDuringSearch()
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
            if collectionView == statusCollectionView {
                return statuses.count
            } else {
                return displayedDonations.count
            }
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
            let horizontalPadding: CGFloat = isIPad ? 80 : 16

            let width = collectionView.bounds.width - horizontalPadding
            let height: CGFloat = isIPad ? 150 : 124

            return CGSize(width: width, height: height)
        }
    }

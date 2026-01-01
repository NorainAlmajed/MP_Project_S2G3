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
        var currentUser: ZahraaUser?
        let db = Firestore.firestore()

        let statuses = ["All", "Pending", "Accepted", "Collected", "Rejected", "Cancelled"]
        var selectedIndex = 0

        var allDonations: [Donation] = []
        var displayedDonations: [Donation] = []
        var allUsers: [ZahraaUser] = []

        private var searchBar: UISearchBar!
        private var filterButton: UIButton!
        private var searchHeaderView: UIView!

        //No donations available
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

            //IF fetchCurrentUser fails calls updateNoDonationsLabel, if available calls fetchAllUsers runs
             
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
            
            fetchDonations()

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

        //Setting the layout of the donation collection view
        private func setupDonationsCollectionLayout() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 16
            let isIPad = UIDevice.current.userInterfaceIdiom == .pad
            layout.sectionInset = UIEdgeInsets(
                top: 12,
                left: isIPad ? 40 : 0, //Ipad 40
                bottom: 12,
                right: isIPad ? 40 : 0
            )
            donationsCollectionView.collectionViewLayout = layout
        }

        //Search Header
        private func setupSearchHeaderUnderNavBar() {
            //Setting the header
            searchHeaderView = UIView()
            searchHeaderView.translatesAutoresizingMaskIntoConstraints = false
            searchHeaderView.backgroundColor = .systemBackground

            //Setting the search bar
            searchBar = UISearchBar()
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            searchBar.placeholder = "Search donations..."
            searchBar.searchBarStyle = .minimal
            searchBar.autocapitalizationType = .none //Prevents the keyboard from automatically capitalizing letters.
            searchBar.autocorrectionType = .no //Turns auto-correction off.
            searchBar.delegate = self //Assigns the delegate
            //Allows you to respond to search events


            filterButton = UIButton(type: .system)
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            filterButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
            filterButton.tintColor = .label
            filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)

            searchHeaderView.addSubview(searchBar)
            searchHeaderView.addSubview(filterButton)
            view.addSubview(searchHeaderView)

            //Setting the position of the search bar for the searchHeaderView and searchBar and filterButton
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

    
        //Helper function
        //removes all constraints that affect a view’s top position
        private func deactivateTopConstraints(of view: UIView) {
            //Check constraints in the superview
            if let superview = view.superview {
                //Check constraints owned by the view itself
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
    
    
    
        
    
        //Filter button action (Zainab Mahdi)
        @objc private func filterButtonTapped() {
            // TODO: implement filter UI
        }
    
    
    
    
    

        // Label Updates if there are no donations
        private func updateNoDonationsLabel() {
            if displayedDonations.isEmpty {
                noDonationsLabel.isHidden = false
                donationsCollectionView.isHidden = true
            } else {
                noDonationsLabel.isHidden = true
                donationsCollectionView.isHidden = false
            }
        }

        // Setting a "No results found" label for searching
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

    
    // Firebase.
    func fetchCurrentUser(completion: @escaping (Bool) -> Void) {

        // Get logged-in Firebase user
        guard let firebaseUser = Auth.auth().currentUser else {
            print("❌ No logged-in user")
            completion(false)
            return
        }
        
        //Saving the id od the current user
        let userID = firebaseUser.uid

        // Fetch user document using REAL ID
        db.collection("users").document(userID).getDocument { [weak self] snapshot, error in
            if let error = error {
                print("❌ Error fetching user:", error)
                completion(false)
                return
            }

            //Saving current user data
            guard let data = snapshot?.data(),
                  let username = data["username"] as? String,
                  let role = data["role"] as? Int
            else {
                print("❌ User data missing or invalid")
                completion(false)
                return
            }
            //Saving current user data
            self?.currentUser = ZahraaUser(
                userID: userID,
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

    
    
    
    //Fetching all users in firebase, Saves them in allUsers
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

            self.allUsers = documents.compactMap { doc -> ZahraaUser? in
                let data = doc.data()
                guard let username = data["username"] as? String,
                      let role = data["role"] as? Int else { return nil }

                return ZahraaUser(
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


    
    //Fetch the current user donations
    func fetchDonations() {
        guard let currentUser = currentUser else { return }

        var query: Query = db.collection("Donation")

        switch currentUser.role {
        case 1: break //print all donations
        case 2:
            query = query.whereField("donor", isEqualTo: db.collection("users").document(currentUser.userID))
            //Fetch donations for that donor
        case 3:
            query = query.whereField("ngo", isEqualTo: db.collection("users").document(currentUser.userID))
            //Fetch donations for that ngo
        default:
            return
        }

        query.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            guard let documents = snapshot?.documents else { return }

            //Clear all donations and group them
            self.allDonations.removeAll()
            let group = DispatchGroup()

            //Loop through each donation document
            for doc in documents {
                let data = doc.data()

                //Ensures all required fields exist
                guard
                    let ngoRef = data["ngo"] as? DocumentReference,
                    let donorRef = data["donor"] as? DocumentReference,
                    let addressRef = data["address"] as? DocumentReference,
                    let creationDate = data["creationDate"] as? Timestamp,
                    let pickupDate = data["pickupDate"] as? Timestamp,
                    let pickupTime = data["pickupTime"] as? String,
                    let foodImageUrl = data["foodImageUrl"] as? String,
                    let status = data["status"] as? Int,
                    let category = data["Category"] as? String,
                    let quantity = data["quantity"] as? Int,
                    let expiryDate = data["expiryDate"] as? Timestamp
                else {
                    continue
                }

                //If user data isn’t available, skip donation
                guard
                    let ngo = self.getUser(by: ngoRef.documentID),
                    let donor = self.getUser(by: donorRef.documentID)
                else {
                    continue
                }

                //Save donation firestoreID and donationID
                let firestoreID = doc.documentID
                let donationID = data["donationID"] as? Int ?? 0

                group.enter()

                addressRef.getDocument { addressSnap, _ in
                    defer { group.leave() }

                    guard let addressData = addressSnap?.data() else { return }
                    
                    //Saving donation address object
                    let address = ZahraaAddress(
                        building: addressData["building"] as? String ?? "",
                        road: addressData["road"] as? String ?? "",
                        block: addressData["block"] as? String ?? "",
                        flat: addressData["flat"] as? String ?? "",
                        area: addressData["area"] as? String ?? "",
                        governorate: addressData["governorate"] as? String ?? ""
                    )


                    //Save donation data
                    let donation = Donation(
                        firestoreID: firestoreID,
                        donationID: donationID,
                        ngo: ngo,
                        creationDate: creationDate,
                        donor: donor,
                        address: address, // ✅ REAL ADDRESS
                        pickupDate: pickupDate,
                        pickupTime: pickupTime,
                        foodImageUrl: foodImageUrl,
                        status: status,
                        category: category,
                        quantity: quantity,
                        weight: data["weight"] as? Double,
                        expiryDate: expiryDate,
                        description: data["description"] as? String,
                        rejectionReason: data["rejectionReason"] as? String,
                        recurrence: data["recurrence"] as? Int ?? 0
                    )
                    
                    //Store donation in allDonations
                    self.allDonations.append(donation)
                }
            }

            group.notify(queue: .main) {
                //Sorts donations by newest first
                self.displayedDonations = self.allDonations.sorted {
                    $0.creationDate.dateValue() > $1.creationDate.dateValue()
                }
                //Reloads the collection view
                self.donationsCollectionView.reloadData()
                self.updateNoDonationsLabel()
            }
        }
    }






        // finds and returns a user from allUsers using their ID.
        func getUser(by id: String) -> ZahraaUser? {
            return allUsers.first { $0.userID == id }
        }

    
        // Segue for DonationDetailsViewController
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showDonationDetails",
               let detailsVC = segue.destination as? DonationDetailsViewController,
               //Gets the selected cell’s index
               let indexPath = donationsCollectionView.indexPathsForSelectedItems?.first {
                //Gets the donation object the user tapped
                let donation = displayedDonations[indexPath.row]
                //Passing data to the next screen
                detailsVC.donation = donation
                detailsVC.currentUser = currentUser
                //Hides the tab bar on the details screen
                detailsVC.hidesBottomBarWhenPushed = true
            }
        }
    }

    // UISearchBarDelegate
    // Respond to search bar events and filters donations as the user types.
    extension DonationViewController: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            filterDonations()
        }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }


    // UICollectionViewDataSource
    extension DonationViewController: UICollectionViewDataSource {
        //Number of items
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return collectionView == statusCollectionView ? statuses.count : displayedDonations.count
        }

        //Called for each visible item to display a cell
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == statusCollectionView {
                //Creates a status cell
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusCell", for: indexPath) as! StatusCollectionViewCell
                  //title & whether it’s selected
                cell.configure(title: statuses[indexPath.item], isSelected: indexPath.item == selectedIndex)
                
                //When the user taps a status
                cell.onStatusTapped = { [weak self] in
                    guard let self = self else { return }
                    self.selectedIndex = indexPath.item //Update the selected index
                    self.filterDonations() //Filter donations based on status
                    self.statusCollectionView.reloadData() //Reload the status collection view to show selection
                }
                return cell
            } else {
                //Creates a donation cell
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DonationCollectionViewCell", for: indexPath) as! DonationCollectionViewCell
                let donation = displayedDonations[indexPath.row]
                if let currentUser = currentUser {
                    cell.setup(with: donation, currentUser: currentUser)
                }
                return cell
            }
        }
    }

    // UICollectionViewDelegateFlowLayout
    //specify cell sizes for collection views
    extension DonationViewController: UICollectionViewDelegateFlowLayout {
        //Called for each cell
        //Returns the width and height of that cell
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            //Status bar cells are fixed size
            if collectionView == statusCollectionView {
                return CGSize(width: 100, height: 36)
            }
            //Donations collection view cells
            let isIPad = UIDevice.current.userInterfaceIdiom == .pad
            let width = collectionView.bounds.width - (isIPad ? 80 : 16)
            let height: CGFloat = isIPad ? 150 : 124
            return CGSize(width: width, height: height)
        }
    }

    // Filtering
    //Called when: the status filter changes + the search bar text changes
    extension DonationViewController {
        func filterDonations() {
            var filtered = allDonations
            //Filter by status
            if selectedIndex != 0 {
                filtered = filtered.filter { $0.status == selectedIndex }
            }

            //Filter by search text
            let searchText = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            if !searchText.isEmpty {
                let text = searchText.lowercased()
                filtered = filtered.filter {
                    //Search based on ngo name, donation id and donor username + Case-insensitive
                    ($0.ngo.organization_name?.lowercased().contains(text) ?? false) ||
                    String($0.donationID).contains(text) ||
                    $0.donor.username.lowercased().contains(text) ||
                    $0.category.lowercased().contains(text)
                }

            }

            //Sort by newest first
            displayedDonations = filtered.sorted {
                $0.creationDate.dateValue() > $1.creationDate.dateValue()
            }
            //Update UI
            donationsCollectionView.reloadData()
            updateNoDonationsLabelDuringSearch()
        }
    }

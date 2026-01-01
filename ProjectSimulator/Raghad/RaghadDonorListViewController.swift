//
//  RaghadDonorListViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 14/12/2025.
//


//
//  RaghadDonorListViewController.swift
//  ProjectSimulator
//

import FirebaseFirestore
import UIKit

protocol DonorSelectionDelegate: AnyObject {
    func didSelectDonor(donorRefPath: String, donorName: String)
}


class RaghadDonorListViewController: UIViewController,
                                     UITableViewDelegate,
                                     UITableViewDataSource,
                                     UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //  Your donors list
//    private let donors: [User] = users
    
    private var donors: [User] = []
    private var donorListener: ListenerRegistration?
    
    private var donorRefByUsername: [String: String] = [:]   //  username -> "users/<docId>"


    
    weak var delegate: DonorSelectionDelegate?
    
    private var selectedIndex: IndexPath?
    
    //  Search/Filter
    private var filteredDonors: [User] = []
    private var searchBar: UISearchBar!
    private var filterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Choose Donor"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //  start with all donors
        filteredDonors = donors
        
        //  Cancel = red
        let cancel = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        cancel.tintColor = .systemRed
        navigationItem.leftBarButtonItem = cancel
        
        //  Done = blue
        let done = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneTapped)
        )
        done.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = done
        
        //  add search + filter under nav bar
        setupHeaderSearchAndFilter()
        fetchDonorsFromFirestore()

    }
    
    // MARK: - Header (Search + Filter)
    
    private func setupHeaderSearchAndFilter() {
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 56)
        
        // Search bar
        searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = "Search donor"
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.frame = CGRect(x: 8, y: 8, width: header.frame.width - 90, height: 40)
        
        // Filter button
        filterButton = UIButton(type: .system)
        filterButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        filterButton.tintColor = .label   // black / adapts to dark mode
        filterButton.frame = CGRect(x: header.frame.width - 52, y: 8, width: 40, height: 40)
        filterButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        
        
        header.addSubview(searchBar)
        header.addSubview(filterButton)
        
        tableView.tableHeaderView = header
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDonors.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DonorCell", for: indexPath)
        
        let donor = filteredDonors[indexPath.row]
        cell.textLabel?.text = donor.username
        
        //  FONT SIZE LINE HERE
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        //  checkmark on selected row
        cell.accessoryType = (indexPath == selectedIndex) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
        
    @objc private func doneTapped() {
        guard let indexPath = selectedIndex else { return }

        let chosenDonor = filteredDonors[indexPath.row]

        guard let donorRefPath = donorRefByUsername[chosenDonor.username] else {
            print(" Missing donor ref for username: \(chosenDonor.username)")
            return
        }

        delegate?.didSelectDonor(donorRefPath: donorRefPath, donorName: chosenDonor.username)
        navigationController?.popViewController(animated: true)
    }

    
    // MARK: - SearchBar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if text.isEmpty {
            filteredDonors = donors
        } else {
            filteredDonors = donors.filter { $0.username.lowercased().contains(text) }
        }
        
        //  reset selection when results change (avoids wrong checkmark)
        selectedIndex = nil
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Filter Button
    
    @objc private func filterTapped() {
    }
    
    
    
    
    
    
    private func fetchDonorsFromFirestore() {
        let db = Firestore.firestore()

        // Real-time listener (auto updates if new donors added)
        donorListener = db.collection("users")
            .whereField("role", isEqualTo: 2) //  donor role
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print(" Firestore donor fetch error: \(error.localizedDescription)")
                    //  Safe fallback: keep existing data (no crash)
                    return
                }

                guard let documents = snapshot?.documents else {
                    print(" No donor documents found")
                    self.donors = []
                    self.filteredDonors = []
                    self.tableView.reloadData()
                    return
                }
                // Build username -> referencePath map
                self.donorRefByUsername = Dictionary(uniqueKeysWithValues:
                    documents.compactMap { doc in
                        let data = doc.data()
                        guard let username = data["username"] as? String else { return nil }
                        return (username, "users/\(doc.documentID)")
                    }
                )

                //  Map Firestore -> User struct safely
                let fetched: [User] = documents.compactMap { doc in
                    let data = doc.data()

                    // username can be missing, so we guard
                    guard let username = data["username"] as? String else { return nil }

                    // role might come as Int or Double depending on how it was saved
                    let roleInt: Int
                    if let r = data["role"] as? Int {
                        roleInt = r
                    } else if let r = data["role"] as? Double {
                        roleInt = Int(r)
                    } else {
                        roleInt = 0
                    }

                    return User(username: username, userType: roleInt)
                }
                .sorted { $0.username.lowercased() < $1.username.lowercased() } //  nice ordering

                self.donors = fetched

                //  Keep your search logic working:
                // If search bar is empty -> show all donors
                let currentSearch = self.searchBar?.text?
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .lowercased() ?? ""

                if currentSearch.isEmpty {
                    self.filteredDonors = self.donors
                } else {
                    self.filteredDonors = self.donors.filter {
                        $0.username.lowercased().contains(currentSearch)
                    }
                }

                //  reset selection when list updates (prevents wrong checkmark)
                self.selectedIndex = nil

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

                print(" Donors loaded from Firestore: \(self.donors.count)")
            }
    }

    deinit {
        donorListener?.remove()
    }
 
}

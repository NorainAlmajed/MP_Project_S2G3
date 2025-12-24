//
//  NgoViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 11/12/2025.
//

import FirebaseCore
import FirebaseFirestore
import UIKit

class NgoViewController: UIViewController,
                         UITableViewDelegate,
                         UITableViewDataSource,
                         UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!

    // ✅ Your data
    //private var shownNgos: [NGO] = []
   // private var allNgos: [NGO] = []   // ✅ source of truth from Firebase
    private var shownNgos: [NGO] = []   // ✅ what table shows
    private var allNgos: [NGO] = []
    private var selectedCategory: String? = nil

    // ✅ Header UI (same style as Donor List)
    private var searchBar: UISearchBar!
    private var filterButton: UIButton!

    // ✅ Empty state label
    private let noNgosLabel: UILabel = {
        let label = UILabel()
        label.text = "No NGOs available"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("🔥 Firebase Project ID:", FirebaseApp.app()?.options.projectID ?? "nil")
        print("🔥 Firebase Google App ID:", FirebaseApp.app()?.options.googleAppID ?? "nil")
        
        title = "Browse NGOs"

        tableView.delegate = self
        tableView.dataSource = self

        // ✅ Start list
       // shownNgos = arrNgo
       

        
        
        

        // ✅ Add header (Search + Filter) UNDER the navigation bar (like Donor List)
        setupHeaderSearchAndFilter()

        // ✅ Empty label
        view.addSubview(noNgosLabel)
        noNgosLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noNgosLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNgosLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        updateNoNgosLabel()

        // Remove default nav bar shadow
        navigationController?.navigationBar.shadowImage = UIImage()

        // Add a bottom line under nav bar
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.systemGray4
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        navigationController?.navigationBar.addSubview(bottomLine)

        NSLayoutConstraint.activate([
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
            bottomLine.leadingAnchor.constraint(equalTo: navigationController!.navigationBar.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: navigationController!.navigationBar.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor)
        ])

        // ✅ Hide back button text for next screen
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        tableView.separatorStyle = .singleLine
        
        tableView.separatorColor = UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor.systemGray3   // darker gray for dark mode
                : UIColor.systemGray4   // light gray for light mode
        }


        
        
        
    }

    // ✅ Helps iPad / rotation keep header width correct
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderWidth()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySearchAndFilter()
        fetchNgosFromFirebase()
    }

    // MARK: - Header (Search + Filter) like Donor List

    private func setupHeaderSearchAndFilter() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 56))
        container.backgroundColor = .systemBackground

        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false

        // Search bar
        searchBar = UISearchBar()
        searchBar.placeholder = "Search NGOs"
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        // Filter button
        filterButton = UIButton(type: .system)
        filterButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        filterButton.tintColor = .label
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)

        header.addSubview(searchBar)
        header.addSubview(filterButton)
        container.addSubview(header)

        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            header.topAnchor.constraint(equalTo: container.topAnchor),
            header.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            searchBar.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 8),
            searchBar.topAnchor.constraint(equalTo: header.topAnchor, constant: 8),
            searchBar.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -8),

            filterButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 8),
            filterButton.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -12),
            filterButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 40),
            filterButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        tableView.tableHeaderView = container
    }

    private func updateHeaderWidth() {
        guard let header = tableView.tableHeaderView else { return }
        let newWidth = tableView.bounds.width
        if header.frame.width != newWidth {
            header.frame.size.width = newWidth
            tableView.tableHeaderView = header
        }
    }

    // MARK: - SearchBar Delegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applySearchAndFilter()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownNgos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NgoCell") as! NgoTableTableViewCell
        let data = shownNgos[indexPath.row]
       // cell.setupCell(photo: data.photo, name: data.name, category: data.category)
        cell.setupCell(photoUrl: data.photo, name: data.name, category: data.category)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("cell index = \(indexPath.row)")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNgoDetails" {
            let vc = segue.destination as! NgoDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.selectedNgo = shownNgos[indexPath.row]
            }
        }
    }

    // MARK: - Empty State

    private func updateNoNgosLabel() {
        let text = (searchBar?.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let isSearching = !text.isEmpty || selectedCategory != nil

        if shownNgos.isEmpty {
            noNgosLabel.text = isSearching ? "No results found" : "No NGOs available"
            noNgosLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noNgosLabel.isHidden = true
            tableView.isHidden = false
        }
    }

    // MARK: - Filter Button

    @objc private func filterTapped() {
        // TODO: your teammate will implement filter UI later
    }

    // MARK: - Apply Search + Filter

    private func applySearchAndFilter() {
//        var result = arrNgo
        var result = allNgos


        // category filter
        if let cat = selectedCategory {
            result = result.filter { $0.category == cat }
        }

        // search by name/category
        let text = (searchBar?.text ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        if !text.isEmpty {
            result = result.filter { ngo in
                ngo.name.lowercased().contains(text) ||
                ngo.category.lowercased().contains(text)
            }
        }

        shownNgos = result
        tableView.reloadData()
        updateNoNgosLabel()
    }
    
    
    
    
//    private func fetchNgosFromFirebase() {
//        let db = Firestore.firestore()
//
//        db.collection("ngos").getDocuments { [weak self] snapshot, error in
//            guard let self = self else { return }
//
//            if let error = error {
//                print("❌ Fetch NGOs failed:", error)
//                return
//            }
//
//            let docs = snapshot?.documents ?? []
//
//            let ngos: [NGO] = docs.compactMap { doc -> NGO? in
//                let data = doc.data()
//
//                let name = data["organizationName"] as? String ?? data["name"] as? String ?? ""
//                let category = data["category"] as? String ?? data["cause"] as? String ?? ""
//                let mission = data["bio"] as? String ?? data["mission"] as? String ?? ""
//                let email = data["email"] as? String ?? ""
//                let phone = "\(data["phoneNumber"] ?? "")"
//                let photoUrl = data["profileImageUrl"] as? String ?? ""
//
//                if name.isEmpty { return nil }
//
//                return NGO(
//                    id: doc.documentID,
//                    name: name,
//                    category: category,
//                    photo: photoUrl,
//                    mission: mission,
//                    phoneNumber: phone,
//                    email: email
//                )
//            }
//            
//            
//            
//
////            self.shownNgos = ngos
////            self.applySearchAndFilter() // ✅ so search/filter works using Firebase list too
////            self.tableView.reloadData()
//            
//            
//            
//        }
//    }

    
    private func fetchNgosFromFirebase() {
        print("🔥 Fetching NGOs from Firestore collection: users where role == 3")

        Firestore.firestore()
            .collection("users")
            .whereField("role", isEqualTo: 3)   // ✅ NGO role is number 3
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ Fetch NGOs failed:", error.localizedDescription)
                    self.allNgos = []
                    self.applySearchAndFilter()
                    return
                }

                let docs = snapshot?.documents ?? []
                print("✅ Firestore returned docs count:", docs.count)

                let ngos: [NGO] = docs.compactMap { doc -> NGO? in
                    let data = doc.data()

                    let name = data["organization_name"] as? String ?? ""
                    let category = data["cause"] as? String ?? ""
                    let mission = data["mission"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let phone = data["number"] as? String ?? ""
                    let photoUrl = data["profile_image_url"] as? String ?? ""

                    guard !name.isEmpty else { return nil }

                    return NGO(
                        id: doc.documentID,
                        name: name,
                        category: category,
                        photo: photoUrl,
                        mission: mission,
                        phoneNumber: phone,
                        email: email
                    )
                }

                print("✅ Parsed NGOs count:", ngos.count)

                self.allNgos = ngos
                self.applySearchAndFilter()
                self.tableView.reloadData()
                self.updateNoNgosLabel()
            }
    }

    
    
}
//  NgoViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 11/12/2025.
//

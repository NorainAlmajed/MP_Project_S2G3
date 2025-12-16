//
//  NgoViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 11/12/2025.
//

import UIKit

class NgoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating
{
   
    


    @IBOutlet weak var tableView: UITableView!
    
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var shownNgos: [NGO] = []
    private var selectedCategory: String? = nil
    
    // ✅🆕 1) Empty state label (when there are no NGOs)
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
        
        tableView.delegate = self
        tableView.dataSource = self
        title = "Browse NGOs"

        
        // ✅🆕 3) Add empty label to the screen
        view.addSubview(noNgosLabel)
        noNgosLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noNgosLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNgosLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        // ✅🆕 4) Run the method once at start
        updateNoNgosLabel()

        

          

            // إزالة الخط الافتراضي (إن وُجد)
            navigationController?.navigationBar.shadowImage = UIImage()

            // خط أسفل الـ Navigation Bar
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
        
        
        
        
        // ✅⬅️🆕 Hide back button text for the NEXT screen (NgoDetails)
           if #available(iOS 14.0, *) {
               navigationItem.backButtonDisplayMode = .minimal
           } else {
               navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
           }

        
    
        
        shownNgos = arrNgo
        // ✅ iOS standard search in nav bar
           searchController.searchResultsUpdater = self
           searchController.obscuresBackgroundDuringPresentation = false
           searchController.searchBar.placeholder = "Search NGOs"
           navigationItem.searchController = searchController
           navigationItem.hidesSearchBarWhenScrolling = false
           definesPresentationContext = true

           // ✅ iOS standard filter button on the right
           navigationItem.rightBarButtonItem = UIBarButtonItem(
               image: UIImage(systemName: "slider.horizontal.3"),
               style: .plain,
               target: self,
               action: #selector(filterTapped)
           )
        
        
        
        
        
        
        
        
        
    }
    
    
    // ✅🆕 5) Refresh the table + empty label whenever the page appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySearchAndFilter()
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        applySearchAndFilter()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownNgos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NgoCell") as! NgoTableTableViewCell
        let data = shownNgos[indexPath.row]
        cell.setupCell(photo: data.photo, name: data.name, category: data.category)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NgoCell", for: indexPath) as! NgoTableTableViewCell
//        let data = arrNgo[indexPath.row]
//        cell.setupCell(photo: data.photo, name: data.name, category: data.category)
//        return cell
//    }

    

    
    //to edit the height of the row 
           func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true) // added this  to deselect row
        print("cell index = \(indexPath.row)") // to show the index of the cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNgoDetails" {
            let vc = segue.destination as! NgoDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.selectedNgo = shownNgos[indexPath.row]   // ✅ not arrNgo
            }
        }
    }

    // ✅🆕 2) Show label if the list is empty
    private func updateNoNgosLabel() {
        let isSearching = !(searchController.searchBar.text ?? "").isEmpty
            || selectedCategory != nil

        if shownNgos.isEmpty {
            noNgosLabel.text = isSearching ? "No results found" : "No NGOs available"
            noNgosLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noNgosLabel.isHidden = true
            tableView.isHidden = false
        }
    }

    
    
    //filter and search
    @objc private func filterTapped() {
   
    }
    
    
    
    
    
    private func applySearchAndFilter() {
        var result = arrNgo

        // category filter
        if let cat = selectedCategory {
            result = result.filter { $0.category == cat }
        }

        // search by name
        let text = (searchController.searchBar.text ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        if !text.isEmpty {
            result = result.filter { ngo in
                let nameMatch = ngo.name.lowercased().contains(text)
                let categoryMatch = ngo.category.lowercased().contains(text)
                return nameMatch || categoryMatch   // ✅ match either
            }
        }

        shownNgos = result
        tableView.reloadData()
        updateNoNgosLabel()
    }

    

    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

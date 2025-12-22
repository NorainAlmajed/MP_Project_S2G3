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

import UIKit

protocol DonorSelectionDelegate: AnyObject {
    func didSelectDonor(name: String)
}

class RaghadDonorListViewController: UIViewController,
                                     UITableViewDelegate,
                                     UITableViewDataSource,
                                     UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // ✅ Your donors list
    private let donors: [User] = users
    
    weak var delegate: DonorSelectionDelegate?
    
    private var selectedIndex: IndexPath?
    
    // ✅ Search/Filter
    private var filteredDonors: [User] = []
    private var searchBar: UISearchBar!
    private var filterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Choose Donor"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // ✅ start with all donors
        filteredDonors = donors
        
        // ✅ Cancel = red
        let cancel = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        cancel.tintColor = .systemRed
        navigationItem.leftBarButtonItem = cancel
        
        // ✅ Done = blue
        let done = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneTapped)
        )
        done.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = done
        
        // ✅ add search + filter under nav bar
        setupHeaderSearchAndFilter()
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
        
        // ✅ checkmark on selected row
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
        delegate?.didSelectDonor(name: chosenDonor.username)
        
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
        
        // ✅ reset selection when results change (avoids wrong checkmark)
        selectedIndex = nil
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Filter Button
    
    @objc private func filterTapped() {
    }
}

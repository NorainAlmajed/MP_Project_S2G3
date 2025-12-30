//
//  NGOFilterViewController.swift
//  Project
//
//  Created by zainab mahdi on 27/12/2025.
//

import UIKit

class NGOFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    enum FilterSection: Int, CaseIterable {
        case sort
        case location
        case type
    }

    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    var selectedSort: String? = nil
    var selectedLocations: Set<String> = []
    var selectedTypes: Set<String> = []

    //dummy data
    let sortOptions = ["NGO Name (A–Z)", "NGO Name (Z–A)"]

    let locationOptions = [
        "Manama Governorate",
        "Muharraq Governorate",
        "Northern Governorate",
        "Southern Governorate"
    ]

    let typeOptions = [
        "Orphanes",
        "Chronically ill",
        "Disabled People",
        "Children",
        "Women",
        "Others"
    ]

    //section functions
    var expandedSection: FilterSection? = nil


    // arrow function
    @objc func arrowTapped(_ sender: UIButton) {

        let tappedSection = FilterSection(rawValue: sender.tag)!

        if expandedSection == tappedSection {
            expandedSection = nil
        } else {
            expandedSection = tappedSection
        }
        tableView.reloadData()
    }
    
    //clear button function
    @IBAction func clearFiltersTapped(_ sender: UIButton) {
        
        selectedSort = nil
        selectedLocations = []
        selectedTypes = []
        expandedSection = nil

        tableView.reloadData()
    }

   //checkbox method
    @objc func checkboxTapped(_ sender: UIButton) {
        let section = sender.tag / 1000
        let row = sender.tag % 1000
        let indexPath = IndexPath(row: row, section: section)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
     //buttons radius method
    private func styleActionButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
    }

    
    // view title function
    func titleForSection(_ section: FilterSection) -> String {
        switch section {
        case .sort: return "Sort By"
        case .location: return "Location"
        case .type: return "Type"
        }
    }

     //filter options function
    func optionText(for section: FilterSection, row: Int) -> String {
        switch section {
        case .sort:
            return sortOptions[row - 1]
        case .location:
            return locationOptions[row - 1]
        case .type:
            return typeOptions[row - 1]
        }
    }
    
    

    //table functions
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {

        let sectionType = FilterSection(rawValue: section)!

        if expandedSection != sectionType {
            return 1
        }

        switch sectionType {
        case .sort:
            return 1 + sortOptions.count
        case .location:
            return 1 + locationOptions.count
        case .type:
            return 1 + typeOptions.count
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let sectionType = FilterSection(rawValue: indexPath.section)!

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "FilterHeaderCell",
                for: indexPath
            ) as! FilterHeaderCell

            cell.configure(
                title: titleForSection(sectionType),
                isExpanded: expandedSection == sectionType,
                showsDate: false
            )

            cell.arrowButton.tag = indexPath.section
            cell.arrowButton.addTarget(
                self,
                action: #selector(arrowTapped(_:)),
                for: .touchUpInside
            )

            return cell
        }

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "FilterOptionCell",
            for: indexPath
        ) as! FilterOptionCell

        let value = optionText(for: sectionType, row: indexPath.row)
        cell.optionLabel.text = value

        let isChecked: Bool
        switch sectionType {
        case .sort:
            isChecked = (selectedSort == value)
        case .location:
            isChecked = selectedLocations.contains(value)
        case .type:
            isChecked = selectedTypes.contains(value)
        }

        cell.setChecked(isChecked)
        cell.checkBoxButton.tag = indexPath.section * 1000 + indexPath.row
        cell.checkBoxButton.addTarget(
            self,
            action: #selector(checkboxTapped(_:)),
            for: .touchUpInside
        )

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return FilterSection.allCases.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard indexPath.row != 0 else { return }

        let sectionType = FilterSection(rawValue: indexPath.section)!
        let value = optionText(for: sectionType, row: indexPath.row)

        switch sectionType {
        case .sort:
            selectedSort = value
        case .location:
            if selectedLocations.contains(value) {
                selectedLocations.remove(value)
            } else {
                selectedLocations.insert(value)
            }
        case .type:
            if selectedTypes.contains(value) {
                selectedTypes.remove(value)
            } else {
                selectedTypes.insert(value)
            }
        }

        tableView.reloadSections(
            IndexSet(integer: indexPath.section),
            with: .none
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
        tableView.isUserInteractionEnabled = true
        tableView.separatorStyle = .none
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = view.backgroundColor ?? .systemBackground
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationItem.title = "Sort and Filter"

        styleActionButton(clearButton)
        styleActionButton(showButton)
    }
}


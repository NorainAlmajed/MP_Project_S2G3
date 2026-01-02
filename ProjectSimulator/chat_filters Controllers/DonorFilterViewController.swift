//
//  DonorFilterViewController.swift
//  Project
//
//  Created by zainab mahdi on 27/12/2025.
//

import UIKit


class DonorFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: DonorFilterDelegate?

    enum FilterSection: Int, CaseIterable {
        case sort
    }

    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func showFiltersTapped(_ sender: UIButton) {
        delegate?.didApplyDonorSort(selectedSort)
        navigationController?.popViewController(animated: true)
    }

    
    var selectedSort: String? = nil

    //dummy data
    let sortOptions = [
        "Donor Name (A–Z)",
        "Donor Name (Z–A)"
    ]

    //section functions
    var expandedSection: FilterSection? = .sort


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
        expandedSection = nil
        tableView.reloadData()
        updateShowButtonTitle()

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
        return "Sort By"
    }

     //filter options function
    func optionText(row: Int) -> String {
        return sortOptions[row - 1]
    }
    
    

    //table functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return FilterSection.allCases.count
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {

        guard expandedSection == .sort else { return 1 }
        return 1 + sortOptions.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "FilterHeaderCell",
                for: indexPath
            ) as! FilterHeaderCell

            cell.configure(
                title: titleForSection(.sort),
                isExpanded: expandedSection == .sort,
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

        let value = optionText(row: indexPath.row)
        cell.optionLabel.text = value

        let isChecked = (selectedSort == value)
        cell.setChecked(isChecked)

        cell.checkBoxButton.tag = indexPath.section * 1000 + indexPath.row
        cell.checkBoxButton.addTarget(
            self,
            action: #selector(checkboxTapped(_:)),
            for: .touchUpInside
        )

        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        guard indexPath.row != 0 else { return }

        let value = optionText(row: indexPath.row)
        selectedSort = value

        tableView.reloadSections(
            IndexSet(integer: indexPath.section),
            with: .none
        )

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        navigationItem.title = "Sort and Filter"

        styleActionButton(clearButton)
        styleActionButton(showButton)
        updateShowButtonTitle()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        selectedSort = delegate?.currentDonorSort()

        expandedSection = .sort

        tableView.reloadData()
        updateShowButtonTitle()
    }


    private func updateShowButtonTitle() {
        let count = delegate?.numberOfFilteredDonors(for: selectedSort) ?? 0
        showButton.setTitle("Show \(count) results", for: .normal)
    }

}


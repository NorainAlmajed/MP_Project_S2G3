//
//  DonationFilterController.swift
//  Project
//
//  Created by zainab mahdi on 26/12/2025.
//

import UIKit
class DonationFilterController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    enum FilterSection: Int, CaseIterable {
        case sort = 0
        case category
        case location
        case date
    }


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    
    var selectedSort: String? = nil
    var selectedCategories: Set<String> = []
    var selectedLocations: Set<String> = []

    //dummy data
    let sortOptions = ["Name (A–Z)", "Name (Z–A)"]

    let categoryOptions = [
        "Bakery", "Produce", "Poultry",
        "Beverages", "Canned Food", "Others"
    ]

    let locationOptions = [
        "Manama Governorate", "Muharraq Governorate", "Northern Governorate", "Southern Governorate"
    ]

    //section functions
    var expandedSection: FilterSection? = nil


    //set date to current function
    private let hiddenDateTextField: UITextField = {
        let tf = UITextField()
        tf.isHidden = true
        return tf
    }()
    var selectedDate = Date()

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }

  // date button - calendar function
    @objc func dateButtonTapped() {
        hiddenDateTextField.becomeFirstResponder()
    }
    @objc func dateChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        tableView.reloadSections(IndexSet(integer: 3), with: .none)
    }
    @objc func doneWithDatePicker() {
        hiddenDateTextField.resignFirstResponder()
    }

    
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
        selectedCategories = []
        selectedLocations = []
        selectedDate = Date()
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
        case .category: return "Category"
        case .location: return "Location"
        case .date: return "Date"
        }
    }

     //filter options function
    func optionText(for section: FilterSection, row: Int) -> String {
        switch section {
        case .sort:
            return sortOptions[row - 1]
        case .category:
            return categoryOptions[row - 1]
        case .location:
            return locationOptions[row - 1]
        case .date:
            return ""
        }
    }
    
    

    //table functions
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {

        let sectionType = FilterSection(rawValue: section)!

        // Header always visible
        if expandedSection != sectionType {
            return 1
        }

        switch sectionType {
        case .sort:
            return 1 + sortOptions.count
        case .category:
            return 1 + categoryOptions.count
        case .location:
            return 1 + locationOptions.count
        case .date:
            return 1
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

            let isDate = sectionType == .date

            cell.configure(
                title: titleForSection(sectionType),
                isExpanded: expandedSection == sectionType,
                showsDate: isDate
            )
            if isDate {
                cell.setDateText(formatDate(selectedDate))
                cell.dateButton.addTarget(
                    self,
                    action: #selector(dateButtonTapped),
                    for: .touchUpInside
                )
            } else {
                cell.arrowButton.tag = indexPath.section
                cell.arrowButton.addTarget(
                    self,
                    action: #selector(arrowTapped(_:)),
                    for: .touchUpInside
                )
            }

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

        case .category:
            isChecked = selectedCategories.contains(value)

        case .location:
            isChecked = selectedLocations.contains(value)

        case .date:
            isChecked = false
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

        case .category:
            if selectedCategories.contains(value) {
                selectedCategories.remove(value)
            } else {
                selectedCategories.insert(value)
            }

        case .location:
            if selectedLocations.contains(value) {
                selectedLocations.remove(value)
            } else {
                selectedLocations.insert(value)
            }

        case .date:
            break
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
            navigationItem.title = "Sort and Filters"
        
        
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels   
        picker.date = selectedDate
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

        hiddenDateTextField.inputView = picker
        hiddenDateTextField.isHidden = true
        view.addSubview(hiddenDateTextField)
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneWithDatePicker))

        toolbar.items = [flex, done]
        hiddenDateTextField.inputAccessoryView = toolbar

        styleActionButton(clearButton)
        styleActionButton(showButton)


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

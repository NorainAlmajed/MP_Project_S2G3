//
//  RaghadSection3TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 13/12/2025.
//

import UIKit

class RaghadSection3TableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lblFoodCategory: UILabel!
    
    @IBOutlet weak var btnFoodCategory: UIButton!
    
    
    @IBOutlet weak var dropdownTableView: UITableView!
    
    
    @IBOutlet weak var dropdownHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var lblFoodCategoryError: UILabel!
    
    
    @IBOutlet weak var foodCategoryErrorHeight: NSLayoutConstraint!

    
    
    
    
    // ✅ Keep this if you want to notify the ViewController
    var onCategoryChanged: ((String) -> Void)?
    // ✅🍔 NEW: tell VC open/close happened 15.12.2025
    var onToggleDropdown: ((Bool) -> Void)?
    
    // ✅ CHANGE 2: Make categories a property (so table view can use it)
    private let categories = [
        "Bakery",
        "Dairy",
        "Produce",
        "Poultry",
        "Beverages",
        "Canned Food",
        "Others"
    ]
    
    // ✅ CHANGE 3: Add rowHeight + open/close state
    private let rowHeight: CGFloat = 56
    private var isDropdownOpen = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        print("✅ btnFoodCategory is nil? \(btnFoodCategory == nil)")
        print("✅ dropdownTableView is nil? \(dropdownTableView == nil)")
        print("✅ dropdownHeightConstraint is nil? \(dropdownHeightConstraint == nil)")
        
        
        
        
        selectionStyle = .none
        
        // ✅ CHANGE 4: Instead of UIMenu, we set up the TABLE dropdown
        setupButtonStyle()
        setupDropdownTable()
        
        // ✅ CHANGE 5: Start CLOSED (height = 0)
        closeDropdown(animated: false)
        
        lblFoodCategoryError.isHidden = true          // 🔴🙈 NEW
        foodCategoryErrorHeight.constant = 0          // 🔴📏 NEW
    }
    
    // ✅ NEW: Button style only (same as your input-field look)
    private func setupButtonStyle() {
        btnFoodCategory.backgroundColor = .clear
        btnFoodCategory.layer.borderWidth = 1
        btnFoodCategory.layer.borderColor = UIColor.systemGray4.cgColor
        btnFoodCategory.layer.cornerRadius = 8
        btnFoodCategory.clipsToBounds = true
        
        // ✅🍔 NEW: keep button height stable (no wrapping)
        btnFoodCategory.titleLabel?.numberOfLines = 1
        btnFoodCategory.titleLabel?.lineBreakMode = .byTruncatingTail
        
        var config = UIButton.Configuration.plain()
        config.title = "Choose Food Type"
        config.baseForegroundColor = .systemGray
        config.background.backgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)

        
        // ✅🍔 NEW: don't allow configuration to change size weirdly
        config.titleAlignment = .leading
        
        
        btnFoodCategory.configuration = config
        btnFoodCategory.contentHorizontalAlignment = .leading
    }
    
    // ✅ NEW: Setup the dropdown table view under the button
    private func setupDropdownTable() {
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        
        dropdownTableView.isScrollEnabled = false
        dropdownTableView.layer.cornerRadius = 12
        dropdownTableView.clipsToBounds = true
    }
    
    // ✅ CHANGE 6: Add IBAction for the button (UIMenu not used now)
    // In storyboard connect: Touch Up Inside -> foodCategoryTapped
    @IBAction func foodCategoryTapped(_ sender: UIButton) {
        //            if isDropdownOpen {
        //                closeDropdown(animated: true)
        //            } else {
        //                openDropdown(animated: true)
        //            }
        //        } 15.12.2025
        
        if isDropdownOpen {
            closeDropdown(animated: true)
            onToggleDropdown?(false)   // ✅🍔
        } else {
            openDropdown(animated: true)
            onToggleDropdown?(true)    // ✅🍔
        }
    }
    
    
    
    
    
    
    
    
    
    // ✅ NEW: Open dropdown by increasing height constraint
    private func openDropdown(animated: Bool) {
        isDropdownOpen = true
        dropdownTableView.isHidden = false
        dropdownHeightConstraint.constant = rowHeight * CGFloat(categories.count)
        
        if animated {
            UIView.animate(withDuration: 0.0) {
                self.contentView.layoutIfNeeded()
            }
        } else {
            contentView.layoutIfNeeded()
        }
    }
    
    // ✅ NEW: Close dropdown by setting height = 0
    private func closeDropdown(animated: Bool) {
        isDropdownOpen = false
        dropdownHeightConstraint.constant = 0
        
        let finish = {
            self.dropdownTableView.isHidden = true
        }
        
        if animated {
            UIView.animate(withDuration: 0.0, animations: {
                self.contentView.layoutIfNeeded()
            }, completion: { _ in
                finish()
            })
        } else {
            contentView.layoutIfNeeded()
            finish()
        }
    }
    
    // ✅ CHANGE 7: This now updates the button title AND calls onCategoryChanged
    private func updateSelectedCategory(_ category: String) {
        // ✅🍔 keep same configuration style, only change title + color
        var config = btnFoodCategory.configuration ?? UIButton.Configuration.plain()
        config.title = category
        config.baseForegroundColor = .label
        btnFoodCategory.configuration = config
        
        onCategoryChanged?(category)
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ✅ Simple dropdown cell
        let cell = UITableViewCell(style: .default, reuseIdentifier: "DropCell")
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    
    
    
    
   
        
        // ✅ Update button title
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let selected = categories[indexPath.row]
            
            // ✅ update button title
            var config = btnFoodCategory.configuration ?? UIButton.Configuration.plain()
            config.title = selected
            config.baseForegroundColor = .label
            btnFoodCategory.configuration = config
            
            // ✅ notify VC: selected value
            onCategoryChanged?(selected)
            
            // ✅ hide error
            lblFoodCategoryError.isHidden = true
            foodCategoryErrorHeight.constant = 0
            
            // ✅ IMPORTANT: tell VC dropdown is CLOSED
            onToggleDropdown?(false)
            
            // ✅ close dropdown inside the cell
            closeDropdown(animated: false)
            
            tableView.deselectRow(at: indexPath, animated: false)
            contentView.layoutIfNeeded()
        }
    
    
    

    
   
    
    func configure(selected: String?, isOpen: Bool, showError: Bool) {

        // 🔴 Error UI
        lblFoodCategoryError.text = "Please choose a food category"
        lblFoodCategoryError.textColor = .systemRed

        lblFoodCategoryError.isHidden = !showError
        foodCategoryErrorHeight.constant = showError ? 18 : 0   // 🔴📏 IMPORTANT

        // ✅ Button title
        if let selected = selected {
            var config = btnFoodCategory.configuration
            config?.title = selected
            config?.baseForegroundColor = .label
            btnFoodCategory.configuration = config
        } else {
            var config = btnFoodCategory.configuration
            config?.title = "Choose Food Type"
            config?.baseForegroundColor = .systemGray
            btnFoodCategory.configuration = config
        }

        // ✅ Dropdown state
        if isOpen {
            openDropdown(animated: false)
        } else {
            closeDropdown(animated: false)
        }

        contentView.layoutIfNeeded() // 🧱✅ keeps layout stable
    }

    
    
    
    
    
    
    
    
    
}
    

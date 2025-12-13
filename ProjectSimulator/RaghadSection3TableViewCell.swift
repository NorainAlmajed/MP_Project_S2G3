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
//
    
    
    
    
   

        // ✅ Keep this if you want to notify the ViewController
        var onCategoryChanged: ((String) -> Void)?

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

            selectionStyle = .none

            // ✅ CHANGE 4: Instead of UIMenu, we set up the TABLE dropdown
            setupButtonStyle()
            setupDropdownTable()

            // ✅ CHANGE 5: Start CLOSED (height = 0)
            closeDropdown(animated: false)
        }

        // ✅ NEW: Button style only (same as your input-field look)
        private func setupButtonStyle() {
            btnFoodCategory.backgroundColor = .clear
            btnFoodCategory.layer.borderWidth = 1
            btnFoodCategory.layer.borderColor = UIColor.systemGray4.cgColor
            btnFoodCategory.layer.cornerRadius = 8
            btnFoodCategory.clipsToBounds = true

            var config = UIButton.Configuration.plain()
            config.title = "Choose Food Type"
            config.baseForegroundColor = .systemGray
            config.background.backgroundColor = .clear
            config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)

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
            if isDropdownOpen {
                closeDropdown(animated: true)
            } else {
                openDropdown(animated: true)
            }
        }

        // ✅ NEW: Open dropdown by increasing height constraint
        private func openDropdown(animated: Bool) {
            isDropdownOpen = true
            dropdownTableView.isHidden = false
            dropdownHeightConstraint.constant = rowHeight * CGFloat(categories.count)

            if animated {
                UIView.animate(withDuration: 0.2) {
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
                UIView.animate(withDuration: 0.2, animations: {
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
            var config = btnFoodCategory.configuration
            config?.title = category
            config?.baseForegroundColor = .label
            btnFoodCategory.configuration = config

            onCategoryChanged?(category) // ✅ optional callback to VC
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

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selected = categories[indexPath.row]
            updateSelectedCategory(selected)          // ✅ update button title
            tableView.deselectRow(at: indexPath, animated: true)
            closeDropdown(animated: true)             // ✅ close dropdown after choose
        }
    }
    
    
    
    
    
    
    
    
    
//    
//    var onCategoryChanged: ((String) -> Void)?
//
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        // Initialization code
////        setupFoodCategoryDropdown()
////                selectionStyle = .none
////
////    }
////    private func setupFoodCategoryDropdown() {
////
////            // 1️⃣ Categories
////            let categories = [
////                "Bakery",
////                "Dairy",
////                "Produce",
////                "Poultry",
////                "Beverages",
////                "Canned Food",
////                "Others"
////            ]
//        
//        
//        
//        private let categories = [
//               "Bakery",
//               "Dairy",
//               "Produce",
//               "Poultry",
//               "Beverages",
//               "Canned Food",
//               "Others"
//           ]
//
//            // 2️⃣ Create dropdown actions
//            let actions = categories.map { category in
//                UIAction(title: category) { [weak self] _ in
//                    self?.updateSelectedCategory(category)
//                }
//            }
//
//            // 3️⃣ Assign menu
//            btnFoodCategory.menu = UIMenu(children: actions)
//            btnFoodCategory.showsMenuAsPrimaryAction = true
//
//            // 4️⃣ Style like INPUT FIELD (not button)
//            btnFoodCategory.backgroundColor = .clear
//            btnFoodCategory.layer.borderWidth = 1
//            btnFoodCategory.layer.borderColor = UIColor.systemGray4.cgColor
//            btnFoodCategory.layer.cornerRadius = 8
//            btnFoodCategory.clipsToBounds = true
//
//            // 5️⃣ Button configuration (NO BLUE)
//            var config = UIButton.Configuration.plain()
//            config.title = "Choose Food Type"
//            config.baseForegroundColor = .systemGray
//            config.background.backgroundColor = .clear
//            config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
//
//            btnFoodCategory.configuration = config
//            btnFoodCategory.contentHorizontalAlignment = .leading
//        }
//
//        private func updateSelectedCategory(_ category: String) {
//            var config = btnFoodCategory.configuration
//            config?.title = category
//            config?.baseForegroundColor = .label
//            btnFoodCategory.configuration = config
//        }
//    
//       
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}

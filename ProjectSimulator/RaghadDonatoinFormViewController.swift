//
//  RaghadDonatoinFormViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 13/12/2025.
//

import UIKit

//class RaghadDonatoinFormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    
    
class RaghadDonatoinFormViewController: UIViewController,
                                       UITableViewDelegate,
                                       UITableViewDataSource,
                                       UIImagePickerControllerDelegate,
                                       UINavigationControllerDelegate,
                                        RaghadSection1TableViewCellDelegate,
                                        DonorSelectionDelegate {
    
    private var shouldShowDonorError = false   // ✅ NEW
    private var shouldShowImageError = false   // ✅ NEW: upload image validation
    private var shouldShowQuantityError = false   // 🔢❌ Quantity error
    private var quantityValue: Int?   // 🔢 stores user quantity
    private var weightValue: Double?
    private var shouldShowWeightError = false
    private var selectedExpiryDate: Date?   // 📅 stores the user-selected expiry date
    // ✅🔐 Admin check from your current logged user
    private var isAdminUser: Bool {
        return user.isAdmin
    }
    
    
    
    // for the dropdown list this the code  15.12.2025
    
    // ✅🍔 NEW
    private var selectedFoodCategory: String? = nil
    private var isFoodDropdownOpen: Bool = false
//for dropdownlist validation
    private var shouldShowFoodCategoryError = false   // 🍔❌ NEW


    
    
    
    @IBOutlet weak var donationFormTableview: UITableView!
    // ✅ Stores the selected image so it doesn’t disappear when you scroll
    private var selectedDonationImage: UIImage?////new
    // ✅ NEW: store selected donor name (to show on Section2 button)
    private var selectedDonorName: String?
    
   

    
      
        override func viewDidLoad() {
            super.viewDidLoad()

            //donationFormTableview.separatorStyle = .none🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐 remove the comment to remove the lines in the table view

            print("🔐 Current user:", user.username)
            print("👤 Is Admin?", user.isAdmin)

            donationFormTableview.delegate = self
            donationFormTableview.dataSource = self

            self.title = "Donation Form"
            navigationController?.navigationBar.prefersLargeTitles = false

            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)

            donationFormTableview.keyboardDismissMode = .onDrag
            addDoneButtonOnKeyboard()
            
            
            // for the dropdown list this the code  15.12.2025
            
            // ✅🍔 NEW (safe)
            //chat says remove this donationFormTableview.rowHeight = UITableView.automaticDimension
            donationFormTableview.estimatedRowHeight = 200

            
        }

    
    
    
    func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                   target: nil,
                                   action: nil)
        
        let done = UIBarButtonItem(title: "Done",
                                   style: .done,
                                   target: self,
                                   action: #selector(doneButtonTapped))
        
        toolbar.items = [flex, done]
        
        // attach to all textfields in this view
        view.subviews.forEach { view in
            if let textField = view as? UITextField {
                textField.inputAccessoryView = toolbar
            }
        }
    }
    
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func doneButtonTapped() { //to add done in the keyboard
        view.endEditing(true)
    }
    
    
    
    
    //    func numberOfSections(in donationFormTableview: UITableView) -> Int {
    //        return 8   // or any number you want
    //    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 8
//    }//he told me to put this insatde of thr one in the tpop
//    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isAdminUser ? 8 : 7   // ✅ remove Choose Donor section if NOT admin
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let section = indexPath.section

        // ✅ If NOT admin, skip donor section by shifting sections after 0
        let adjustedSection = (!isAdminUser && section >= 1) ? section + 1 : section

        // ✅ Section 1 only
        if adjustedSection == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Section1Cell",
                                                           for: indexPath) as? RaghadSection1TableViewCell else {
                fatalError("Section1Cell not found OR class not set")
            }
            
            cell.selectionStyle = .none
            cell.delegate = self
            
            cell.setDonationImage(selectedDonationImage)
            cell.configure(showError: shouldShowImageError)
            cell.lblImageError.text = "Please upload an image"
            
            return cell
        }
        
        
        
        if adjustedSection == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Section2Cell", for: indexPath) as? RaghadSection2TableViewCell else {
                fatalError("Section2Cell not found OR class not set to RaghadSection2TableViewCell in storyboard")
            }
            
            cell.selectionStyle = .none
            
            // ✅ NEW: show selected donor name on the button (or default)
            cell.configure(
                donorName: selectedDonorName,
                showError: shouldShowDonorError
            )
            
            
            // ✅ NEW: button tap opens donor list page
            cell.btnChooseDonor2.removeTarget(nil, action: nil, for: .allEvents) // avoids double-taps
            cell.btnChooseDonor2.addTarget(self, action: #selector(openDonorList), for: .touchUpInside)
            
            return cell
        }
        
//        // 🍔 Section 3 (Food Category)
//        if adjustedSection == 2 {
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: "Section3Cell",
//                for: indexPath
//            )
//            cell.selectionStyle = .none
//            return cell
//        }
//
//        
//        
//        if adjustedSection == 3 {
//            guard let cell = tableView.dequeueReusableCell(
//                withIdentifier: "Section4Cell",
//                for: indexPath
//            ) as? RaghadSection4TableViewCell else {
//                fatalError("❌ Section4Cell not set correctly")
//            }
//
//            cell.selectionStyle = .none
//            cell.configure(showError: shouldShowQuantityError)
//
//            // ✅ keep quantity saved even if cell disappears
//            cell.onQuantityChanged = { [weak self] value in
//                self?.quantityValue = value
//                if value != nil && (value ?? 0) > 0 {
//                    self?.shouldShowQuantityError = false
//                }
//            }
//
//            return cell
//        } i made comment for them 15.12.2025 and i replcae it with the code under it
        
        
        // 🍔 Section 3 (Food Category)
        if adjustedSection == 2 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "Section3Cell",
                for: indexPath
            ) as? RaghadSection3TableViewCell else {
                fatalError("❌ Section3Cell not set correctly")
            }

            cell.selectionStyle = .none

            // ✅🍔 show saved selection + open/close state
            cell.configure(
                selected: selectedFoodCategory,
                isOpen: isFoodDropdownOpen,
                showError: shouldShowFoodCategoryError   // 🍔❌ NEW
            )

            // ✅🍔 when user selects a category
            cell.onCategoryChanged = { [weak self] category in
                guard let self = self else { return }
                self.selectedFoodCategory = category
                self.isFoodDropdownOpen = false
                self.shouldShowFoodCategoryError = false   // 🟢✅

                self.donationFormTableview.beginUpdates()
                self.donationFormTableview.endUpdates()
            }

            // ✅🍔 when user taps button open/close
            cell.onToggleDropdown = { [weak self] open in
                guard let self = self else { return }
                self.isFoodDropdownOpen = open

                self.donationFormTableview.beginUpdates()
                self.donationFormTableview.endUpdates()

                // ✅🍔 ensures dropdown is visible (pushes content up if near bottom)
                let ip = IndexPath(row: 0, section: indexPath.section)
                self.donationFormTableview.scrollToRow(at: ip, at: .none, animated: true)
            }

            return cell
        }


        
        
        
        
        
        
        
        

        
        
        // ⚖️ Section 5 (Weight) = index 4
        if adjustedSection == 4 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "Section5Cell",
                for: indexPath
            ) as? RaghadSection5TableViewCell else {
                fatalError("❌ Section5Cell not set correctly")
            }

            cell.selectionStyle = .none

            // 🔴 show / hide error
            cell.configure(showError: shouldShowWeightError)

            // 🔁 receive weight from cell
            cell.onWeightChanged = { [weak self] value in
                self?.weightValue = value

                // 🟢 clear error when valid
                if value != nil {
                    self?.shouldShowWeightError = false
                }
            }

            return cell
        }

        
        
//     
        
        
        // 📅✅ Section 6 (Expiry Date) = index 5
        if adjustedSection == 5 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "Section6Cell",
                for: indexPath
            ) as? RaghadSection6TableViewCell else {
                fatalError("❌ Section6Cell not set correctly")
            }

            cell.selectionStyle = .none

            // ✅🟢 Always show the saved date (or tomorrow if nil)
            cell.configure(date: selectedExpiryDate)

            // ✅🟢 Save the selected date ONLY (no reload here!)
            cell.onDateSelected = { [weak self] date in
                self?.selectedExpiryDate = date   // 📅 save date safely
            }

            return cell
        }

        
        
        
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Section\(adjustedSection + 1)Cell",
            for: indexPath
        )
        cell.selectionStyle = .none
        return cell

    }
    
    
    
    
    
    
   
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = indexPath.section
        let adjustedSection = (!isAdminUser && section >= 1) ? section + 1 : section
        
        switch adjustedSection {
        case 0:
            return 237   // Section1Cell
        case 1:
            return 108   // Section2Cell
        //case 2:
           //return UITableView.automaticDimension  //233  //Section3Cell // for the dropdown list this the code 15.12.2025
//            let base: CGFloat = 44 /*button*/ + 8 /*space*/ + 20 /*label*/ + 12 + 12 /*top+bottom margins*/
//            let errorHeight: CGFloat = shouldShowFoodCategoryError ? 18 : 0   // 🔴✅ NEW
//            return base + errorHeight + dropdown
            
        case 2:
            let base: CGFloat = 44 /*button*/ + 8 /*space*/ + 20 /*label*/ + 12 + 12 /*top+bottom margins*/

            let dropdownHeight: CGFloat = isFoodDropdownOpen ? (56 * 7 + 8) : 0   // 56=rowHeight, 7=items
            let errorHeight: CGFloat = shouldShowFoodCategoryError ? 18 : 0       // 🔴 error label height

            return base + dropdownHeight + errorHeight

        case 3:
            return 109  // Section4Cell
        case 4:
            return 102  // Section5Cell
        case 5:
            return 93  // Section6Cell
        case 6:
            return 161  // ✅ Section7Cell (choose height)
        case 7:
            return 62 // ✅ Section8Cell (choose height)
        default:
            return 62
        }
    }
    
    // ✅ NEW: open donor list page (present as modal with nav bar)
    //    @objc private func openDonorList() {
    //        let sb = UIStoryboard(name: "Raghad1", bundle: nil)
    //        let vc = sb.instantiateViewController(
    //            withIdentifier: "RaghadDonorListViewController"
    //        ) as! RaghadDonorListViewController
    //
    //        vc.delegate = self
    //        let nav = UINavigationController(rootViewController: vc)
    //        present(nav, animated: true)
    //    }
    
    
    
    
    
    
    @objc private func openDonorList() {
        
        // ✅ make sure the storyboard name matches your file: Raghad1.storyboard
        let sb = UIStoryboard(name: "Raghad1", bundle: nil)
        
        // ✅ SAFE: if the ID is not set correctly, it will print and not crash
        guard let vc = sb.instantiateViewController(withIdentifier: "RaghadDonorListViewController") as? RaghadDonorListViewController else {
            print("❌ FIX STORYBOARD: In Raghad1.storyboard, set the donor list VC Storyboard ID to: RaghadDonorListViewController")
            return
        }
        
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    
    
    // ✅ NEW: receive chosen donor name from donor list (Done button)
    func didSelectDonor(name: String) {
        selectedDonorName = name
        shouldShowDonorError = false

        if isAdminUser {
            donationFormTableview.reloadSections(IndexSet(integer: 1), with: .none) // ✅ donor section exists
        } else {
            donationFormTableview.reloadData() // ✅ safe fallback
        }
    }

    
    
    //  NEW: resize image (THIS is what tutors like)
    private func resizedImage(_ image: UIImage, maxWidth: CGFloat) -> UIImage {
        
        // If already small, don’t resize
        if image.size.width <= maxWidth { return image }
        
        let scale = maxWidth / image.size.width
        let newSize = CGSize(
            width: maxWidth,
            height: image.size.height * scale
        )
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resized ?? image
    }
    
    
    
    
    
    
    
    
    // ✅ Delegate method from Section 1 cell
    func section1DidTapUploadImage(_ cell: RaghadSection1TableViewCell) {
        
        let alert = UIAlertController(title: "Upload Image",
                                      message: "Choose a source",
                                      preferredStyle: .actionSheet)
        
        // ✅ Camera option (only shows if available)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Take Photo (Camera)", style: .default) { [weak self] _ in
                self?.openImagePicker(sourceType: .camera)
            })
        }
        
        // ✅ Photo Library option
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.openImagePicker(sourceType: .photoLibrary)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // ✅ Prevents iPad crash for actionSheet
        if let popover = alert.popoverPresentationController {
            popover.sourceView = cell
            popover.sourceRect = cell.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = true // user can crop
        present(picker, animated: true)
    }
    
    // ✅ User picked an image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let img = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        
        if let img = img {
            
            // ✅ NEW: resize image before saving (change 900 if you want)
            let resized = resizedImage(img, maxWidth: 900)
            
            selectedDonationImage = resized
            shouldShowImageError = false   // ✅ clear image error once image is chosen
            
            
            
            var sectionsToReload: [Int] = [0, 3, 4, 5]  // image, quantity, weight, expiry
            if isAdminUser { sectionsToReload.insert(1, at: 1) } // donor only if admin
            // ✅ refresh only Section 1
            donationFormTableview.reloadSections(IndexSet(sectionsToReload), with: .none)
        }
        
        
        
        
        
        picker.dismiss(animated: true)
    }
    
    // ✅ User cancelled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    
    // ✅ PROCEED BUTTON VALIDATION (ADD THIS IN DONATION FORM VC)
//    @IBAction func proceedTapped(_ sender: UIButton) { caht say you can delete this but i will run first to check ther eis no errors
//        
//        // ❌ Admin did NOT choose donor
//        if selectedDonorName == nil {
//            shouldShowDonorError = true
//            
//            // refresh only Section 2 (Choose Donor cell)
//            donationFormTableview.reloadSections(
//                IndexSet(integer: 1),
//                with: .none
//            )
//            return
//        }
//        
//        // ✅ Donor selected → continue normally
//        shouldShowDonorError = false
//        
//        // TODO: navigate to Schedule Pickup page
//    }
//    
    
    
    
    
    
    
    
    
    
    
    
    private func getQuantityValue() -> Int? {
        let indexPath = IndexPath(row: 0, section: 3)
        
        guard let cell = donationFormTableview.cellForRow(at: indexPath)
                as? RaghadSection4TableViewCell else {
            return nil
        }
        
        return cell.getQuantityValue()   // 👈 method you added in the cell
    }
    
    
    
    
    
    // ✅ TEST ONLY: This function is ONLY to test that the Proceed button is connected
    // and to test donor error handling. Your teammate will later replace this navigation.
    private func handleProceedTapped_TEST_ONLY() {
        
        let missingImage = (selectedDonationImage == nil)      // 📸❌
        let missingDonor = isAdminUser ? (selectedDonorName == nil) : false
       // 👤❌
        let invalidWeight = (weightValue == nil)   // ⚖️❌
        shouldShowWeightError = invalidWeight

        
        let quantity = quantityValue
        let invalidQuantity = (quantity == nil || (quantity ?? 0) <= 0)
        
        let missingFoodCategory = (selectedFoodCategory == nil)   // 🍔❌ NEW
        shouldShowFoodCategoryError = missingFoodCategory         // 🍔❌ NEW


        
        // 🔴 set flags
        shouldShowImageError = missingImage
        shouldShowDonorError = missingDonor
        shouldShowQuantityError = invalidQuantity
        shouldShowWeightError = invalidWeight
        
        // 🔄 reload affected sections
//        donationFormTableview.reloadSections(
//            IndexSet([0, 1, 3, 4,5]),
//            with: .none)
        var sectionsToReload: [Int] = [0, 2, 3, 4, 5]   // ✅🍔 added 2
        if isAdminUser { sectionsToReload.insert(1, at: 1) }
        donationFormTableview.reloadSections(IndexSet(sectionsToReload), with: .none)


        

        
        // ❌ Stop if ANY error exists
        if missingImage || missingDonor || missingFoodCategory || invalidQuantity || invalidWeight {
            return
        }

        
        // ✅ All valid → Navigate
        let sb = UIStoryboard(name: "Raghad1", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SchedulePickupVC")
        navigationController?.pushViewController(vc, animated: true)
        
        
        
        
        
        
        
        
    }
    // ✅🟢 Proceed button action (connect this to your Proceed button)
    @IBAction func proceedTapped(_ sender: UIButton) {
        handleProceedTapped_TEST_ONLY()
    }

}

    // TEST ONLY navigation — this screen is NOT implemented by me.
// It exists only to verify that the Proceed button is connected
// and that validation logic works correctly.

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    
    }*/



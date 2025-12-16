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
        donationFormTableview.rowHeight = UITableView.automaticDimension
        
        
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
        
        
        
        
        
        // 🍔 Section 3 (Food Category) = adjustedSection 2
        if adjustedSection == 2 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "Section3Cell",
                for: indexPath
            ) as? RaghadSection3TableViewCell else {
                fatalError("❌ Section3Cell not set correctly")
            }
            
            cell.selectionStyle = .none
            
            // ✅ show saved selection + open/close state + error
            cell.configure(
                selected: selectedFoodCategory,
                isOpen: isFoodDropdownOpen,
                showError: shouldShowFoodCategoryError
            )
            
            // ✅ when user taps open/close
            cell.onToggleDropdown = { [weak self] open in
                guard let self = self else { return }
                self.isFoodDropdownOpen = open
                
                UIView.performWithoutAnimation {
                    self.donationFormTableview.reloadRows(at: [indexPath], with: .none)
                }
            }
            
            // ✅ when user selects category
            cell.onCategoryChanged = { [weak self] category in
                guard let self = self else { return }
                
                self.selectedFoodCategory = category
                self.isFoodDropdownOpen = false
                self.shouldShowFoodCategoryError = false   // ✅ IMPORTANT FIX ✅
                
                UIView.performWithoutAnimation {
                    self.donationFormTableview.reloadRows(at: [indexPath], with: .none)
                }
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
  
        
        // 📅✅ Section 6 (Expiry Date) = index 5
        if adjustedSection == 5 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "Section6Cell",
                for: indexPath
            ) as? RaghadSection6TableViewCell else {
                fatalError("❌ Section6Cell not set correctly")
            }
            
            cell.selectionStyle = .none
            
            cell.configure(date: selectedExpiryDate)
            
            cell.onDateSelected = { [weak self] date in
                guard let self = self else { return }
                
                self.selectedExpiryDate = date   // ✅ save in VC
                
                // ✅ IMPORTANT: refresh ONLY expiry section so it doesn't jump/reset
                self.donationFormTableview.reloadSections(
                    IndexSet(integer: indexPath.section),
                    with: .none
                )
            }
            return cell 
        }
        
        
        
        
        // ✅🟣 Section 8 = Proceed button
        if adjustedSection == 7 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "Section8Cell",
                for: indexPath
            ) as? RaghadSection8TableViewCell else {
                fatalError("❌ Section8Cell not set correctly")
            }
            
            cell.selectionStyle = .none
            
            // ✅🟢 When user taps Proceed → validate first
            cell.onProceedTapped = { [weak self] in
                guard let self = self else { return }
                self.validateAndProceed()   // ✅🔒 only navigate if valid
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
        case 2:
            return UITableView.automaticDimension
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
 
    func section1DidTapUploadImage(_ cell: RaghadSection1TableViewCell) {
        
        let alert = UIAlertController(
            title: "Upload Image",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        // 📷 Take Photo (Camera)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.openCamera()
        })
        
        // 🖼 Choose from Library
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.openPhotoLibrary()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // iPad safety
        if let pop = alert.popoverPresentationController {
            pop.sourceView = cell
            pop.sourceRect = cell.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            openImagePicker(sourceType: .camera)        // 📷 real device
        } else {
            openImagePicker(sourceType: .photoLibrary)  // 🧪 simulator fallback
        }
    }
    
    
    
    private func openPhotoLibrary() {
        openImagePicker(sourceType: .photoLibrary)
    }
    
    
    
    
    
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = true   // 🔍 zoom / crop (THIS is what you want)
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
        view.endEditing(true)
        
        let sectionsToReload: [Int]
        if isAdminUser {
            sectionsToReload = [0, 1, 2, 3, 4, 5]
        } else {
            sectionsToReload = [0, 1, 2, 3, 4]
        }
        
        donationFormTableview.reloadSections(IndexSet(sectionsToReload), with: .none)
        
        
        
        if !missingImage &&
            !missingDonor &&
            !invalidQuantity &&
            !invalidWeight &&
            !missingFoodCategory {
            
            print("✅ Form valid — navigate to Schedule Pickup")
            
            // TEMP TEST navigation (replace later)
            let alert = UIAlertController(
                title: "Success",
                message: "Form is valid. Ready to navigate.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            
            return
        }
        
        
        
        
        
        
        
        
    }
    // ✅🟢 Proceed button action (connect this to your Proceed button)
    @IBAction func proceedTapped(_ sender: UIButton) {
        handleProceedTapped_TEST_ONLY()
    }
    
    
    private func validateAndProceed() {
        let missingImage = (selectedDonationImage == nil)
        let missingFoodCategory = (selectedFoodCategory == nil)
        let invalidWeight = (weightValue == nil)
        let missingDonor = user.isAdmin && (selectedDonorName == nil)
        
        if missingImage || missingFoodCategory || invalidWeight || missingDonor {
            //    donationFormTableview.reloadData()❌❌❌❌❌❌❌❌❌
            return
        }
        
        performSegue(withIdentifier: "showSchedulePickup", sender: self)
    }
}



    
    


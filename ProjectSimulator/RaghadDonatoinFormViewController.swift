////
////  RaghadDonatoinFormViewController.swift
////  ProjectSimulator
////
////  Created by Raghad Aleskafi on 13/12/2025.
////

//
//
//    
//    
//
//
//  RaghadDonatoinFormViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 13/12/2025.
//
//
//  RaghadDonatoinFormViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 13/12/2025.
//
//
//  RaghadDonatoinFormViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 13/12/2025.
//

import FirebaseFirestore
import Cloudinary   // add this at the top of the file
import UIKit
import PhotosUI   // optional if you switch to PHPicker later

class RaghadDonatoinFormViewController: UIViewController,
                                        UITableViewDelegate,
                                        UITableViewDataSource,
                                        UIImagePickerControllerDelegate,
                                        UINavigationControllerDelegate,
                                        RaghadSection1TableViewCellDelegate,
                                        DonorSelectionDelegate {
    func section1DidTapUploadImage(_ cell: RaghadSection1TableViewCell) {
        // Show options to pick an image
        let alert = UIAlertController(title: "Upload Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
            self?.openCamera()
        })
        
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.openPhotoLibrary()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // iPad popover anchor
        if let pop = alert.popoverPresentationController {
            pop.sourceView = cell
            pop.sourceRect = cell.bounds
        }
        
        present(alert, animated: true)
    }
    var selectedNgo: NGO?
    
    // MARK: - State / Validation
    private var shouldShowDonorError = false
    private var shouldShowImageError = false
    private var shouldShowQuantityError = false
    //private var quantityValue: Int?
    private var weightValue: Double?
    private var weightInvalidFormat = false
    private var shouldShowWeightError = false
    private var selectedExpiryDate: Date?
    
    
    
    //for the keyboard
    private var activeIndexPath: IndexPath?
    private var keyboardObservers: [NSObjectProtocol] = []
    // 🟢 BASE WHITE SPACE under button (always)
    private let baseBottomSpace: CGFloat = 20  // 👈 change 24~40 as you like (small)
    private var isKeyboardShowing = false



    
    private var isAdminUser: Bool { user.isAdmin }
    
    // Dropdown (Food Category)
    private var selectedFoodCategory: String? = nil
    private var isFoodDropdownOpen: Bool = false
    private var shouldShowFoodCategoryError = false
    
    // Image + Donor
    @IBOutlet weak var donationFormTableview: UITableView!
    private var selectedDonationImage: UIImage?
    private var selectedDonorName: String?
    
    
    private let cloudinaryService = CloudinaryService()
    
    private var uploadedDonationImageUrl: String?   // ✅ Cloudinary URL after upload
    private var isUploadingImage = false            // ✅ block proceed while uploading
    
    
    private var draftImage: UIImage?          // keeps photo in memory
    private var draftQuantity: Int = 1        // keeps quantity
    private var draftDescription: String?     // keeps description text
    private var selectedQuantity: Int = 1
    private var selectedShortDescription: String?   // ✅ keeps text even after reload

    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        donationFormTableview.separatorStyle = .none
        donationFormTableview.delegate = self
        donationFormTableview.dataSource = self
        
        title = "Donation Form"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        donationFormTableview.keyboardDismissMode = .onDrag
        addDoneButtonOnKeyboard()
        
        // Self-sizing cells (use the IBOutlet table, not `tableView`)
        donationFormTableview.estimatedRowHeight = 200
        donationFormTableview.rowHeight = UITableView.automaticDimension
        
        print("🔐 Current user:", user.username, " | 👤 Is Admin?", user.isAdmin)
        
        
        
        
        //for the last elemnt button 👤  👤  👤  👤  👤  👤  👤  👤  👤  👤
//        let extra: CGFloat = view.safeAreaInsets.bottom + 40   // ✅ enough space for button
//        donationFormTableview.contentInset.bottom = extra
//        donationFormTableview.verticalScrollIndicatorInsets.bottom = extra
//        
//        // ✅ also add a footer so you can always scroll past last cell
//        if donationFormTableview.tableFooterView == nil || donationFormTableview.tableFooterView?.frame.height != extra {
//            donationFormTableview.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: extra))
//        }
        
        
        // ✅ NO permanent extra space (keyboard code will handle it)
//        donationFormTableview.contentInset.bottom = 0
////        donationFormTableview.scrollIndicatorInsets.bottom = 0
//        donationFormTableview.verticalScrollIndicatorInsets.bottom = 0
//
//        donationFormTableview.tableFooterView = UIView(frame: .zero)
       


        setupKeyboardAvoidance()

       


       

    }
    
    
    // 🟢 ALWAYS keep small white space under the last cell (even with no keyboard)
    private func applyBaseBottomInset() {
        let base = baseBottomSpace + view.safeAreaInsets.bottom  // ✅ includes home indicator safe area

        donationFormTableview.contentInset.bottom = base
        donationFormTableview.verticalScrollIndicatorInsets.bottom = base

        // ✅ footer lets you scroll a bit past the button
        if donationFormTableview.tableFooterView?.frame.height != base {
            donationFormTableview.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: base))
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isKeyboardShowing { applyBaseBottomInset() }   // ✅ only when keyboard is NOT showing
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isKeyboardShowing { applyBaseBottomInset() }   // ✅ fixes “first time open page” issue
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Keyboard helpers
    func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flex, done]
        view.subviews.forEach { v in
            if let tf = v as? UITextField { tf.inputAccessoryView = toolbar }
        }
    }
    @objc func dismissKeyboard() { view.endEditing(true) }
    @objc func doneButtonTapped() { view.endEditing(true) }
    
    // MARK: - Table DataSource
    func numberOfSections(in tableView: UITableView) -> Int { isAdminUser ? 8 : 7 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        // If NOT admin, skip donor section by shifting sections after 0
        let adjustedSection = (!isAdminUser && section >= 1) ? section + 1 : section
        
        // Section 1 (Image)
        if adjustedSection == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Section1Cell", for: indexPath) as! RaghadSection1TableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.setDonationImage(selectedDonationImage)
            cell.configure(showError: shouldShowImageError)
            cell.lblImageError.text = "Please upload an image"
            return cell
        }
        
        // Section 2 (Donor) — admin only
        if adjustedSection == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Section2Cell", for: indexPath) as! RaghadSection2TableViewCell
            cell.selectionStyle = .none
            cell.configure(donorName: selectedDonorName, showError: shouldShowDonorError)
            cell.btnChooseDonor2.removeTarget(nil, action: nil, for: .allEvents)
            cell.btnChooseDonor2.addTarget(self, action: #selector(openDonorList), for: .touchUpInside)
            return cell
        }
        
        // Section 3 (Food Category)
        if adjustedSection == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Section3Cell", for: indexPath) as! RaghadSection3TableViewCell
            cell.selectionStyle = .none
            cell.configure(selected: selectedFoodCategory, isOpen: isFoodDropdownOpen, showError: shouldShowFoodCategoryError)
            
            cell.onToggleDropdown = { [weak self] open in
                guard let self = self else { return }
                self.isFoodDropdownOpen = open
                UIView.performWithoutAnimation {
                    self.donationFormTableview.beginUpdates()
                    self.donationFormTableview.endUpdates()
                }
            }
            cell.onCategoryChanged = { [weak self] category in
                guard let self = self else { return }
                self.selectedFoodCategory = category
                self.isFoodDropdownOpen = false
                self.shouldShowFoodCategoryError = false
                UIView.performWithoutAnimation {
                    self.donationFormTableview.reloadSections(IndexSet(integer: indexPath.section), with: .none)
                }
            }
            return cell
        }
        
        
        
//        if adjustedSection == 3 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Section4Cell", for: indexPath) as! RaghadSection4TableViewCell
//            cell.selectionStyle = .none
//            
//            // ✅ restore saved value (prevents flipping back to 1)
//            let q = quantityValue ?? Int(cell.stepperQuantity.value)
//            cell.txtQuantity.text = "\(max(q, 1))"
//            cell.stepperQuantity.value = Double(max(q, 1))
//            
//            // ✅ SAVE whenever user changes
//            cell.onQuantityChanged = { [weak self] value in
//                guard let self = self else { return }
//                self.quantityValue = value
//                self.shouldShowQuantityError = (value == nil || (value ?? 0) <= 0)
//            }
//            
//            // ✅ show/hide error if you use it
//            cell.configure(showError: shouldShowQuantityError)
//            
//            return cell
//        }
        
        
        
        
        if adjustedSection == 3 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "Section4Cell",
                for: indexPath
            ) as! RaghadSection4TableViewCell

            cell.selectionStyle = .none

            // ✅ ALWAYS restore from VC state
            cell.txtQuantity.text = "\(selectedQuantity)"
            cell.stepperQuantity.value = Double(selectedQuantity)

            // ✅ ALWAYS update VC state when user changes
            cell.onQuantityChanged = { [weak self] value in
                guard let self = self else { return }

                let q = value ?? 0
                self.selectedQuantity = max(q, 1)
                self.shouldShowQuantityError = q <= 0
            }

            cell.configure(showError: shouldShowQuantityError)
            return cell
        }

        
        
        
        
        // ⚖️ Section 5 (Weight)
        if adjustedSection == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Section5Cell", for: indexPath) as! RaghadSection5TableViewCell
            cell.selectionStyle = .none
            
            // ✅ RESTORE saved value so it does NOT flip on reload
            if let w = weightValue {
                cell.txtWeight.text = String(w)   // or "\(w)"
            } else {
                // keep it empty (optional field)
                cell.txtWeight.text = ""
            }
            
            // 🔴 show / hide error
            cell.configure(showError: shouldShowWeightError)
            
            // 🔁 receive updates
            cell.onWeightChanged = { [weak self] value, invalidFormat in
                guard let self = self else { return }
                self.weightValue = value
                self.weightInvalidFormat = invalidFormat
                self.shouldShowWeightError = invalidFormat
            }
            
            return cell
        }
        
        // Section 6 (Expiry)
        if adjustedSection == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Section6Cell", for: indexPath) as! RaghadSection6TableViewCell
            cell.selectionStyle = .none
            cell.configure(date: selectedExpiryDate)
            cell.onDateSelected = { [weak self] date in
                guard let self = self else { return }
                self.selectedExpiryDate = date
                UIView.performWithoutAnimation {
                    self.donationFormTableview.reloadSections(IndexSet(integer: indexPath.section), with: .none)
                }
            }
            return cell
        }
        
        
        //i dont have i just added this
        
//        if adjustedSection == 6 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Section7Cell", for: indexPath) as! RaghadSection7TableViewCell
//            cell.onBeginEditing = { [weak self] in
//                guard let self = self else { return }
//                self.activeIndexPath = indexPath
//                self.donationFormTableview.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)
//            }
//            return cell
//        }

        if adjustedSection == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Section7Cell", for: indexPath) as! RaghadSection7TableViewCell
            cell.selectionStyle = .none

            // ✅ Restore saved text
            if let text = selectedShortDescription, !text.isEmpty {
                cell.txtDescription.text = text
                cell.txtDescription.textColor = .label
                // update counter to match (calls your method indirectly via didChange)
                cell.textViewDidChange(cell.txtDescription)
            }

            // ✅ Save live edits
            cell.onTextChanged = { [weak self] text in
                self?.selectedShortDescription = text
            }

            // keep your keyboard scroll
            cell.onBeginEditing = { [weak self] in
                guard let self = self else { return }
                self.activeIndexPath = indexPath
                self.donationFormTableview.scrollToRow(at: indexPath, at: .middle, animated: true)
            }

            return cell
        }

        
        
        
        
        // Section 8 (Proceed button)
        if adjustedSection == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Section8Cell", for: indexPath) as! RaghadSection8TableViewCell
            cell.selectionStyle = .none
            cell.onProceedTapped = { [weak self] in
                guard let self = self else { return }
                self.view.endEditing(true)   // ✅ HERE
                self.validateAndProceed()
                
            }
            return cell
        }
        
        // Fallback
        let cell = tableView.dequeueReusableCell(withIdentifier: "Section\(adjustedSection + 1)Cell", for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    //    // MARK: - Row Heights
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        let section = indexPath.section
    //        let adjustedSection = (!isAdminUser && section >= 1) ? section + 1 : section
    //        switch adjustedSection {
    //        case 0: return 237
    //        case 1: return 108
    //        case 2: return UITableView.automaticDimension
    //        case 3: return 109
    //        case 4: return 102
    //        case 5: return 93
    //        case 6: return 161
    //        case 7: return UITableView.automaticDimension // Proceed cell self-sizes
    //        default: return UITableView.automaticDimension
    //        }
    //    }
    //
    //
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        
        let section = indexPath.section
        let adjustedSection = (!isAdminUser && section >= 1) ? section + 1 : section
        
        switch adjustedSection {
            
        case 0:
            // 🟢 Image cell (make it bigger on iPad only)
            return isPad ? 320 : 237
            
        case 1:
            return 108
            
        case 2:
            return UITableView.automaticDimension
            
        case 3:
            return 109
            
        case 4:
            return 102
            
        case 5:
            return 93
            
        case 6:
            return 161
            
        case 7:
            return UITableView.automaticDimension
            
        default:
            return UITableView.automaticDimension
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Donor List
    @objc private func openDonorList() {
        let sb = UIStoryboard(name: "Raghad1", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "RaghadDonorListViewController") as? RaghadDonorListViewController else {
            print("❌ Storyboard ID not set correctly")
            return
        }
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - DonorSelectionDelegate
    func didSelectDonor(name: String) {
        selectedDonorName = name
        shouldShowDonorError = false
        if isAdminUser {
            donationFormTableview.reloadSections(IndexSet(integer: 1), with: .none)
        } else {
            donationFormTableview.reloadData()
        }
    }
    
    // MARK: - Image Picking (UIImagePickerController)
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            openImagePicker(sourceType: .camera)
        } else {
            openImagePicker(sourceType: .photoLibrary)
        }
    }
    private func openPhotoLibrary() { openImagePicker(sourceType: .photoLibrary) }
    
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self          // CRITICAL: so we receive the image
        picker.sourceType = sourceType
        picker.allowsEditing = true     // optional crop
        present(picker, animated: true)
    }
    
     
    
    
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true)

        let image =
            (info[.editedImage] as? UIImage) ??
            (info[.originalImage] as? UIImage)

        guard let img = image else { return }

        // ✅ 1) Save image in VC state
        selectedDonationImage = img
        shouldShowImageError = false

        // ✅ 2) Reload ONLY the image section
        UIView.performWithoutAnimation {
            self.donationFormTableview.reloadSections(IndexSet(integer: 0), with: .none)
        }

        // ✅ 3) Upload to Cloudinary
        isUploadingImage = true
        uploadedDonationImageUrl = nil

        cloudinaryService.uploadImage(img) { [weak self] url in
            guard let self = self else { return }

            self.isUploadingImage = false
            self.uploadedDonationImageUrl = url

            print("✅ CLOUDINARY IMAGE URL:", url ?? "nil")

            if url == nil {
                self.shouldShowImageError = true
                self.showSimpleAlert(
                    title: "Upload Failed",
                    message: "Please try selecting the image again."
                )
            }
        }
    }

    
    
    
    

    // MARK: - Helpers
    /// Reads the Quantity from Section 4 cell (index 3). Falls back to cached `quantityValue`.
//    private func getQuantityValue() -> Int? {
//        // adjustedSection 3 = Quantity
//        let tableSection = isAdminUser ? 3 : 2   // ✅ IMPORTANT (admin shifts sections)
//        let indexPath = IndexPath(row: 0, section: tableSection)
//
//        if let cell = donationFormTableview.cellForRow(at: indexPath) as? RaghadSection4TableViewCell {
//            return cell.getQuantityValue()
//        }
//        return quantityValue
//    }
    
    private func getQuantityValue() -> Int? {
        return selectedQuantity
    }

    
    
    
    
    

    // Reads the optional short description from the form.
    // Returns nil if empty or placeholder.
//    private func getShortDescription() -> String? {
//
//        // Description section index differs for admin vs donor
//        let descSection = isAdminUser ? 6 : 5
//        let indexPath = IndexPath(row: 0, section: descSection)
//
//        // Get description cell safely
//        guard let cell = donationFormTableview.cellForRow(at: indexPath)
//                as? RaghadSection7TableViewCell else {
//            return nil
//        }
//
//        // Clean text
//        let text = (cell.txtDescription.text ?? "")
//            .trimmingCharacters(in: .whitespacesAndNewlines)
//
//        // Ignore empty / placeholder
//        if text.isEmpty || text == "Enter a Short Description" {
//            return nil
//        }
//
//        // Valid user input
//        return text
//    }

    
    private func getShortDescription() -> String? {
        let t = (selectedShortDescription ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Validation / Navigation
    private func validateAndProceed() {
        view.endEditing(true)

        // 1) Compute validity
        let missingImage = (selectedDonationImage == nil)
        let missingUploadedUrl = (uploadedDonationImageUrl == nil)

        
        let missingDonor = isAdminUser ? (selectedDonorName == nil) : false
        let missingFoodCategory = (selectedFoodCategory == nil)

        // Quantity
        let qty = getQuantityValue() ?? 0
        let invalidQuantity = (qty <= 0)

        // Weight (optional, only format validation)
        let invalidWeight = weightInvalidFormat

        // Expiry
        let missingExpiry = (selectedExpiryDate == nil)

        // 2) Flip error flags
        shouldShowImageError = missingImage
        shouldShowDonorError = missingDonor
        shouldShowFoodCategoryError = missingFoodCategory
        shouldShowQuantityError = invalidQuantity
        shouldShowWeightError = invalidWeight

        // 3) Reload only affected sections (✅ correct indices)
        let sectionsToReload: [Int]
        if isAdminUser {
            // [0] image, [1] donor, [2] food, [3] qty, [4] weight, [5] expiry
            sectionsToReload = [0, 1, 2, 3, 4, 5]
        } else {
            // [0] image, [1] food, [2] qty, [3] weight, [4] expiry
            sectionsToReload = [0, 1, 2, 3, 4]
        }

        UIView.performWithoutAnimation {
            donationFormTableview.reloadSections(IndexSet(sectionsToReload), with: .none)
        }


        // ⛔ Still uploading to Cloudinary
        if isUploadingImage {
            showSimpleAlert(
                title: "Uploading Image",
                message: "Please wait until the image upload finishes."
            )
            return
        }

        // ⛔ Image selected but not uploaded yet
       

        if missingImage ||
           missingUploadedUrl ||
           missingFoodCategory ||
           invalidQuantity ||
           invalidWeight ||
           missingExpiry ||
           missingDonor {

            if missingUploadedUrl && !missingImage {
                showSimpleAlert(
                    title: "Image Not Uploaded",
                    message: "Please wait or try selecting the image again."
                )
            }

            return
        }

        
        
        //comment this 24 dec 2025 11:39
        

        // 5) All good → go next
//        performSegue(withIdentifier: "showSchedulePickup", sender: self)
        
//        let sb = UIStoryboard(name: "Raghad1", bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: "SchedulePickupVC")
//        navigationController?.pushViewController(vc, animated: true)
        
        
        // 5) All good → create draft donation, then go next

        guard let ngo = selectedNgo else {
            showSimpleAlert(title: "Error", message: "NGO not found.")
            return
        }

        // ⚠️ IMPORTANT:
        // You MUST have Firestore document IDs here.
        // For now, we assume:
        // - ngo.id = Firestore doc ID (users collection)
        // - donor doc ID will be resolved below

        let donorDocId: String
        if isAdminUser {
            // ❗ TEMP SAFE SOLUTION (BEGINNER FRIENDLY):
            // Ask your teammate for donor docId OR use username = docId if same
            donorDocId = selectedDonorName ?? ""
        } else {
            donorDocId = user.username
        }

        let ngoDocId = ngo.id   // must be Firestore doc id (users collection)

        createDraftDonation(
            donorUserDocId: donorDocId,
            ngoUserDocId: ngoDocId
        ) { [weak self] donationDocId in
            guard let self = self else { return }

            guard let donationDocId = donationDocId else {
                self.showSimpleAlert(
                    title: "Error",
                    message: "Failed to save donation. Please try again."
                )
                return
            }

            print("➡️ Proceeding with donation ID:", donationDocId)

            let sb = UIStoryboard(name: "Raghad1", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "SchedulePickupVC")
            if let ngo = self.selectedNgo {
                 DonationDraftStore.shared.clear(ngoId: ngo.id)
             }

            
            
            
            // PASS donationDocId TO NORAIN
            //remove the comment when:
            //norain do the page
            //1️⃣ The Schedule Pickup screen has a Swift class
            //(❌ not just a storyboard screen)
            //2️⃣ That Swift class contains this property:
            //vc.setValue(donationDocId, forKey: "donationDocId")

            self.navigationController?.pushViewController(vc, animated: true)
        }

        
    }
    
    
    
    private var uploadingAlert: UIAlertController?

    private func showUploadingAlert() {
        let alert = UIAlertController(title: "Uploading...", message: "Please wait", preferredStyle: .alert)
        uploadingAlert = alert
        present(alert, animated: true)
    }

    private func hideUploadingAlert() {
        uploadingAlert?.dismiss(animated: true)
        uploadingAlert = nil
    }

    private func showSimpleAlert(title: String, message: String) {
        let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        present(a, animated: true)
    }

    
    // 🟡 KEYBOARD START (REPLACE YOUR OLD KEYBOARD CODE)

    private func setupKeyboardAvoidance() {

        let willShow = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] (note: Foundation.Notification) in
            self?.handleKeyboard(note: note, showing: true)
        }

        let willHide = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] (note: Foundation.Notification) in
            self?.handleKeyboard(note: note, showing: false)
        }

        keyboardObservers = [willShow, willHide]
    }

    private func handleKeyboard(note: Foundation.Notification, showing: Bool) {

        isKeyboardShowing = showing   // ✅ track state

        let endFrame = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) ?? .zero
        let keyboardHeight = showing ? endFrame.height : 0

        let bottomSafe = view.safeAreaInsets.bottom
        let keyboardInset = max(0, keyboardHeight - bottomSafe)

        // ✅ IMPORTANT:
        // base space ALWAYS exists (for the button),
        // keyboard space gets added on top when keyboard shows
        let base = baseBottomSpace + bottomSafe
        let finalBottom = base + keyboardInset + (showing ? 12 : 0)

        donationFormTableview.contentInset.bottom = finalBottom
        donationFormTableview.verticalScrollIndicatorInsets.bottom = finalBottom

        if showing, let ip = activeIndexPath {
            donationFormTableview.scrollToRow(at: ip, at: .middle, animated: true)
        }

        if !showing {
            // ✅ when keyboard hides, return to the normal “nice” bottom space
            applyBaseBottomInset()
        }
    }

    // 🟡 KEYBOARD END
    
    
    
    
    
    
    
    //🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡
    private func createDraftDonation(
        donorUserDocId: String,
        ngoUserDocId: String,
        completion: @escaping (String?) -> Void
    ) {
        let db = Firestore.firestore()

        // ✅ References (matches your Firestore schema)
        let donorRef = db.document("users/\(donorUserDocId)")
        let ngoRef = db.document("users/\(ngoUserDocId)")

        // ✅ Use existing collection name exactly (Donation)
        let docRef = db.collection("Donation").document()
        let newId = docRef.documentID

        
        
        // ✅ donationID (number) — only if your team needs it
        // This makes a simple unique number based on time (safe)
        let donationID = Int(Date().timeIntervalSince1970) % 1000000

        let data: [String: Any] = [
            "firestoreID": newId,
            "donationID": donationID,

            "donor": donorRef,
            "ngo": ngoRef,
            "createdBy": db.document("users/\(user.username)"),


            "Category": selectedFoodCategory ?? "",
            "quantity": getQuantityValue() ?? 0,
            "weight": weightValue as Any,                 // nil allowed
            "description": getShortDescription() as Any,   // nil allowed

            "foodImageUrl": uploadedDonationImageUrl ?? "",

            "expiryDate": Timestamp(date: selectedExpiryDate ?? Date()),
            "creationDate": FieldValue.serverTimestamp(),

            // ✅ safest: draft
            "status": 0,

            // ✅ safe defaults if your team uses these
            "recurrence": 0
        ]

        docRef.setData(data) { error in
            if let error = error {
                print("❌ createDraftDonation error:", error.localizedDescription)
                completion(nil)
            } else {
                print("✅ Draft Donation created:", newId)
                completion(newId)
            }
        }
    }
    
    //to save a draft of the form when useful for back navigation
    
    private func saveDraft() {
        guard let ngo = selectedNgo else { return }

        let draft = DonationDraft(
            ngoId: ngo.id,
            donorName: selectedDonorName,
            foodCategory: selectedFoodCategory,
            quantity: selectedQuantity,
            weight: weightValue,
            expiryDate: selectedExpiryDate,
            //shortDescription: getShortDescription(),
            shortDescription: selectedShortDescription,


            imageUrl: uploadedDonationImageUrl,
            imageData: selectedDonationImage?.jpegData(compressionQuality: 0.9) // ✅ NEW
        )

        DonationDraftStore.shared.save(draft)
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Save only when user is going BACK from this screen
        if isMovingFromParent {
            saveDraft()
        }
    }
    
    private func restoreDraftIfExists() {
        guard let ngo = selectedNgo else { return }
        guard let draft = DonationDraftStore.shared.load(ngoId: ngo.id) else { return }

        selectedDonorName = draft.donorName
        selectedFoodCategory = draft.foodCategory
        weightValue = draft.weight
        selectedExpiryDate = draft.expiryDate
        uploadedDonationImageUrl = draft.imageUrl

        // ✅ NEW: restore the photo for UI
        if let data = draft.imageData {
            selectedDonationImage = UIImage(data: data)
        }
        
        selectedQuantity = draft.quantity ?? 1
        selectedShortDescription = draft.shortDescription


        donationFormTableview.reloadData()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restoreDraftIfExists()
    }

    
    



}

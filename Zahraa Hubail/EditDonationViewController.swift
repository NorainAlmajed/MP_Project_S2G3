//
//  EditDonationViewController.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 26/12/2025.
//

    import FirebaseFirestore
    import Cloudinary   // add this at the top of the file
    import UIKit
    import PhotosUI   // optional if you switch to PHPicker later
    import FirebaseFirestore


    class EditDonationViewController: UIViewController,
                                            UITableViewDelegate,
                                            UITableViewDataSource,
                                            UIImagePickerControllerDelegate,
                                            UINavigationControllerDelegate,
                                            ZahraSection1TableViewCellDelegate,
                                            ZahraaAddressDelegate
                                             {
        
        var donation: Donation?
        
        // MARK: - Pickup time
        private var selectedPickupTime: String?  // or whatever type your timeframe uses
        @IBOutlet weak var timeErrorLbl: UILabel!  // link this from storyboard

        
        private var timeframeCell: ZahraaPickUpTimeTableViewCell?

        private var draftAddress: ZahraaAddress?

        
        // In EditDonationViewController.swift
        var onDonationUpdated: ((Donation) -> Void)?

        
        
        func section1DidTapUploadImage(_ cell: ZahraaSection1TableViewCell) {
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
        
        // MARK: - State / Validation
        private var shouldShowImageError = false
        private var shouldShowQuantityError = false
        //private var quantityValue: Int?
        private var weightValue: Double?
        private var weightInvalidFormat = false
        private var shouldShowWeightError = false
        private var selectedExpiryDate: Date?
        private var selectedPickupDate: Date?

        
        
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
            
            title = "Edit Donation Details"
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
            
        


            setupKeyboardAvoidance()

           
            // Remove default shadow
            navigationController?.navigationBar.shadowImage = UIImage()

            // Add small grey line under navigation bar
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


            //Populate donation data
            populateDonationDetails()
            donationFormTableview.reloadData()


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
        func numberOfSections(in tableView: UITableView) -> Int { isAdminUser ? 12 : 11 }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        
        
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let section = indexPath.section
            // If NOT admin, skip donor section by shifting sections after 0
            let adjustedSection = (!isAdminUser && section >= 1) ? section + 1 : section
            
            // Section 1 (Image)
            if adjustedSection == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Section1Cell", for: indexPath) as! ZahraaSection1TableViewCell
                cell.selectionStyle = .none
                cell.delegate = self
                cell.setDonationImage(selectedDonationImage, imageUrl: uploadedDonationImageUrl)

                
                cell.configure(showError: shouldShowImageError)
                cell.lblImageError.text = "Please upload an image"
                return cell
            }
        
            // Section 3 (Food Category)
            if adjustedSection == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Section3Cell", for: indexPath) as! ZahraaSection3TableViewCell
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
            
            

            
            if adjustedSection == 3 {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "Section4Cell",
                    for: indexPath
                ) as! ZahraaSection4TableViewCell

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
                let cell = tableView.dequeueReusableCell(withIdentifier: "Section5Cell", for: indexPath) as! ZahraaSection5TableViewCell
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "Section6Cell", for: indexPath) as! ZahraaSection6TableViewCell
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
            
            


            if adjustedSection == 6 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Section7Cell", for: indexPath) as! ZahraaSection7TableViewCell
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

            
            // 🏠 Address (before Proceed button)
            if adjustedSection == 7 {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "AddressCell",
                    for: indexPath
                ) as! ZahraaAddressTableViewCell

                cell.selectionStyle = .none

                if let donation = self.donation {
                    // ✅ Create a temporary copy for display
                    var donationForDisplay = donation

                    // ✅ If user edited address but didn’t save donation yet
                    if let draftAddress = draftAddress {
                        donationForDisplay.address = draftAddress
                    }

                    cell.configure(with: donationForDisplay)
                    cell.layoutIfNeeded()
                }

                // ✅ Set the delegate
                cell.delegate = self

                return cell
            }


                //PickUp date cell
            if adjustedSection == 8 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PickUpDateCell", for: indexPath) as! ZahraaPickUpDateTableViewCell
                cell.selectionStyle = .none
                
                // ✅ Set the existing pickup date
                cell.configure(date: selectedPickupDate)
                
                // ✅ Keep VC updated when user changes the date
                cell.onDateSelected = { [weak self] date in
                    self?.selectedPickupDate = date
                }
                
                return cell
            }

            
            
            //PickUp time cell
            if adjustedSection == 9 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PickUpTimeCell", for: indexPath) as! ZahraaPickUpTimeTableViewCell

                // set current selected time
                let currentTime = selectedPickupTime ?? donation?.pickupTime
                cell.configure(selected: currentTime)

                // IMPORTANT: set the callback
                cell.onTimeframeSelected = { [weak self] selected in
                    self?.selectedPickupTime = selected
                    self?.timeErrorLbl.isHidden = true
                }

                return cell
            }


            //Recurrence
            if adjustedSection == 10 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecurrenceCell", for: indexPath) as! ZahraaRecurrenceTableViewCell
                cell.selectionStyle = .none

                // Configure with existing donation recurrence
                cell.configure(with: donation?.recurrence ?? 0)

                // Keep VC state updated
                cell.onFrequencySelected = { [weak self] value in
                    self?.donation?.recurrence = value
                }

                return cell
            }


            
            
            // Section 8 (Proceed button)
            if adjustedSection == 11 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Section8Cell", for: indexPath) as! ZahraaSection8TableViewCell
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
        
 
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let section = indexPath.section
            let adjustedSection = (!isAdminUser && section >= 1) ? section + 1 : section

            // Hide donor section completely
            if adjustedSection == 1 {
                return 0
            }

            switch adjustedSection {
            case 0: return 237
            case 2: return UITableView.automaticDimension
            case 3: return 109
            case 4: return 102
            case 5: return 102
            case 6: return 161
            case 7: return 114 // Address
            case 8: return 102 //Pickup Date
            case 9: return 324 //Pickup Time
            case 10: return 152
            case 11: return UITableView.automaticDimension
            default: return UITableView.automaticDimension
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

        private func getQuantityValue() -> Int? {
            return selectedQuantity
        }

        
        
        
        
        

   
        
        private func getShortDescription() -> String? {
            let t = (selectedShortDescription ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            return t.isEmpty ? nil : t
        }

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // MARK: - Validation / Navigation
        private func validateAndProceed() {
            view.endEditing(true)
            
            // 0️⃣ Stop if image is still uploading
            if isUploadingImage {
                showSimpleAlert(
                    title: "Uploading Image",
                    message: "Please wait until the image upload finishes."
                )
                return
            }

            // 1️⃣ Compute validity
            let missingImage = (uploadedDonationImageUrl == nil && selectedDonationImage == nil)
            let missingFoodCategory = (selectedFoodCategory == nil || selectedFoodCategory?.isEmpty == true)
            let invalidQuantity = (selectedQuantity <= 0)
            let invalidWeight = weightInvalidFormat
            let missingExpiry = (selectedExpiryDate == nil)
            let missingPickupDate = (selectedPickupDate == nil)
            let missingPickupTime = (selectedPickupTime == nil)

            // 2️⃣ Flip error flags
            shouldShowImageError = missingImage
            shouldShowFoodCategoryError = missingFoodCategory
            shouldShowQuantityError = invalidQuantity
            shouldShowWeightError = invalidWeight
            timeErrorLbl.isHidden = !missingPickupTime

            // 3️⃣ Reload affected sections
            var sectionsToReload = [0, 2, 3, 4, 5, 8, 9, 10] // include recurrence section
            UIView.performWithoutAnimation {
                donationFormTableview.reloadSections(IndexSet(sectionsToReload), with: .none)
            }

            // 4️⃣ Stop if validation failed
            if missingImage || missingFoodCategory || invalidQuantity || invalidWeight || missingExpiry || missingPickupDate || missingPickupTime {
                return
            }

            // 5️⃣ Update donation object with draft address if exists
            if let draft = draftAddress, let address = donation?.address {
                address.building = draft.building
                address.road = draft.road
                address.block = draft.block
                address.area = draft.area
                address.governorate = draft.governorate
                address.flat = draft.flat
            }

            // 6️⃣ Prepare Firestore update
            guard let donation = donation, let donationId = donation.firestoreID else { return }
            let db = Firestore.firestore()
            let donationRef = db.collection("Donation").document(donationId)

            var updatedData: [String: Any] = [
                "Category": selectedFoodCategory ?? "",
                "quantity": selectedQuantity,
                "expiryDate": Timestamp(date: selectedExpiryDate ?? Date()),
                "recurrence": donation.recurrence // ✅ include recurrence
            ]

            if let weight = weightValue { updatedData["weight"] = weight }
            if let description = selectedShortDescription { updatedData["description"] = description }
            if let imageUrl = uploadedDonationImageUrl { updatedData["foodImageUrl"] = imageUrl }
            if let pickupDate = selectedPickupDate { updatedData["pickupDate"] = Timestamp(date: pickupDate) }
            if let pickupTime = selectedPickupTime { updatedData["pickupTime"] = pickupTime }

            // ✅ Include address only if draft exists
            if let address = draftAddress {
                updatedData["address"] = [
                    "building": address.building,
                    "road": address.road,
                    "block": address.block,
                    "area": address.area,
                    "governorate": address.governorate,
                    "flat": address.flat as Any
                ]
            }

            // 7️⃣ Firestore update
            donationRef.updateData(updatedData) { [weak self] error in
                if let error = error {
                    self?.showSimpleAlert(title: "Update Failed", message: error.localizedDescription)
                    return
                }

                print("✅ Donation updated successfully")
                self?.onDonationUpdated?(donation)
                self?.navigationController?.popViewController(animated: true)
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
        
        
        
        
        
        

        //to save a draft of the form when useful for back navigation
        
        private func saveDraft() {
            guard let donationId = donation?.firestoreID else { return }  // use donation ID instead

            let draft = DonationDraft(
                ngoId: donationId,  // you can just use this as the key; it doesn't need to be the real NGO
                foodCategory: selectedFoodCategory,
                quantity: selectedQuantity,
                weight: weightValue,
                expiryDate: selectedExpiryDate,
                shortDescription: selectedShortDescription,
                imageUrl: uploadedDonationImageUrl,
                imageData: selectedDonationImage?.jpegData(compressionQuality: 0.9)
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
            guard let donationId = donation?.firestoreID else { return }
            guard let draft = DonationDraftStore.shared.load(ngoId: donationId) else { return }

            // restore fields
            if selectedFoodCategory == nil { selectedFoodCategory = draft.foodCategory }
            if weightValue == nil { weightValue = draft.weight }
            if selectedExpiryDate == nil { selectedExpiryDate = draft.expiryDate }
            if uploadedDonationImageUrl == nil { uploadedDonationImageUrl = draft.imageUrl }

            if selectedDonationImage == nil, let data = draft.imageData {
                selectedDonationImage = UIImage(data: data)
            }

            if selectedQuantity <= 1, let q = draft.quantity {
                selectedQuantity = max(q, 1)
            }

            if (selectedShortDescription ?? "").isEmpty {
                selectedShortDescription = draft.shortDescription
            }

            donationFormTableview.reloadData()
        }


        
        
        
        
        
        


        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            restoreDraftIfExists()
        }

        
        
        //Prepare the data when opening the page
        // Call this in viewDidLoad or viewWillAppear after `donation` is set
        private func populateDonationDetails() {
            guard let donation = donation else { return }

            // Section 0: Image
            if !donation.foodImageUrl.isEmpty {
                uploadedDonationImageUrl = donation.foodImageUrl
                selectedDonationImage = nil // clear any previous selection
            } else {
                uploadedDonationImageUrl = nil
                selectedDonationImage = nil
            }

            // Section 2: Food Category
            selectedFoodCategory = donation.category

            // Section 3: Quantity
            selectedQuantity = max(donation.quantity, 1) // ensure minimum 1

            // Section 4: Weight (optional)
            weightValue = donation.weight
            weightInvalidFormat = false
            shouldShowWeightError = false

            // Section 5: Expiry Date
            selectedExpiryDate = donation.expiryDate.dateValue()

            // Section 6: Short Description (optional)
            if let desc = donation.description?.trimmingCharacters(in: .whitespacesAndNewlines),
               !desc.isEmpty {
                selectedShortDescription = desc
            } else {
                selectedShortDescription = nil // will show placeholder in cell
            }

            // Section 7: Proceed button — no value needed

            // Reload all sections
            UIView.performWithoutAnimation {
                donationFormTableview.reloadData()
            }
            
            // Section 8: PickUp Date
            selectedPickupDate = donation.pickupDate.dateValue()


        }
        
        
        // MARK: - Send notifications to donor and NGO
        // MARK: - Send notifications to donor and NGO
        private func sendUpdateNotifications(for donation: Donation) {
            let db = Firestore.firestore()
            
            // ✅ Use exact title and description format
            let title = "Donation Updated"
            let description = "Donation #\(donation.donationID) has been edited by the admin."
            let date = Timestamp(date: Date())
            
            // 1️⃣ Donor notification
            let donor = donation.donor
            if donor.enableNotification {  // corrected property name
                let donorNotification: [String: Any] = [
                    "userID": donor.userID,      // match your struct field
                    "title": title,
                    "description": description,
                    "date": date
                ]
                
                db.collection("Notification").addDocument(data: donorNotification) { error in
                    if let error = error {
                        print("❌ Failed to create donor notification:", error.localizedDescription)
                    } else {
                        print("✅ Donor notification created")
                    }
                }
            }
            
            // 2️⃣ NGO notification
            let ngo = donation.ngo
            if ngo.enableNotification {  // corrected property name
                let ngoNotification: [String: Any] = [
                    "userID": ngo.userID,
                    "title": title,
                    "description": description,
                    "date": date
                ]
                
                db.collection("Notification").addDocument(data: ngoNotification) { error in
                    if let error = error {
                        print("❌ Failed to create NGO notification:", error.localizedDescription)
                    } else {
                        print("✅ NGO notification created")
                    }
                }
            }
        }

        
        
        
        
        func didAddAddress(_ address: ZahraaAddress) {
            // ✅ Store address TEMPORARILY (draft only)
            draftAddress = address

            // ✅ Update UI only
            donationFormTableview.reloadSections(IndexSet(integer: 7), with: .none)
        }






    }

extension EditDonationViewController: ZahraaAddressTableViewCellDelegate {
    func didTapAddressButton() {
        let storyboard = UIStoryboard(name: "Donations", bundle: nil)
        let addressVC = storyboard.instantiateViewController(
            withIdentifier: "ZahraaAddressPageViewController"
        ) as! ZahraaAddressPageViewController
        
        // ✅ Pass the donation object here
        addressVC.donation = self.donation
        
        // ✅ Set delegate
        addressVC.delegate = self  // your existing ZahraaAddressDelegate
        
        // ✅ Optional: remove back text
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem

        navigationController?.pushViewController(addressVC, animated: true)
    }

}

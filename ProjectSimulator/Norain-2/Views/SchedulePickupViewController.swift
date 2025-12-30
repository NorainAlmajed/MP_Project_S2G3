import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol AddAddressDelegate: AnyObject {
    func didAddAddress(_ address: Address)
}

class SchedulePickupViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var addressContainerView: UIView!
    @IBOutlet weak var addressNameLbl: UILabel!
    @IBOutlet weak var addressDetailsLbl: UILabel!
    @IBOutlet weak var addNewAddressBtn: UIButton!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateBtn: UIButton!
    
    @IBOutlet weak var timeframeTableView: UITableView!
    @IBOutlet weak var timeframeHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reccuringSwitch: UISwitch!
    @IBOutlet weak var frequencyBtn: UIButton!
    @IBOutlet weak var frequencyContainer: UIView!
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var addressErrorLbl: UILabel!
    @IBOutlet weak var dateErrorLbl: UILabel!
    @IBOutlet weak var timeErrorLbl: UILabel!
    // MARK: - Properties
    var payload: DonationPayload?
    
    // Fixed: Declared missing properties
    private var selectedAddressRef: DocumentReference?
    private var existingAddresses: [(ref: DocumentReference, data: [String: Any])] = []
    
    private var selectedAddress: Address?
    private var selectedDate: Date?
    private var selectedTimeframe: String?
    private var isRecurring: Bool = false
    private var selectedFrequency: String?
    
    private let timeframes = [
        "Any Time : 9AM - 4PM",
        "9AM - 11AM",
        "12PM-1PM",
        "2PM-4PM"
    ]
    
    private let frequencies = ["Daily", "Weekly", "Monthly", "Yearly"]
    
    private let datePicker = UIDatePicker()
    private let db = Firestore.firestore()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDatePicker()
        setupTableView()
//        signInAnonymously()
        fetchExistingAddresses()
//        setupTestDonation() 
    }
    
    // MARK: - Setup Methods
//    private func setupTestDonation() {
//        // Create a complete test donation payload
//        let testPayload = DonationPayload(
//            ngoId: "test_ngo_123",
//            ngoName: "Test NGO",
//            donorName: "Test Donor",
//            foodCategory: "Vegetables",
//            quantity: 10,
//            weight: 5.5,
//            expiryDate: Date().addingTimeInterval(7 * 24 * 60 * 60), // 7 days from now
//            shortDescription: "Fresh vegetables and fruits for donation",
//            imageUrl: "https://via.placeholder.com/300"
//        )
//        
//        self.payload = testPayload
//        print("✅ Test donation data loaded!")
//        print("   - NGO: \(testPayload.ngoName)")
//        print("   - Category: \(testPayload.foodCategory)")
//        print("   - Quantity: \(testPayload.quantity)")
//        print("   - Weight: \(testPayload.weight ?? 0)")
//    }
//
//    private func signInAnonymously() {
//        Auth.auth().signInAnonymously { [weak self] authResult, error in
//            if let error = error {
//                print("❌ Sign in error: \(error.localizedDescription)")
//            } else {
//                print("✅ Signed in as: \(authResult?.user.uid ?? "")")
//            }
//        }
//    }
    
    private func setupUI() {
        reccuringSwitch.addTarget(self, action: #selector(recurringSwitchChanged), for: .valueChanged)
        title = "Schedule Pick-up"
        addressContainerView.layer.cornerRadius = 8
        addressContainerView.layer.borderWidth = 1
        addressContainerView.layer.borderColor = UIColor.systemGray4.cgColor
        
        addressNameLbl.isHidden = true
        addressDetailsLbl.isHidden = true
        checkmarkImageView.isHidden = true
        
        addressErrorLbl.isHidden = true
        dateErrorLbl.isHidden = true
        timeErrorLbl.isHidden = true
        
        confirmBtn.layer.cornerRadius = 8
        confirmBtn.isEnabled = true
        confirmBtn.alpha = 1.0
        
        frequencyContainer.isHidden = true
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        dateTextField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDatePicker))
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
    }
    
    private func setupTableView() {
        timeframeTableView.delegate = self
        timeframeTableView.dataSource = self
        timeframeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TimeframeCell")
        timeframeHeightConstraint.constant = CGFloat(timeframes.count * 44)
    }

    private func validateForm() {
        confirmBtn.isEnabled = true
            confirmBtn.alpha = 1.0
    }
    
    // MARK: - Actions
    @IBAction func addNewAddressTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Address", message: nil, preferredStyle: .actionSheet)
        
        if !existingAddresses.isEmpty {
            alert.addAction(UIAlertAction(title: "Choose Saved Address", style: .default) { _ in
                self.showExistingAddressesList()
            })
        }
        
        alert.addAction(UIAlertAction(title: "Add New Address", style: .default) { _ in
            self.navigateToAddAddress()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func navigateToAddAddress() {
        let storyboard = UIStoryboard(name: "norain-schedule-pickup", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController {
            vc.delegate = self
            
            if let nav = navigationController {
                nav.pushViewController(vc, animated: true)
            } else {
                // Fallback: Present it modally if no navigation controller exists
                present(vc, animated: true)
            }
        }
    }
    private func showExistingAddressesList() {
        let alert = UIAlertController(title: "Saved Addresses", message: nil, preferredStyle: .actionSheet)
        for (ref, data) in existingAddresses {
            let name = data["name"] as? String ?? "Address"
            alert.addAction(UIAlertAction(title: name, style: .default) { _ in
                self.selectExistingAddress(ref: ref, data: data)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func selectExistingAddress(ref: DocumentReference, data: [String: Any]) {
        addressErrorLbl.isHidden = true
        selectedAddressRef = ref
        let address = Address(
            name: data["name"] as? String ?? "",
            building: data["building"] as? String ?? "",
            road: data["road"] as? String ?? "",
            block: data["block"] as? String ?? "",
            flat: data["flat"] as? String ?? "",
            area: data["area"] as? String ?? "",
            governorate: data["governorate"] as? String ?? ""
        )
        selectedAddress = address
        addressNameLbl.text = address.name
        addressDetailsLbl.text = address.fullAddress
        addressNameLbl.isHidden = false
        addressDetailsLbl.isHidden = false
        checkmarkImageView.isHidden = false
        validateForm()
    }
    
    @IBAction func dateButtonTapped(_ sender: UIButton) {

        dateTextField.becomeFirstResponder()
    }

    @objc private func dateChanged() {
        dateErrorLbl.isHidden = true
        selectedDate = datePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        validateForm()
    }

    @objc private func doneDatePicker() {
        dateTextField.resignFirstResponder()
    }

    @objc private func recurringSwitchChanged(_ sender: UISwitch) {
        isRecurring = sender.isOn
        frequencyContainer.isHidden = !sender.isOn
        selectedFrequency = sender.isOn ? "Weekly" : nil
        validateForm()
    }

    @IBAction func frequencyButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Frequency", message: nil, preferredStyle: .actionSheet)
        for freq in frequencies {
            alert.addAction(UIAlertAction(title: freq, style: .default) { _ in
                self.selectedFrequency = freq
                self.frequencyBtn.setTitle(freq, for: .normal)
                self.validateForm()
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        
        view.endEditing(true)
            
            // Run our custom validation
            if validateAndShowErrors() {
                // If all labels are hidden and data is there, proceed!
                print("✅ Validation passed. Starting upload...")
                completeDonation()
            } else {
                // If validation fails, provide haptic feedback (optional)
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                print("❌ Validation failed. Showing error labels.")
            }
    }
    
    // MARK: - Firebase Operations
    private func fetchExistingAddresses() {
        db.collection("Address").getDocuments { [weak self] snapshot, error in
            self?.existingAddresses = snapshot?.documents.compactMap { (ref: $0.reference, data: $0.data()) } ?? []
        }
    }

    private func completeDonation() {
            guard let userId = Auth.auth().currentUser?.uid,
                  let address = selectedAddress,
                  let date = selectedDate,
                  let timeframe = selectedTimeframe,
                  let payload = payload else { return }

            confirmBtn.isEnabled = false
            confirmBtn.setTitle("Saving...", for: .normal)

            // Get the next donation ID first
            getNextDonationID { [weak self] donationID in
                guard let self = self else { return }
                
                if let existingRef = self.selectedAddressRef {
                    // Use existing address
                    self.saveDonationToFirebase(
                        addressRef: existingRef,
                        date: date,
                        timeframe: timeframe,
                        userId: userId,
                        donationID: donationID,
                        payload: payload
                    )
                } else {
                    // Create new address first, then save donation
                    self.saveAddressToFirebase(address: address) { addressRef in
                        if let addressRef = addressRef {
                            self.saveDonationToFirebase(
                                addressRef: addressRef,
                                date: date,
                                timeframe: timeframe,
                                userId: userId,
                                donationID: donationID,
                                payload: payload
                            )
                        } else {
                            self.confirmBtn.isEnabled = true
                            self.confirmBtn.setTitle("Confirm Pickup Schedule", for: .normal)
                            self.showAlert(title: "Error", message: "Failed to save address.")
                        }
                    }
                }
            }
        }
    private func getNextDonationID(completion: @escaping (Int) -> Void) {
            db.collection("Donation").getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error getting donation count: \(error.localizedDescription)")
                    completion(1)
                    return
                }
                
                let count = snapshot?.documents.count ?? 0
                let nextID = count + 1
                print("✅ Next donation ID: \(nextID)")
                completion(nextID)
            }
        }

    private func saveAddressToFirebase(address: Address, completion: @escaping (DocumentReference?) -> Void) {
            let data: [String: Any] = [
                "name": address.name ?? "Saved Address",
                "building": address.building,
                "road": address.road,
                "block": address.block,
                "flat": address.flat,
                "area": address.area,
                "governorate": address.governorate
            ]
            let ref = db.collection("Address").document()
            ref.setData(data) { error in
                if let error = error {
                    print("❌ Error saving address: \(error.localizedDescription)")
                }
                completion(error == nil ? ref : nil)
            }
        }

        private func saveDonationToFirebase(
            addressRef: DocumentReference,
            date: Date,
            timeframe: String,
            userId: String,
            donationID: Int,
            payload: DonationPayload
        ) {
            let donorRef = db.collection("users").document(userId)
            let ngoRef = db.collection("users").document(payload.ngoId)
            
            // Calculate recurrence value
            var recurrenceValue = 0
            if isRecurring {
                switch selectedFrequency {
                case "Daily": recurrenceValue = 1
                case "Weekly": recurrenceValue = 2
                case "Monthly": recurrenceValue = 3
                case "Yearly": recurrenceValue = 4
                default: recurrenceValue = 0
                }
            }
            
            // Build donation data matching NorainDonation structure
            var donationData: [String: Any] = [
                "donationID": donationID,
                "ngo": ngoRef,
                "creationDate": Timestamp(date: Date()),
                "donor": donorRef,
                "address": addressRef,
                "pickupDate": Timestamp(date: date),
                "pickupTime": timeframe,
                "foodImageUrl": payload.imageUrl,
                "status": 1, // 1 = pending
                "Category": payload.foodCategory,
                "quantity": payload.quantity,
                "expiryDate": Timestamp(date: payload.expiryDate),
                "recurrence": recurrenceValue,
                "rejectionReason": ""
            ]
            
            // Add optional fields
            if let weight = payload.weight {
                donationData["weight"] = weight
            }
            
            if let description = payload.shortDescription {
                donationData["description"] = description
            }
            
            // Save to Firestore
            db.collection("Donation").addDocument(data: donationData) { [weak self] error in
                self?.confirmBtn.isEnabled = true
                self?.confirmBtn.setTitle("Confirm Pickup Schedule", for: .normal)
                
                if let error = error {
                    print("❌ Error saving donation: \(error.localizedDescription)")
                    self?.showAlert(title: "Error", message: "Failed to save donation.")
                } else {
                    print("✅ Donation saved successfully")
                    print("   - Donation ID: \(donationID)")
                    print("   - Recurrence: \(recurrenceValue)")
                    
                    //Zahraa Hubail
                    self?.sendNotificationForDonation(donorRef: donorRef, ngoRef: ngoRef)

                    
                    DonationDraftStore.shared.clear(ngoId: payload.ngoId)
                    self?.showSuccessAlert()
                }
            }
        }
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Pickup Scheduled!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
    private func validateAndShowErrors() -> Bool {
        var isValid = true
        
        // Check Address
        if selectedAddress == nil {
            addressErrorLbl.isHidden = false
            isValid = false
        } else {
            addressErrorLbl.isHidden = true
        }
        
        // Check Date
        if selectedDate == nil {
            dateErrorLbl.isHidden = false
            isValid = false
        } else {
            dateErrorLbl.isHidden = true
        }
        
        // Check Timeframe
        if selectedTimeframe == nil {
            timeErrorLbl.isHidden = false
            isValid = false
        } else {
            timeErrorLbl.isHidden = true
        }
        if payload == nil {
                    isValid = false
                    print("❌ No donation payload provided")
                }
        
        return isValid
    }
    
    
    //Zahraa Hubail
    private func sendNotificationForDonation(donorRef: DocumentReference, ngoRef: DocumentReference) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        let adminUserID = "TwWqBSGX4ec4gxCWCZcbo7WocAI2"
        
        SessionManager.shared.fetchUserRole { success in
            guard success else { return }
            let role = SessionManager.shared.role
            
            let group = DispatchGroup()
            var donorUsername: String?
            var ngoOrgName: String?
            var ngoNotificationsEnabled = false
            var adminNotificationsEnabled = false
            
            // Fetch donor info
            group.enter()
            donorRef.getDocument { snapshot, _ in
                donorUsername = snapshot?.data()?["username"] as? String
                group.leave()
            }
            
            // Fetch NGO info
            group.enter()
            ngoRef.getDocument { snapshot, _ in
                let data = snapshot?.data()
                ngoOrgName = data?["organization_name"] as? String
                ngoNotificationsEnabled = data?["notifications_enabled"] as? Bool ?? false
                group.leave()
            }
            
            // Fetch Admin info
            group.enter()
            Firestore.firestore().collection("users").document(adminUserID).getDocument { snapshot, _ in
                adminNotificationsEnabled = snapshot?.data()?["notifications_enabled"] as? Bool ?? false
                group.leave()
            }
            
            group.notify(queue: .main) {
                guard let donorUsername = donorUsername else { return }
                
                func createNotification(title: String, description: String, userID: String) {
                    let data: [String: Any] = [
                        "date": Timestamp(date: Date()),
                        "title": title,
                        "description": description,
                        "userID": userID
                    ]
                    Firestore.firestore().collection("Notification").addDocument(data: data) { error in
                        if let error = error {
                            print("❌ Failed to create notification: \(error.localizedDescription)")
                        } else {
                            print("✅ Notification sent to userID: \(userID)")
                        }
                    }
                }
                
                if role == .admin, ngoNotificationsEnabled {
                    let ngoID = ngoRef.documentID
                    createNotification(title: "New Donation Received",
                                       description: "Donor \(donorUsername) has made a new donation.",
                                       userID: ngoID)
                } else if role == .donor {
                    if ngoNotificationsEnabled {
                        let ngoID = ngoRef.documentID
                        createNotification(title: "New Donation Received",
                                           description: "Donor \(donorUsername) has made a new donation.",
                                           userID: ngoID)
                    }
                    if adminNotificationsEnabled {
                        let ngoName = ngoOrgName ?? "the NGO"
                        createNotification(title: "New Donation Received",
                                           description: "Donor \(donorUsername) has made a new donation to \(ngoName).",
                                           userID: adminUserID)
                    }
                }
            }
        }
    }

    
    
}

// MARK: - TableView & Delegate Extensions
extension SchedulePickupViewController: UITableViewDelegate, UITableViewDataSource, AddAddressDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return timeframes.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeframeCell", for: indexPath)
        let time = timeframes[indexPath.row]
        cell.textLabel?.text = time
        cell.accessoryType = (time == selectedTimeframe) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        timeErrorLbl.isHidden = true
        selectedTimeframe = timeframes[indexPath.row]
        tableView.reloadData()
        validateForm()
    }
    
    func didAddAddress(_ address: Address) {
        addressErrorLbl.isHidden = true
        selectedAddressRef = nil
        selectedAddress = address
        addressNameLbl.text = address.name
        addressDetailsLbl.text = address.fullAddress
        addressNameLbl.isHidden = false
        addressDetailsLbl.isHidden = false
        checkmarkImageView.isHidden = false
        validateForm()
    }
    

}

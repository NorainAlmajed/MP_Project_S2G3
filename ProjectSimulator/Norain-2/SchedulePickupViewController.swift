//
//  SchedulePickupViewController.swift
//  ProjectSimulator
//
//  Created by Norain  on 24/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class SchedulePickupViewController: UIViewController {

    

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
        
    private let frequencies = ["Daily", "Weekly", "Bi-weekly", "Monthly"]
        
    private let datePicker = UIDatePicker()
    private let db = Firestore.firestore()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDatePicker()
        setupTableView()
 

    }
    private func setupUI() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground // or your preferred color
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
            title = "Schedule Pick-up"
            
            // Address container
            addressContainerView.layer.cornerRadius = 8
            addressContainerView.layer.borderWidth = 1
            addressContainerView.layer.borderColor = UIColor.systemGray4.cgColor
            
            // Initially hide address details
            addressNameLbl.isHidden = true
            addressDetailsLbl.isHidden = true
            checkmarkImageView.isHidden = true
            
            // Add new address button
            addNewAddressBtn.setTitle("Add New Address", for: .normal)
        addNewAddressBtn.setTitleColor(.label, for: .normal)
            
            // Confirm button
            confirmBtn.backgroundColor = UIColor(red: 0.13, green: 0.55, blue: 0.13, alpha: 1.0)
            confirmBtn.setTitle("Confirm Pickup Schedule", for: .normal)
            confirmBtn.setTitleColor(.white, for: .normal)
            confirmBtn.layer.cornerRadius = 8
            confirmBtn.isEnabled = false
            confirmBtn.alpha = 0.5
            
            // Date field
            dateTextField.placeholder = "Select Date DD/MM/YYYY"
            dateTextField.borderStyle = .roundedRect
            
            // Frequency setup
            frequencyContainer.isHidden = true
            frequencyBtn.setTitle("Weekly", for: .normal)
        frequencyBtn.setTitleColor(.label, for: .normal)
        frequencyBtn.contentHorizontalAlignment = .left
            
            // Recurring switch
            reccuringSwitch.addTarget(self, action: #selector(recurringSwitchChanged), for: .valueChanged)
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
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.setItems([flexSpace, doneButton], animated: false)
            dateTextField.inputAccessoryView = toolbar
        }
    
    private func setupTableView() {
            timeframeTableView.delegate = self
            timeframeTableView.dataSource = self
            timeframeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TimeframeCell")
            timeframeTableView.isScrollEnabled = false
            timeframeTableView.separatorStyle = .singleLine
            
            // Calculate height
            timeframeHeightConstraint.constant = CGFloat(timeframes.count * 44)
        }
    private func validateForm() {
            let isValid = selectedAddress != nil &&
                         selectedDate != nil &&
                         selectedTimeframe != nil &&
                         (!isRecurring || selectedFrequency != nil)
            
            confirmBtn.isEnabled = isValid
            confirmBtn.alpha = isValid ? 1.0 : 0.5
        }
    
    @IBAction func addNewAddressTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Ensure name matches your .storyboard file
            if let vc = storyboard.instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController {
//                vc.delegate = self // This connects the protocol we defined earlier
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        @IBAction func dateButtonTapped(_ sender: UIButton) {
            dateTextField.becomeFirstResponder()
        }
        
        @objc private func dateChanged() {
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
            
            if sender.isOn {
                selectedFrequency = "Weekly"
            } else {
                selectedFrequency = nil
            }
            validateForm()
        }
        
        @IBAction func frequencyButtonTapped(_ sender: UIButton) {
            showFrequencyActionSheet()
        }
        
        private func showFrequencyActionSheet() {
            let alert = UIAlertController(title: "Select Donation Frequency", message: nil, preferredStyle: .actionSheet)
            
            for frequency in frequencies {
                alert.addAction(UIAlertAction(title: frequency, style: .default) { [weak self] _ in
                    self?.selectedFrequency = frequency
                    self?.frequencyBtn.setTitle(frequency, for: .normal)
                    self?.validateForm()
                })
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            // For iPad
            if let popover = alert.popoverPresentationController {
                popover.sourceView = frequencyBtn
                popover.sourceRect = frequencyBtn.bounds
            }
            
            present(alert, animated: true)
        }
        
        @IBAction func confirmButtonTapped(_ sender: UIButton) {
            saveScheduleToFirebase()
        }
    private func saveScheduleToFirebase() {
            guard let userId = Auth.auth().currentUser?.uid,
                  let address = selectedAddress,
                  let date = selectedDate,
                  let timeframe = selectedTimeframe else {
                showAlert(title: "Error", message: "Please fill in all required fields")
                return
            }
            
            let scheduleData: [String: Any] = [
                "userId": userId,
                "address": [
                    "name": address.name ?? "Saved Address",
                    "building": address.building,
                    "road": address.road,
                    "block": address.block,
                    "flat": address.flat,
                    "area": address.area,
                    "governorate": address.governorate
                ],
                "pickupDate": Timestamp(date: date),
                "timeframe": timeframe,
                "isRecurring": isRecurring,
                "frequency": selectedFrequency ?? "",
                "status": "scheduled",
                "createdAt": FieldValue.serverTimestamp()
            ]
            
            confirmBtn.isEnabled = false
            confirmBtn.setTitle("Saving...", for: .normal)
            
            db.collection("pickupSchedules").addDocument(data: scheduleData) { [weak self] error in
                guard let self = self else { return }
                
                self.confirmBtn.isEnabled = true
                self.confirmBtn.setTitle("Confirm Pickup Schedule", for: .normal)
                
                if let error = error {
                    self.showAlert(title: "Error", message: "Failed to save schedule: \(error.localizedDescription)")
                } else {
                    self.showSuccessAlert()
                }
            }
        }
        
        private func showSuccessAlert() {
            let alert = UIAlertController(title: "Success", message: "Your pickup has been scheduled successfully!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            present(alert, animated: true)
        }
        
        private func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

extension SchedulePickupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeframes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeframeCell", for: indexPath)
        cell.textLabel?.text = timeframes[indexPath.row]
        cell.selectionStyle = .none
        
        if timeframes[indexPath.row] == selectedTimeframe {
            cell.accessoryType = .checkmark
            cell.tintColor = UIColor(red: 0.13, green: 0.55, blue: 0.13, alpha: 1.0)
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTimeframe = timeframes[indexPath.row]
        tableView.reloadData()
        validateForm()
    }
}

// MARK: - AddAddressDelegate
protocol AddAddressDelegate: AnyObject {
    func didAddAddress(_ address: Address)
}

extension SchedulePickupViewController: AddAddressDelegate {
    func didAddAddress(_ address: Address) {
        selectedAddress = address
        
        // Update UI
       addressNameLbl.text = address.name
       addressDetailsLbl.text = address.fullAddress
        
        addressNameLbl.isHidden = false
        addressDetailsLbl.isHidden = false
        checkmarkImageView.isHidden = false
        addNewAddressBtn.setTitle("Add New Address", for: .normal)
        
        validateForm()
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



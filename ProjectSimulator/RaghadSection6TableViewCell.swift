//
//  RaghadSection6TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 14/12/2025.
//

import UIKit
//Expiry date
class RaghadSection6TableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var txtExpiryDate: UITextField!
    
    private let datePicker = UIDatePicker()
    private let formatter = DateFormatter()
    private var userStartedChanging = false   // ✅🟡 prevents reset to tomorrow

    // ✅🟢 VC will set this (keeps it stable even after reload)
    private var selectedDate: Date?
    
    // ✅🟢 callback -> send chosen date to VC
    var onDateSelected: ((Date) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        formatter.dateFormat = "dd/MM/yyyy"
        
        setupDatePicker()
        setupToolbar()
        
        // ✅🟡 Do NOT force set text here every time.
        // VC will call configure(date:)
    }
    
    // ✅🟢 VC calls this to show the correct date every reload
    func configure(date: Date?) {
        if let d = date {
            selectedDate = d
        } else {
            // ✅🟢 default = tomorrow ONLY if user did not start changing
            if selectedDate == nil && !userStartedChanging {
                selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            }
        }

        
        applySelectedDateToUI()
    }
    
    private func setupDatePicker() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.datePickerMode = .date
        
        // ✅🟢 start from tomorrow (no today/past)
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        
        // ✅ show picker instead of keyboard
        txtExpiryDate.inputView = datePicker
        
        // ✅🟢 live update while scrolling
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        
        toolbar.items = [flex, done]
        txtExpiryDate.inputAccessoryView = toolbar
    }
    
    private func applySelectedDateToUI() {
        guard let d = selectedDate else { return }
        datePicker.date = d
        txtExpiryDate.text = formatter.string(from: d)
    }
    
    // ✅🟢 update text while user scrolls + SAVE to VC immediately
    @objc private func dateChanged(_ sender: UIDatePicker) {
        userStartedChanging = true
        selectedDate = sender.date
        let formatted = formatter.string(from: sender.date)
        txtExpiryDate.text = formatted
        
        onDateSelected?(sender.date)   // ✅🔥 keep VC updated while scrolling
    }
    
    // ✅🟢 Done should NOT change it back — just close picker
    @objc private func doneTapped() {
        // ✅ just make sure text matches current picker date
        let d = datePicker.date
        selectedDate = d
        txtExpiryDate.text = formatter.string(from: d)
        
        onDateSelected?(d)             // ✅🔥 final save (safe)
        txtExpiryDate.resignFirstResponder()
    }
}

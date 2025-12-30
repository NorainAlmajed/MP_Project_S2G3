//
//  RaghadSection6TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 14/12/2025.
//



import UIKit
//Expiry date
class RaghadSection6TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblExpiryTitle: UILabel!
    
    @IBOutlet weak var txtExpiryDate: UITextField!
    
    private let datePicker = UIDatePicker()
    private let formatter = DateFormatter()
    private var userStartedChanging = false   // ✅🟡 prevents reset to tomorrow

    // ✅🟢 VC will set this (keeps it stable even after reload)
    private var selectedDate: Date?
    
    // ✅🟢 callback -> send chosen date to VC
    var onDateSelected: ((Date) -> Void)?
    
    
    /////🚘🚘🚘🚘🚘🚘🚘🚘🚘🚘🚘🚘
    private var didSetupLayout = false
    
    
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        //        formatter.dateFormat = "dd/MM/yyyy"
//        //        setupDatePicker()
//        //        setupToolbar()
//        //
//        //        txtExpiryDate.addTarget(self, action: #selector(expiryEditingBegan), for: .editingDidBegin)
//        //        // ✅🟢 ADD
//        
//        
////        print("✅ Section6 awakeFromNib, txtExpiryDate nil? \(txtExpiryDate == nil)")
////        
////        guard txtExpiryDate != nil else { return }  // prevents crash
////        
////        formatter.dateFormat = "dd/MM/yyyy"
////        setupDatePicker()
////        setupToolbar()
////        txtExpiryDate.addTarget(self, action: #selector(expiryEditingBegan), for: .editingDidBegin)
//        
//        print("✅ Section6 awakeFromNib, txtExpiryDate nil? \(txtExpiryDate == nil)")
//          guard txtExpiryDate != nil, lblExpiryTitle != nil else { return }
//
//          setupLayoutIfNeeded()   // ✅ now safe
//
//          formatter.dateFormat = "dd/MM/yyyy"
//          setupDatePicker()
//          setupToolbar()
//          txtExpiryDate.addTarget(self, action: #selector(expiryEditingBegan), for: .editingDidBegin)
//        
//        txtExpiryDate.layer.borderWidth = 1
//        txtExpiryDate.layer.borderColor = UIColor.systemGray4.cgColor
//        txtExpiryDate.layer.cornerRadius = 8
//        txtExpiryDate.clipsToBounds = true
//        txtExpiryDate.backgroundColor = .white
//
//   }
        
   
    
    override func awakeFromNib() {
        super.awakeFromNib()

        print("✅ Section6 awakeFromNib, txtExpiryDate nil? \(txtExpiryDate == nil)")
        guard txtExpiryDate != nil, lblExpiryTitle != nil else { return }

        setupLayoutIfNeeded()

        formatter.dateFormat = "dd/MM/yyyy"
        setupDatePicker()
        setupToolbar()
        txtExpiryDate.addTarget(self, action: #selector(expiryEditingBegan), for: .editingDidBegin)

        // ✅ Border (same in light & dark)
        txtExpiryDate.layer.borderWidth = 1
        txtExpiryDate.layer.borderColor = UIColor.systemGray4.cgColor
        txtExpiryDate.layer.cornerRadius = 8
        txtExpiryDate.clipsToBounds = true

        // ✅ Background: Light = white | Dark = black
        txtExpiryDate.backgroundColor = UIColor { trait in
            trait.userInterfaceStyle == .dark ? .black : .white
        }

        // ✅ Text color auto adapts (black in light, white in dark)
        txtExpiryDate.textColor = .label
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
    
    @objc private func expiryEditingBegan() {
        // ✅ If we already have a selected date, show it
        if let d = selectedDate {
            datePicker.date = d
            txtExpiryDate.text = formatter.string(from: d)
            userStartedChanging = true
            return
           
        }

        // ✅ Otherwise default to tomorrow (and keep picker synced)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        selectedDate = tomorrow
        datePicker.date = tomorrow
        txtExpiryDate.text = formatter.string(from: tomorrow)

        onDateSelected?(tomorrow) // ✅ save into VC too
    }

    
    
    
    //for the stack view🚘🚘🚘🚘🚘🚘🚘🚘🚘🚘
    
//    private func setupLayoutIfNeeded() {
//        guard !didSetupLayout else { return }
//        didSetupLayout = true
//
//        lblExpiryTitle.translatesAutoresizingMaskIntoConstraints = false
//        txtExpiryDate.translatesAutoresizingMaskIntoConstraints = false
//
//        let stack = UIStackView(arrangedSubviews: [lblExpiryTitle, txtExpiryDate])
//        stack.axis = .vertical
//        stack.spacing = 8
//        stack.alignment = .fill
//        stack.distribution = .fill
//
//        contentView.addSubview(stack)
//        stack.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            // Match Weight: leading = 36
//            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36),
//
//            // Match Weight: width = 0.816794 * superview width
//            stack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.816794),
//
//            // ✅ slightly higher (keep it nice)
//            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//
//            // ✅ MORE bottom space so it doesn't stick to the next cell
//            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22),
//
//            // Match Weight-ish text field height
//            txtExpiryDate.heightAnchor.constraint(equalToConstant: 34)
//        ])
//    }
    
    private func setupLayoutIfNeeded() {
        guard !didSetupLayout else { return }
        didSetupLayout = true

        lblExpiryTitle.translatesAutoresizingMaskIntoConstraints = false
        txtExpiryDate.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [lblExpiryTitle, txtExpiryDate])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fill

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        // ---- CHANGE START: use same margins as other fields on iPad ----
        let isPad = UIDevice.current.userInterfaceIdiom == .pad

        // These should match what you liked in Quantity.
        // If your other fields start at 36, keep 36. If you moved them, use same number here.
        let leftInset: CGFloat = isPad ? 80 : 36
        let rightInset: CGFloat = isPad ? 80 : 36
        // ---- CHANGE END ----

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset),

            // ---- CHANGE START: DO NOT use width multiplier on iPad ----
            isPad
                ? stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -rightInset)
                : stack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.816794),
            // ---- CHANGE END ----

            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -39),
            //-22

            txtExpiryDate.heightAnchor.constraint(equalToConstant: 34)
        ])
    }




    
    
    
}

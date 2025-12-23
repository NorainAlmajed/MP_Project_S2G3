//
//  RaghadSection4TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 13/12/2025.
//

import UIKit

class RaghadSection4TableViewCell: UITableViewCell {

    var onQuantityChanged: ((Int?) -> Void)?   // 🔢 callback
 
    
    @IBOutlet weak var lblQuantityTitle: UILabel!
    
    
    @IBOutlet weak var txtQuantity: UITextField!
    
    
    @IBOutlet weak var stepperQuantity: UIStepper!
    
    
    @IBOutlet weak var lblQuantityError: UILabel!
    
    
    // 🟢 NEW
    private var didSetupIPadAlignment = false
    private var iPadTrailingGuide: UIView?
    private var iPadExtraConstraints: [NSLayoutConstraint] = []
    // 🟢 NEW (keep references so we don’t add duplicates)
    private var iPadStepperTrailing: NSLayoutConstraint?
    private var iPadTxtToStepper: NSLayoutConstraint?
    private var iPadTxtLeading: NSLayoutConstraint?

    private var txtHeightConstraint: NSLayoutConstraint?
    private var txtTrailingToStepperConstraint: NSLayoutConstraint?
    private var stepperTrailingConstraint: NSLayoutConstraint?

    private var iPadTitleLeading: NSLayoutConstraint?
    private var iPadErrorLeading: NSLayoutConstraint?
    private var iPadErrorTrailing: NSLayoutConstraint?
    private var iPadErrorTop: NSLayoutConstraint?


    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        txtQuantity.keyboardType = .numberPad
        txtQuantity.inputAccessoryView = makeDoneToolbar() //done button in the keyboard
                txtQuantity.text = "1"
            stepperQuantity.value = 1
        
        
        // ✅🟡 1) Hide error by default
        lblQuantityError.isHidden = true
        lblQuantityError.text = "Please enter a valid quantity"
        
        //addede this🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡
        lblQuantityError.numberOfLines = 0
        lblQuantityError.lineBreakMode = .byWordWrapping
        lblQuantityError.adjustsFontSizeToFitWidth = false
        lblQuantityError.minimumScaleFactor = 1.0


        // ✅🟡 2) Stepper limits (optional but recommended)
        stepperQuantity.minimumValue = 0
        stepperQuantity.maximumValue = 999
        
        
        
        
        
        txtQuantity.keyboardType = .numberPad
            txtQuantity.inputAccessoryView = makeDoneToolbar()
            txtQuantity.text = "1"
            stepperQuantity.value = 1

            // ✅ MATCH other input fields (Expiration / Choose Donor)
            txtQuantity.layer.borderWidth = 1
            txtQuantity.layer.borderColor = UIColor.systemGray4.cgColor
            txtQuantity.layer.cornerRadius = 8
            txtQuantity.clipsToBounds = true

            // Error label
            lblQuantityError.isHidden = true
            lblQuantityError.text = "Please enter a valid quantity"

            stepperQuantity.minimumValue = 0
            stepperQuantity.maximumValue = 999

     
        
        }
    
    // 🟢 NEW: Apply iPad alignment AFTER layout is done
       override func layoutSubviews() {
           super.layoutSubviews()
           setupIPadAlignmentIfNeeded()  // ✅ safe place
       }
    
    
    
    
    // ✅🟢 VC uses this to show / hide the quantity error label
    func configure(showError: Bool) {
        lblQuantityError.isHidden = !showError
    }

    // ✅🟢 VC uses this to read quantity safely
    func getQuantityValue() -> Int? {
        guard let t = txtQuantity.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !t.isEmpty,
              let v = Int(t) else {
            return nil
        }
        return v
    }

    
    private func makeDoneToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        toolbar.items = [flex, done]
        return toolbar
    }

    @objc private func doneTapped() {
        txtQuantity.resignFirstResponder()
    }

    
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        txtQuantity.text = "\(value)"
        onQuantityChanged?(value)   // ✅ notify VC
    }

    @IBAction func textChanged(_ sender: UITextField) {
        
            
            let t = sender.text ?? ""
            
            // 🔴 Empty → invalid
            if t.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                stepperQuantity.value = 0
                onQuantityChanged?(nil)   // ✅ notify VC: invalid
                return
            }
            
            // 🔴 Not a number → invalid
            guard let value = Int(t) else {
                stepperQuantity.value = 0
                onQuantityChanged?(nil)   // ✅ notify VC: invalid
                return
            }
            
            // 🔴 Negative → invalid
            if value < 0 {
                sender.text = "0"
                stepperQuantity.value = 0
                onQuantityChanged?(nil)   // ✅ notify VC: invalid
                return
            }
            
            // ✅ Valid quantity
            stepperQuantity.value = Double(value)
            onQuantityChanged?(value)    // ✅ notify VC: valid
        }
    
    
    //for the ipad sizing
//    private func setupIPadAlignmentIfNeeded() {
//        guard UIDevice.current.userInterfaceIdiom == .pad else { return }
//        guard !didSetupIPadAlignment else { return }
//        didSetupIPadAlignment = true
//
//        // ✅🟢 1) Weaken ONLY the storyboard width/proportional-width constraint on txtQuantity
//        // This is what causes the big white space.
//        for c in contentView.constraints {
//            let first = c.firstItem as AnyObject?
//            let second = c.secondItem as AnyObject?
//
//            let touchesTxt = (first === txtQuantity || second === txtQuantity)
//
//            // ✅ Any width constraint that touches txtQuantity -> weaken it on iPad
//            if touchesTxt && (c.firstAttribute == .width || c.secondAttribute == .width) {
//                c.priority = .defaultLow      // 🟢 let txtQuantity expand
//            }
//        }
//
//        // ✅🟢 2) Stepper trailing aligned with other fields (same right line)
//        if iPadStepperTrailing == nil {
//            let trailing = stepperQuantity.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60)
//            trailing.priority = .required
//            trailing.isActive = true
//            iPadStepperTrailing = trailing
//        }
//        
//        
//        
//        // ✅🟢 2A) Equal left margin (match right margin)
//        if iPadTxtLeading == nil {
//            let leading = txtQuantity.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60)
//            leading.priority = .required
//            leading.isActive = true
//            iPadTxtLeading = leading
//        }
//        
//        
//
//        // ✅🟢 3) Remove the “gap”: make txtQuantity end right before stepper
//        // (This is the main change you want)
//        if iPadTxtToStepper == nil {
//            let gap = txtQuantity.trailingAnchor.constraint(equalTo: stepperQuantity.leadingAnchor, constant: -10) // 🟢 smaller gap
//            gap.priority = .required
//            gap.isActive = true
//            iPadTxtToStepper = gap
//        }
//
//        // ✅🟢 4) Keep them vertically aligned (safe)
//        stepperQuantity.centerYAnchor.constraint(equalTo: txtQuantity.centerYAnchor).isActive = true
//
//        // Optional: tiny scale
//        stepperQuantity.transform = CGAffineTransform(scaleX: 1.06, y: 1.06)
//    }

           
           
    private func setupIPadAlignmentIfNeeded() {
        guard UIDevice.current.userInterfaceIdiom == .pad else { return }
        guard !didSetupIPadAlignment else { return }
        didSetupIPadAlignment = true

        // Use SAME margins as other fields (based on your storyboard: leading 36)
        let leftInset: CGFloat = 80
        let rightInset: CGFloat = 80
        let gap: CGFloat = 10
        
        lblQuantityTitle.translatesAutoresizingMaskIntoConstraints = false

        if iPadTitleLeading == nil {
            let c = lblQuantityTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset)
            c.priority = .required
            c.isActive = true
            iPadTitleLeading = c
        } else {
            iPadTitleLeading?.constant = leftInset
        }

        
        
        lblQuantityError.translatesAutoresizingMaskIntoConstraints = false

        if iPadErrorLeading == nil {
            let c = lblQuantityError.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset)
            c.priority = .required
            c.isActive = true
            iPadErrorLeading = c
        } else {
            iPadErrorLeading?.constant = leftInset
        }

        if iPadErrorTrailing == nil {
            let c = lblQuantityError.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -rightInset)
            c.priority = .required
            c.isActive = true
            iPadErrorTrailing = c
        } else {
            iPadErrorTrailing?.constant = -rightInset
        }

        if iPadErrorTop == nil {
            let c = lblQuantityError.topAnchor.constraint(equalTo: txtQuantity.bottomAnchor, constant: 6)
            c.priority = .required
            c.isActive = true
            iPadErrorTop = c
        } else {
            iPadErrorTop?.constant = 6
        }
        
        
        

        // 1) Weaken storyboard constraints that fight our iPad layout (txt + stepper)
        for c in contentView.constraints {
            let first = c.firstItem as AnyObject?
            let second = c.secondItem as AnyObject?

            let touchesTxt = (first === txtQuantity || second === txtQuantity)
            let touchesStepper = (first === stepperQuantity || second === stepperQuantity)

            // Any width/proportional width on txtQuantity causes the "not aligned" look on iPad
            if touchesTxt && (c.firstAttribute == .width || c.secondAttribute == .width) {
                c.priority = .defaultLow
            }

            // Also weaken leading/trailing/spacing constraints that touch txt or stepper,
            // because we will replace them with iPad-only required constraints.
            if touchesTxt || touchesStepper {
                if c.firstAttribute == .leading || c.secondAttribute == .leading ||
                   c.firstAttribute == .trailing || c.secondAttribute == .trailing {
                    c.priority = .defaultLow
                }

                if c.firstAttribute == .leading || c.secondAttribute == .leading {
                    // keep low, we will re-add exact ones below
                    c.priority = .defaultLow
                }
            }
        }

        // 2) Add iPad-only constraints that match other fields
        // Stepper trailing to contentView (same right line)
        if iPadStepperTrailing == nil {
            let trailing = stepperQuantity.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -rightInset)
            trailing.priority = .required
            trailing.isActive = true
            iPadStepperTrailing = trailing
        } else {
            iPadStepperTrailing?.constant = -rightInset
        }

        // Textfield leading to contentView (same left line)
        if iPadTxtLeading == nil {
            let leading = txtQuantity.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset)
            leading.priority = .required
            leading.isActive = true
            iPadTxtLeading = leading
        } else {
            iPadTxtLeading?.constant = leftInset
        }

        // Textfield trailing to stepper leading (controls the width)
        if iPadTxtToStepper == nil {
            let toStepper = txtQuantity.trailingAnchor.constraint(equalTo: stepperQuantity.leadingAnchor, constant: -gap)
            toStepper.priority = .required
            toStepper.isActive = true
            iPadTxtToStepper = toStepper
        } else {
            iPadTxtToStepper?.constant = -gap
        }

        // Align vertically
        stepperQuantity.centerYAnchor.constraint(equalTo: txtQuantity.centerYAnchor).isActive = true
    }

    
    
           
         
   }
    

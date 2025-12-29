//
//  ZahraaRecurrenceTableViewCell.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 27/12/2025.
//

import UIKit

class ZahraaRecurrenceTableViewCell: UITableViewCell {

    @IBOutlet weak var reccuringSwitch: UISwitch!
    @IBOutlet weak var frequencyContainer: UIView!
    @IBOutlet weak var frequencyBtn: UIButton!
    @IBOutlet weak var donationFreqLbl: UILabel!
    @IBOutlet weak var recurrDonLbl: UILabel!
    
    //Constraints
    @IBOutlet weak var donationFreqLeading: NSLayoutConstraint!
    @IBOutlet weak var recurrDonLeading: NSLayoutConstraint!
    @IBOutlet weak var frequencyContainerLeading: NSLayoutConstraint!

    
    
    // Callback to notify VC when switch changes
        var onSwitchChanged: ((Bool) -> Void)?
        var onFrequencySelected: ((Int) -> Void)? // returns recurrence integer
    
    
        // Keep track of current recurrence
        private var currentRecurrence: Int = 0

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Make the cell background adaptive
        backgroundColor = .systemBackground
        frequencyContainer.backgroundColor = .systemBackground

        frequencyContainer.isHidden = true
        reccuringSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        frequencyBtn.addTarget(self, action: #selector(frequencyBtnTapped), for: .touchUpInside)

        // Adaptive text color
        frequencyBtn.setTitleColor(.label, for: .normal)
        donationFreqLbl.textColor = .label
        recurrDonLbl.textColor = .label

        // ✅ Change existing system arrow color
        frequencyBtn.tintColor = .label  // black in light, white in dark
    }
 






    
    
    
        func configure(with recurrence: Int) {
            currentRecurrence = recurrence

            if recurrence == 0 {
                reccuringSwitch.isOn = false
                frequencyContainer.isHidden = true
                frequencyBtn.setTitle("Select Frequency", for: .normal)
            } else {
                reccuringSwitch.isOn = true
                frequencyContainer.isHidden = false
                frequencyBtn.setTitle(recurrenceToString(recurrence), for: .normal)
            }
        }

    
    
    @objc private func switchChanged() {
        let isOn = reccuringSwitch.isOn
        frequencyContainer.isHidden = !isOn

        if !isOn {
            currentRecurrence = 0
            frequencyBtn.setTitle("Select Frequency", for: .normal)
            onFrequencySelected?(0) // ✅ sends 0 to VC
        } else if currentRecurrence == 0 {
            currentRecurrence = 1
            frequencyBtn.setTitle(recurrenceToString(1), for: .normal)
            onFrequencySelected?(1)
        }

        onSwitchChanged?(isOn)
    }

    
    
    
    

    @objc private func frequencyBtnTapped() {
        // Create the action sheet
        let alert = UIAlertController(title: "Select Frequency", message: nil, preferredStyle: .actionSheet)
        
        // ✅ Make button text adaptive (black in light, white in dark)
        alert.view.tintColor = .label

        // ✅ Optional: make the title adaptive too
        let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        alert.setValue(NSAttributedString(string: "Select Frequency", attributes: titleAttributes), forKey: "attributedTitle")

        // Options for recurrence
        let options = [("Daily", 1), ("Weekly", 2), ("Monthly", 3), ("Yearly", 4)]
        for (title, value) in options {
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                self.currentRecurrence = value
                self.frequencyBtn.setTitle(title, for: .normal)
                self.onFrequencySelected?(value)
            }))
        }

        // Cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // ✅ iPad popover setup
        if let popover = alert.popoverPresentationController {
            popover.sourceView = frequencyBtn
            popover.sourceRect = frequencyBtn.bounds
        }

        // Present the alert
        parentViewController()?.present(alert, animated: true)
    }

    
    
    
        private func recurrenceToString(_ value: Int) -> String {
            switch value {
            case 1: return "Daily"
            case 2: return "Weekly"
            case 3: return "Monthly"
            case 4: return "Yearly"
            default: return "Select Frequency"
            }
        }
    
    
    }






extension UIView {
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let vc = parentResponder as? UIViewController {
                return vc
            }
        }
        return nil
    }
}



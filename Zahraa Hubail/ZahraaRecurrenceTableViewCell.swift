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
    

        // Callback to notify VC when switch changes
        var onSwitchChanged: ((Bool) -> Void)?
        var onFrequencySelected: ((Int) -> Void)? // returns recurrence integer

        // Keep track of current recurrence
        private var currentRecurrence: Int = 0

        override func awakeFromNib() {
            super.awakeFromNib()
            frequencyContainer.isHidden = true
            reccuringSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
            frequencyBtn.addTarget(self, action: #selector(frequencyBtnTapped), for: .touchUpInside)
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
            // Show a picker or action sheet for the user to select recurrence
            let alert = UIAlertController(title: "Select Frequency", message: nil, preferredStyle: .actionSheet)

            let options = [("Daily", 1), ("Weekly", 2), ("Monthly", 3), ("Yearly", 4)]
            for (title, value) in options {
                alert.addAction(UIAlertAction(title: title, style: .default, handler: { [weak self] _ in
                    self?.currentRecurrence = value
                    self?.frequencyBtn.setTitle(title, for: .normal)
                    self?.onFrequencySelected?(value)
                }))
            }

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            if let vc = self.parentViewController() {
                vc.present(alert, animated: true)
            }
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

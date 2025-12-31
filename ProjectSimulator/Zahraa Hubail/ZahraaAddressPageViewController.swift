//
//  ZahraaAddressPageViewController.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 27/12/2025.
//

import UIKit


class ZahraaAddressPageViewController: UIViewController {

    
        var donation: ZahraaDonation?

        
        weak var delegate: ZahraaAddressDelegate?

        
        @IBOutlet weak var buildingTextField: UITextField!
        
        @IBOutlet weak var roadTextField: UITextField!
        
        @IBOutlet weak var blockTextField: UITextField!
        
        @IBOutlet weak var flatTextField: UITextField!
        
        @IBOutlet weak var areaTextField: UITextField!
        
        @IBOutlet weak var governorateButton: UIButton!
        
        @IBOutlet weak var saveButton: UIButton!
        
        private var selectedGovernorate: String = ""
        private let governorates = ["Capital", "Muharraq", "Northern", "Southern"]
            
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        // Make save button rounded
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        saveButton.clipsToBounds = true

        // Prefill address fields
        configureAddressFields()

        // Governorate button styling (DARK & LIGHT MODE)
        var config = governorateButton.configuration ?? .plain()
        config.baseBackgroundColor = UIColor { trait in
            trait.userInterfaceStyle == .dark ? .black : .clear
        }
        config.baseForegroundColor = UIColor { trait in
            trait.userInterfaceStyle == .dark ? .white : .black
        }
        governorateButton.configuration = config

        // Add subtle border like txtQuantity (systemGray4) for all text fields and governorateButton
        let textFields = [
            buildingTextField,
            roadTextField,
            blockTextField,
            flatTextField,
            areaTextField
        ]

        textFields.forEach { textField in
            textField?.layer.borderWidth = 1
            textField?.layer.cornerRadius = 8
            textField?.layer.borderColor = UIColor { trait in
                trait.userInterfaceStyle == .dark
                    ? UIColor.systemGray4
                    : UIColor.systemGray4  // slightly darker in light mode, matches txtQuantity
            }.cgColor
        }

        // Apply same subtle border to governorateButton
        governorateButton.layer.borderWidth = 1
        governorateButton.layer.cornerRadius = 8
        governorateButton.layer.borderColor = UIColor { trait in
            UIColor.systemGray4
        }.cgColor

    }



    
    
    
    
        private func setupUI() {
            title = "Edit Address Form"
        }
        @IBAction func governorateButtonTapped(_ sender: Any) {
            let alert = UIAlertController(title: "Select Governorate", message: nil, preferredStyle: .actionSheet)
            
            for gov in governorates {
                alert.addAction(UIAlertAction(title: gov, style: .default) { [weak self] _ in
                    self?.selectedGovernorate = gov
                    self?.governorateButton.setTitle(gov, for: .normal)
                })
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    
                    if let popover = alert.popoverPresentationController {
                        popover.sourceView = governorateButton
                        popover.sourceRect = governorateButton.bounds
                    }
                    
                    present(alert, animated: true)
        }
    
    
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {

        guard
            let building = buildingTextField.text, !building.isEmpty,
            let road = roadTextField.text, !road.isEmpty,
            let block = blockTextField.text, !block.isEmpty,
            let area = areaTextField.text, !area.isEmpty,
            !selectedGovernorate.isEmpty
        else {
            showAlert(title: "Error", message: "Please fill in all required fields")
            return
        }

        let flatText = flatTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        // ✅ CREATE A *NEW* ADDRESS OBJECT (DRAFT ONLY)
        let editedAddress = ZahraaAddress(
            building: building,
            road: road,
            block: block,
            flat: flatText?.isEmpty == true ? nil : flatText,
            area: area,
            governorate: selectedGovernorate
        )

        // ✅ SEND BACK (NO DONATION MUTATION)
        delegate?.didAddAddress(editedAddress)

        navigationController?.popViewController(animated: true)
    }


        private func showAlert(title: String, message: String) {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }

    
    private func configureAddressFields() {
        guard let address = donation?.address else { return }

        // Fill text fields
        buildingTextField.text = address.building
        roadTextField.text = address.road
        blockTextField.text = address.block
        areaTextField.text = address.area
        
        // Flat is optional
        if let flat = address.flat, !flat.isEmpty {
            flatTextField.text = flat
        } else {
            flatTextField.text = "" // or leave as placeholder
        }

        // Governorate button
        selectedGovernorate = address.governorate
        governorateButton.setTitle(selectedGovernorate, for: .normal)
    }


    }

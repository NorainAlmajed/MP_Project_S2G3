//
//  AddAddressViewController.swift
//  ProjectSimulator
//
//  Created by Norain  on 26/12/2025.
//

import UIKit

class AddAddressViewController: UIViewController {
    weak var delegate: AddAddressDelegate?

    @IBOutlet weak var nameTextField: UITextField!
    
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
        // Do any additional setup after loading the view.
    }
    private func setupUI() {
        title = "New Address Form"
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
        guard let name = nameTextField.text, !name.isEmpty,
              let building = buildingTextField.text, !building.isEmpty,
              let road = roadTextField.text, !road.isEmpty,
              let block = blockTextField.text, !block.isEmpty,
              let area = areaTextField.text, !area.isEmpty,
              !selectedGovernorate.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all required fields")
            return
        }
                
        let address = Address(
            name: name,
            building: building,
            road: road.description,
            block: block.description,
            flat: flatTextField.text ?? "",
            area: area,
            governorate: selectedGovernorate
        )
                
        delegate?.didAddAddress(address)
        if let nav = self.navigationController {
                nav.popViewController(animated: true) // Go back in stack
            } else {
                self.dismiss(animated: true) // Close modal
            }
    }
    
    private func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

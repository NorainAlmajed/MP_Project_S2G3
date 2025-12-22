//
//  NGOSignupViewController.swift
//  ProjectSimulator
//
//  Created by BP-36-201-02 on 20/12/2025.
//

import UIKit
import FirebaseAuth

class NGOSignupViewController: UIViewController,
                              UIPickerViewDelegate,
                              UIPickerViewDataSource,
                              UIImagePickerControllerDelegate,
                              UINavigationControllerDelegate {
    
    let causePicker = UIPickerView()
    let governoratePicker = UIPickerView()

    let causes = [
        "Orphans",
        "Chronically Ill",
        "Disabled People",
        "Children",
        "Women",
        "Elderly"
    ]

    let governorates = [
        "Manama Governorate",
        "Muharraq Governorate",
        "Southern Governorate",
        "Northern Governorate"
    ]

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var causeTextField: UITextField!
    @IBOutlet weak var governorateTextField: UITextField!
    @IBOutlet weak var licenseImageView: UIImageView!
    
    @IBAction func uploadLicenseTapped(_ sender: Any) {
        showImagePicker()
    }
    
    @IBAction func goToLoginTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated:true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide cursor so field behave like dropdowns
        causeTextField.tintColor = .clear
        governorateTextField.tintColor = .clear

        causePicker.delegate = self
        causePicker.dataSource = self
        causePicker.tag = 1

        governoratePicker.delegate = self
        governoratePicker.dataSource = self
        governoratePicker.tag = 2

        causeTextField.inputView = causePicker
        governorateTextField.inputView = governoratePicker

        addToolbar(to: causeTextField)
        addToolbar(to: governorateTextField)
    }
    
    func showImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = info[.editedImage] as? UIImage {
            licenseImageView.image = image
        } else if let image = info[.originalImage] as? UIImage {
            licenseImageView.image = image
        }

        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 1 ? causes.count : governorates.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 1 ? causes[row] : governorates[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            causeTextField.text = causes[row]
        } else {
            governorateTextField.text = governorates[row]
        }
    }
    
    func addToolbar(to textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneTapped)
        )

        toolbar.setItems([doneButton], animated: false)
        textField.inputAccessoryView = toolbar
    }

    @objc func doneTapped() {
        view.endEditing(true)
    }



    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(
                title: "Missing Email",
                message: "Please enter an email address."
            )
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(
                title: "Missing Password",
                message: "Please enter a password."
            )
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text,
              !confirmPassword.isEmpty else {
            showAlert(
                title: "Missing Confirmation",
                message: "Please confirm your password."
            )
            return
        }
        
        guard password == confirmPassword else {
            showAlert(
                title: "Password Mismatch",
                message: "Passwords do not match. Please try again."
            )
            return
        }
        
        guard password.count >= 6 else {
            showAlert(
                title: "Weak Password",
                message: "Password must be at least 6 characters long."
            )
            return
        }
        
        guard let address = addressTextField.text, !address.isEmpty else {
            showAlert(
                title: "Missing Address",
                message: "Please enter an Address."
            )
            return
        }
        
        guard let cause = causeTextField.text, !cause.isEmpty else {
            showAlert(title: "Missing Cause", message: "Please select a cause.")
            return
        }

        guard let governorate = governorateTextField.text, !governorate.isEmpty else {
            showAlert(title: "Missing Governorate", message: "Please select a governorate.")
            return
        }
        
        guard let licenseImage = licenseImageView.image else {
            showAlert(
                title: "Missing License",
                message: "Please upload your NGO license."
            )
            return
        }

        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            
            if let error = error {
                self?.showAlert(
                    title: "Registration Failed",
                    message: error.localizedDescription
                )
                return
            }
            
            if let userID = authResult?.user.uid {
                UserDefaults.standard.set(userID, forKey: "userID")
            }

            //if let sceneDelegate = UIApplication.shared.connectedScenes
                //.first?.delegate as? SceneDelegate {
                //sceneDelegate.setRootViewController()
            //}
            
            self?.showAlert(
                title: "Success",
                message: "Account created successfully!"
            )
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

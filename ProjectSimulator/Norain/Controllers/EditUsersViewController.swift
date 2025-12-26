//
//  EditUsersViewController.swift
//  ProjectSimulator
//
//  Created by Norain  on 19/12/2025.
//

import UIKit


class EditUsersViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var userToEdit:AppUser!
    
    
    @IBOutlet weak var causeStack: UIStackView!
    @IBOutlet weak var addressStack: UIStackView!
    @IBOutlet weak var govStack: UIStackView!
    @IBOutlet weak var statusStack: UIStackView!
    
    @IBOutlet weak var licenseBtn: UIButton!
    @IBOutlet weak var uploadPicBtn: UIButton!
    @IBOutlet weak var ImagePickerEditView: UIImageView!
    
    @IBOutlet weak var causebtn: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var governorateBtn: UIButton!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = (userToEdit is NGO) ? "NGO Profile" : "Donor Profile"
        
        // Add a 'Save' button to the right side of the bar
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped))
        self.navigationItem.rightBarButtonItem = saveButton
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.leftBarButtonItem = backButton
        backButton.tintColor = .black
        self.setupView()
        populateData()
        setupMenus()
    }
    
    @IBAction func saveChangesTapped(_ sender: Any) {
        saveTapped()
    }
    
    @objc func saveTapped() {
        // 1. Update the local object data
        userToEdit.userName = usernameField.text ?? ""
        userToEdit.name = nameField.text ?? ""
        userToEdit.email = emailField.text ?? ""
        
        if let phoneText = phoneField.text, let phoneValue = Int(phoneText) {
            userToEdit.phoneNumber = phoneValue
        }
        
        if let ngo = userToEdit as? NGO {
            ngo.address = addressField.text ?? ""
            ngo.governorate = governorateBtn.currentTitle ?? ""
            ngo.cause = causebtn.currentTitle ?? ""
            
            if let statusTitle = statusBtn.currentTitle,
               let newStatus = NGOStatus(rawValue: statusTitle) {
                ngo.status = newStatus
            }
        }

        // 2. Show Success Alert
        let alert = UIAlertController(title: "Success", message: "Changes have been saved locally.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Go back after user clicks OK
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true)
    }
    
    
    
    @objc func backTapped() {
        //  closes the full-screen modal and takes you back to the previous screen
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        // 1. Create the confirmation alert
            let alert = UIAlertController(
                title: "Delete Confirmation",
                message: "Are you sure you want to remove this user? This action cannot be undone.",
                preferredStyle: .actionSheet // .actionSheet looks good for delete actions
            )
            
            // 2. Add the Delete action (Destructive style makes it red)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                self.performDeletion()
            }
            
            // 3. Add Cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
    }
    
    func performDeletion() {
        // Find the user in your global AppData list and remove them
        // We use the unique ID (uId) to make sure we delete the right one
        AppData.users.removeAll { $0.userName == userToEdit.userName }
        
        // Optional: Show a final confirmation or just pop back
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadPhotoTapped(_ sender: UIButton) {
        showPhotoAlert()
    }
    
    func populateData() {
        // 1. Ensure userToEdit is not nil
        guard let user = userToEdit else {
            print("Error: userToEdit was not passed to this ViewController")
            return
        }

        // 2. Use optional chaining to prevent crashes if Outlets are missing
        usernameField?.text = user.userName
        nameField?.text = user.name
        phoneField?.text = "\(user.phoneNumber)"
        emailField?.text = user.email
        
        if let ngo = user as? NGO {
            addressField?.text = ngo.address
            causebtn?.setTitle(ngo.cause, for: .normal)
            statusBtn?.setTitle(ngo.status.rawValue, for: .normal)
            
            // Also set governorate title if it exists
            governorateBtn?.setTitle(ngo.governorate, for: .normal)
        }
    }
    
    func setupMenus() {
            // --- Governorate Menu ---
            let govOptions = ["Capital", "Muharraq", "Northern", "Southern"]
            let govActions = govOptions.map { title in
                UIAction(title: title, handler: { _ in self.governorateBtn.setTitle(title, for: .normal) })
            }
            governorateBtn.menu = UIMenu(title: "Select Governorate", children: govActions)
            governorateBtn.showsMenuAsPrimaryAction = true
            
            // --- Status Menu ---
            let statusActions = NGOStatus.allCases.map { statusCase in
                UIAction(title: statusCase.rawValue, handler: { _ in
                    self.statusBtn.setTitle(statusCase.rawValue, for: .normal)
                })
            }
            statusBtn.menu = UIMenu(title: "Select Status", children: statusActions)
            statusBtn.showsMenuAsPrimaryAction = true
            
            // --- Causes Menu ---
            let causeOptions = ["Orphans", "Chronically ill", "Disabled people", "Children", "Women", "Elderly"]
            let causeActions = causeOptions.map { title in
                UIAction(title: title, handler: { _ in self.causebtn.setTitle(title, for: .normal) })
            }
            causebtn.menu = UIMenu(title: "Select Cause", children: causeActions)
            causebtn.showsMenuAsPrimaryAction = true
        }
    
    func setupView() {
        let isNGO = userToEdit is NGO
        causeStack.isHidden = !isNGO
        addressStack.isHidden = !isNGO
        govStack.isHidden = !isNGO
        statusStack.isHidden = !isNGO
        licenseBtn.isHidden = !isNGO
        
    }
    
    
    
    func showPhotoAlert(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {action
            in
            self.getPhoto(type: .camera)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {action in
            self.getPhoto(type: .photoLibrary)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func getPhoto(type:UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            print("Image not found")
            return  }
        ImagePickerEditView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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

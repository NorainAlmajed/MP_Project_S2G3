//
//  EditUsersViewController.swift
//  ProjectSimulator
//
//  Created by Norain  on 19/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import Cloudinary

protocol EditUserDelegate: AnyObject {
    func didUpdateUser()
}

class EditUsersViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var userToEdit: NorainAppUser!
    weak var delegate: EditUserDelegate?
    private let cloudinaryService = CloudinaryService()
    private var isUploadingImage = false
    private var uploadedImageUrl: String?
    private let db = Firestore.firestore()
    
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
        self.title = (userToEdit is NorainNGO) ? "NGO Profile" : "Donor Profile"
        
        // Add a 'Save' button to the right side of the bar
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped))
        self.navigationItem.rightBarButtonItem = saveButton
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.leftBarButtonItem = backButton
        backButton.tintColor = .black
        
        uploadPicBtn.addTarget(self, action: #selector(uploadPhotoTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadPhotoTapped))
        ImagePickerEditView.addGestureRecognizer(tapGesture)
        
        self.setupView()
        fetchUserFromFirestore()
        setupMenus()
    }
    
    // MARK: - Firebase Read
    private func fetchUserFromFirestore() {
        guard let user = userToEdit else {
            print("Error: userToEdit was not passed to this ViewController")
            return
        }
        
        // Fetch the user document from Firestore using username as document ID
        db.collection("users").document(user.documentID).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Error fetching user: \(error.localizedDescription)")
                // Fallback to local data if fetch fails
                self.populateDataFromLocal()
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                print("⚠️ Document does not exist, using local data")
                self.populateDataFromLocal()
                return
            }
            
            // Update the UI with Firebase data
            self.populateDataFromFirestore(data: data)
            print("✅ User data fetched from Firestore")
        }
    }
    
    private func populateDataFromFirestore(data: [String: Any]) {
        usernameField?.text = data["username"] as? String
        nameField?.text = data["full_name"] as? String
        phoneField?.text = "\(data["number"] as? Int ?? 0)"
        emailField?.text = data["email"] as? String
        
        if let imageUrlString = data["profile_image_url"] as? String, !imageUrlString.isEmpty {
                FetchImage.fetchImage(from: imageUrlString) { [weak self] image in
                    if let downloadedImage = image {
                        self?.ImagePickerEditView.image = downloadedImage
                    } else {
                        self?.ImagePickerEditView.image = UIImage(systemName: "person.circle.fill")
                    }
                }
            } else {
                self.ImagePickerEditView.image = UIImage(systemName: "person.circle.fill")
            }
        let role = data["role"] as? Int ?? 0
        
        if role == 3 { // NGO
            addressField?.text = data["address"] as? String
            nameField?.text = data["organization_name"] as? String
            governorateBtn?.setTitle(data["governorate"] as? String, for: .normal)
            causebtn?.setTitle(data["cause"] as? String, for: .normal)
            
            if let statusString = data["status"] as? String,
               let status = NGOStatus(rawValue: statusString) {
                statusBtn?.setTitle(status.rawValue, for: .normal)
            }
        }
    }
    
    private func populateDataFromLocal() {
        // Fallback to local object if Firebase fails
        guard let user = userToEdit else { return }
        
        usernameField?.text = user.username
        nameField?.text = user.name
        phoneField?.text = "\(user.phoneNumber)"
        emailField?.text = user.email
        if !user.userImg.isEmpty {
                FetchImage.fetchImage(from: user.userImg) { [weak self] image in
                    self?.ImagePickerEditView.image = image ?? UIImage(systemName: "person.circle.fill")
                }
            } else {
                self.ImagePickerEditView.image = UIImage(systemName: "person.circle.fill")
            }
        
        if let ngo = user as? NorainNGO {
            addressField?.text = ngo.address
            causebtn?.setTitle(ngo.cause, for: .normal)
            statusBtn?.setTitle(ngo.status.rawValue, for: .normal)
            governorateBtn?.setTitle(ngo.governorate, for: .normal)
        }
    }
    
    // MARK: - Firebase Write
    @IBAction func saveChangesTapped(_ sender: Any) {
        saveTapped()
    }
    
    @objc func saveTapped() {
        if isUploadingImage {
                showAlert(title: "Please Wait", message: "Image is still uploading. Please wait a moment.")
                return
            }
            
            guard let user = userToEdit else {
                showAlert(title: "Error", message: "No user to save")
                return
            
        }
        

        
        // Prepare the update data
        var updateData: [String: Any] = [
            "username": usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            "name": nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            "email": emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            "phoneNumber": Int(phoneField.text ?? "0") ?? 0
        ]
        
        // Add NGO-specific fields if this is an NGO
        if let ngo = user as? NorainNGO {
            updateData["address"] = addressField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            updateData["governorate"] = governorateBtn.currentTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            updateData["cause"] = causebtn.currentTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            if let statusTitle = statusBtn.currentTitle,
               let newStatus = NGOStatus(rawValue: statusTitle) {
                updateData["status"] = newStatus.rawValue
            }
        }
        
        // Show loading state
        saveBtn.isEnabled = false
        saveBtn.setTitle("Saving...", for: .normal)
        
        db.collection("users").document(user.documentID).updateData(updateData) { [weak self] error in
            guard let self = self else { return }
            
            self.saveBtn.isEnabled = true
            self.saveBtn.setTitle("Save Changes", for: .normal)
            
            if let error = error {
                print("❌ Error updating user: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "Failed to save changes: \(error.localizedDescription)")
            } else {
                print("✅ User updated successfully")
                self.updateLocalObject(with: updateData)
                
                // Notify the list view that data has changed
                self.delegate?.didUpdateUser()
                
                // Show success alert and pop
                let alert = UIAlertController(title: "Success", message: "Changes saved.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    private func updateLocalObject(with data: [String: Any]) {
        userToEdit.username = data["username"] as? String ?? userToEdit.username
        userToEdit.name = data["name"] as? String ?? userToEdit.name
        userToEdit.email = data["email"] as? String ?? userToEdit.email
        userToEdit.phoneNumber = data["phoneNumber"] as? Int ?? userToEdit.phoneNumber
        
        if let ngo = userToEdit as? NorainNGO {
            ngo.address = data["address"] as? String ?? ngo.address
            ngo.governorate = data["governorate"] as? String ?? ngo.governorate
            ngo.cause = data["cause"] as? String ?? ngo.cause
            
            if let statusString = data["status"] as? String,
               let status = NGOStatus(rawValue: statusString) {
                ngo.status = status
            }
        }
    }
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Delete User
    @IBAction func deleteBtnTapped(_ sender: Any) {
        let alert = UIAlertController(
            title: "Delete Confirmation",
            message: "Are you sure you want to remove this user? This action cannot be undone.",
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.performDeletion()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func performDeletion() {
        guard let user = userToEdit else { return }
        
        // Show loading
        deleteBtn.isEnabled = false
        deleteBtn.setTitle("Deleting...", for: .normal)
        
        // Delete from Firestore
        db.collection("users").document(user.documentID).delete { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Error deleting user: \(error.localizedDescription)")
                self.deleteBtn.isEnabled = true
                self.deleteBtn.setTitle("Delete User", for: .normal)
                self.showAlert(title: "Error", message: "Failed to delete user: \(error.localizedDescription)")
            } else {
                print("✅ User deleted from Firestore")
                
                            
                // Show success and go back
                let alert = UIAlertController(title: "Deleted", message: "User has been removed.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    // MARK: - Helper Methods
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
        ImagePickerEditView.layer.cornerRadius = 8
        ImagePickerEditView.clipsToBounds = true
        ImagePickerEditView.contentMode = .scaleAspectFill
        
        ImagePickerEditView.isUserInteractionEnabled = false
        
        uploadPicBtn.isUserInteractionEnabled = true
        uploadPicBtn.isEnabled = true
        
        let isNGO = userToEdit is NorainNGO
        causeStack.isHidden = !isNGO
        addressStack.isHidden = !isNGO
        govStack.isHidden = !isNGO
        statusStack.isHidden = !isNGO
        licenseBtn.isHidden = !isNGO
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Photo Upload
    @objc func uploadPhotoTapped(_ sender: UIButton) {
        showPhotoAlert()
    }
    
    func showPhotoAlert() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { action in
            self.getPhoto(type: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            self.getPhoto(type: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func getPhoto(type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        // 1. Immediately show the image locally so the UI feels fast
        ImagePickerEditView.image = image
        
        // 2. Start the upload process
        uploadImageToCloudinary(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Upload Image to Cloudinary
    private func uploadImageToCloudinary(_ image: UIImage) {
        guard let user = userToEdit else { return }
        
        // Show uploading state
        self.saveBtn.isEnabled = false
        self.saveBtn.setTitle("Uploading Image...", for: .normal)
        self.isUploadingImage = true
        
        cloudinaryService.uploadImage(image) { [weak self] url in
            guard let self = self else { return }
            
            self.isUploadingImage = false
            self.saveBtn.isEnabled = true
            self.saveBtn.setTitle("Save Changes", for: .normal)
            
            guard let imageUrl = url else {
                print("❌ Cloudinary upload failed")
                self.showAlert(title: "Upload Failed", message: "Could not upload image. Please try again.")
                return
            }
            
            print("✅ Cloudinary Image URL:", imageUrl)
            self.uploadedImageUrl = imageUrl
            
            // Update Firestore with the new Cloudinary URL
            self.db.collection("users").document(user.documentID).updateData([
                "profile_image_url": imageUrl
            ]) { error in
                if let error = error {
                    print("❌ Failed to update image URL in Firestore:", error.localizedDescription)
                    self.showAlert(title: "Error", message: "Image uploaded but failed to save URL")
                } else {
                    print("✅ Image URL saved to Firestore")
                    self.userToEdit.userImg = imageUrl
                    self.delegate?.didUpdateUser()

                }
            }
        }
    }
}

//
//  SetupProfileViewController.swift
//  ProjectSimulator
//
//  Created by BP-36-201-02 on 22/12/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SetupProfileViewController: UIViewController,
                                  UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var bioCounterLabel: UILabel!
    
    var userRole: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        bioTextView.delegate = self
        bioCounterLabel.text = "0 / 240"
    }

    @IBAction func notificationSwitchChanged(_ sender: UISwitch) {

        if sender.isOn == false {
            let alert = UIAlertController(
                title: "Disable Notifications?",
                message: "Are you sure you want to disable notifications?",
                preferredStyle: .alert
            )

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                sender.setOn(true, animated: true)
            }

            let confirmAction = UIAlertAction(title: "Disable", style: .destructive)

            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            present(alert, animated: true)
        }
    }

    // MARK: - Image Picker
    @IBAction func addPhotoTapped(_ sender: UIButton) {
        showImagePicker()
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
            profileImageView.image = image
        } else if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    // MARK: - Continue
    @IBAction func continueTapped(_ sender: UIButton) {
        saveProfileAndGoHome()
    }

    func saveProfileAndGoHome() {

        guard let fullName = fullNameTextField.text, !fullName.isEmpty else {
            showAlert(title: "Missing Name", message: "Please enter your full name.")
            return
        }

        guard let bio = bioTextView.text, !bio.isEmpty else {
            showAlert(title: "Missing Bio", message: "Please add a short bio.")
            return
        }

        guard let uid = Auth.auth().currentUser?.uid else { return }

        let notificationsEnabled = notificationsSwitch.isOn

        // 🔧 Placeholder for Cloudinary
        let profileImageUrl = ""   // will be filled later

        let db = Firestore.firestore()
        db.collection("users").document(uid).updateData([
            "full_name": fullName,
            "bio": bioTextView.text ?? "",
            "notifications_enabled": notificationsEnabled,
            "profile_image_url": profileImageUrl,
            "profile_completed": true
        ]) { [weak self] error in

            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }

            self.routeToDashboard()
        }
    }

    func routeToDashboard() {
        guard let role = userRole else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = role == "NGO"
            ? "NGOHomeViewController"
            : "DonorHomeViewController"

        let homeVC = storyboard.instantiateViewController(withIdentifier: identifier)

        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate {

            sceneDelegate.window?.rootViewController = homeVC
            sceneDelegate.window?.makeKeyAndVisible()
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
    
    func textViewDidChange(_ textView: UITextView) {
        let currentCount = textView.text.count
        let maxCount = 240

        if currentCount > maxCount {
            textView.text = String(textView.text.prefix(maxCount))
        }

        bioCounterLabel.text = "\(textView.text.count) / 240"
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {

        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 240
    }
}

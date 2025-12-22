//
//  SetupProfileViewController.swift
//  ProjectSimulator
//
//  Created by BP-36-201-02 on 22/12/2025.
//

//
//  SetupProfileViewController.swift
//  ProjectSimulator
//

import UIKit

class SetupProfileViewController: UIViewController,
                                  UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var notificationsSwitch: UISwitch!

    var userRole: String?   // "NGO" or "Donor"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func notificationSwitchChanged(_ sender: UISwitch) {

        // Only confirm when turning OFF
        if sender.isOn == false {

            let alert = UIAlertController(
                title: "Disable Notifications?",
                message: "Are you sure you want to disable notifications?",
                preferredStyle: .alert
            )

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                sender.setOn(true, animated: true)
            }

            let confirmAction = UIAlertAction(title: "Disable", style: .destructive) { _ in
                sender.setOn(false, animated: true)
            }

            alert.addAction(cancelAction)
            alert.addAction(confirmAction)

            present(alert, animated: true)
        }
    }

    @IBAction func addPhotoTapped(_ sender: UIButton) {
        showImagePicker()
    }

    @IBAction func continueTapped(_ sender: UIButton) {
        saveProfileAndGoHome()
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

    func saveProfileAndGoHome() {

        guard let fullName = fullNameTextField.text, !fullName.isEmpty else {
            showAlert(title: "Missing Name", message: "Please enter your full name.")
            return
        }

        guard let bio = bioTextView.text, !bio.isEmpty else {
            showAlert(title: "Missing Bio", message: "Please add a short bio.")
            return
        }

        let notificationsEnabled = notificationsSwitch.isOn
        let profileImage = profileImageView.image

        // TODO:
        // Upload profileImage to Cloudinary
        // Save fullName, bio, notificationsEnabled, userRole to Firestore

        // Navigate to Home
        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate {
//            sceneDelegate.setRootViewController()
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

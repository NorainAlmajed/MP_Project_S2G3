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
                                  UINavigationControllerDelegate,
                                  UITextViewDelegate {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var bioCounterLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        styleActionButton(continueButton)
        styleActionButton(uploadButton)
        title = "Setup Profile"
        bioTextView.delegate = self
        bioCounterLabel.text = "0 / 240"

        navigationItem.hidesBackButton = true
    }

    @IBAction func notificationSwitchChanged(_ sender: UISwitch) {
        if sender.isOn == false {
            let alert = UIAlertController(
                title: "Disable Notifications?",
                message: "Are you sure you want to disable notifications?",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                sender.setOn(true, animated: true)
            })

            alert.addAction(UIAlertAction(title: "Disable", style: .destructive))

            present(alert, animated: true)
        }
    }

    @IBAction func addPhotoTapped(_ sender: UIButton) {
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

    @IBAction func continueTapped(_ sender: UIButton) {

        guard let fullName = fullNameTextField.text, !fullName.isEmpty else {
            showAlert(title: "Missing Name", message: "Please enter your full name.")
            return
        }

        guard let bio = bioTextView.text, !bio.isEmpty else {
            showAlert(title: "Missing Bio", message: "Please add a short bio.")
            return
        }

        guard let image = profileImageView.image else {
            showAlert(title: "Missing Photo", message: "Please upload a profile photo.")
            return
        }

        continueButton.isEnabled = false

        let cloudinaryService = CloudinaryService()
        cloudinaryService.uploadImage(image) { [weak self] imageUrl in
            guard let self = self else { return }

            if let imageUrl = imageUrl {
                self.saveProfile(
                    fullName: fullName,
                    bio: bio,
                    profileImageUrl: imageUrl
                )
            } else {
                self.continueButton.isEnabled = true
                self.showAlert(
                    title: "Upload Failed",
                    message: "Could not upload profile image."
                )
            }
        }
    }

    func saveProfile(fullName: String, bio: String, profileImageUrl: String) {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .updateData([
                "full_name": fullName,
                "bio": bio,
                "notifications_enabled": notificationsSwitch.isOn,
                "profile_image_url": profileImageUrl,
                "profile_completed": true
            ]) { [weak self] error in

                guard let self = self else { return }

                if let error = error {
                    self.continueButton.isEnabled = true
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }

                SessionManager.shared.fetchUserRole { success in
                    DispatchQueue.main.async {
                        self.routeToDashboard()
                    }
                }
            }
    }

    func routeToDashboard() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier: String

        if SessionManager.shared.isAdmin {
            identifier = "AdminHomeViewController"
        } else if SessionManager.shared.isNGO {
            identifier = "NGOHomeViewController"
        } else if SessionManager.shared.isDonor {
            identifier = "DonorHomeViewController"
        } else {
            return
        }

        let homeVC = storyboard.instantiateViewController(withIdentifier: identifier)

        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = homeVC
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        let max = 240
        if textView.text.count > max {
            textView.text = String(textView.text.prefix(max))
        }
        bioCounterLabel.text = "\(textView.text.count) / 240"
    }

    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let current = textView.text ?? ""
        guard let stringRange = Range(range, in: current) else { return false }
        let updated = current.replacingCharacters(in: stringRange, with: text)
        return updated.count <= 240
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func styleActionButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
    }
}


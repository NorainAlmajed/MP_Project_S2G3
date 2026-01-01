import UIKit
import FirebaseAuth
import FirebaseFirestore

class SetupProfileViewController: UIViewController,
                                  UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate {


    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var bioTitleLabel: UILabel!
    @IBOutlet weak var bioCounterLabel: UILabel!
    @IBOutlet weak var notificationsSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        styleActionButton(continueButton)
        styleActionButton(uploadButton)
        title = "Setup Profile"
        navigationItem.hidesBackButton = true

        preloadUserData()
        configureBioTitle()

        bioCounterLabel.text = "0 / 240"

        bioTextField.addTarget(
            self,
            action: #selector(bioTextChanged),
            for: .editingChanged
        )
    }

    func preloadUserData() {
        fullNameTextField.text = SessionManager.shared.fullName
    }

    func configureBioTitle() {
        if SessionManager.shared.isNGO {
            bioTitleLabel.text = "Mission"
            bioTextField.placeholder = "Describe your NGO mission"
        } else {
            bioTitleLabel.text = "Bio"
            bioTextField.placeholder = "Tell us about yourself"
        }
    }

    @objc func bioTextChanged() {
        let maxLength = 240
        let text = bioTextField.text ?? ""

        if text.count > maxLength {
            bioTextField.text = String(text.prefix(maxLength))
        }

        bioCounterLabel.text = "\(bioTextField.text?.count ?? 0) / 240"
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
        if let image = info[.editedImage] as? UIImage ??
                       info[.originalImage] as? UIImage {
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

        guard let bio = bioTextField.text, !bio.isEmpty else {
            showAlert(
                title: "Missing \(SessionManager.shared.isNGO ? "Mission" : "Bio")",
                message: "Please fill in this field."
            )
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

            guard let imageUrl = imageUrl else {
                self.continueButton.isEnabled = true
                self.showAlert(
                    title: "Upload Failed",
                    message: "Could not upload profile image."
                )
                return
            }

            self.saveProfile(
                fullName: fullName,
                bio: bio,
                profileImageUrl: imageUrl
            )
        }
    }

    func saveProfile(fullName: String, bio: String, profileImageUrl: String) {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .updateData([
                "full_name": fullName,
                "mission": bio,
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

                SessionManager.shared.loadUserSession { _ in
                    DispatchQueue.main.async {
                        self.routeToDashboard()
                    }
                }
            }
    }

    func routeToDashboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let tabBarVC = storyboard.instantiateInitialViewController() else {
            print("Tab bar not found in Main storyboard")
            return
        }

        guard let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate else { return }

        sceneDelegate.window?.rootViewController = tabBarVC
        sceneDelegate.window?.makeKeyAndVisible()
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

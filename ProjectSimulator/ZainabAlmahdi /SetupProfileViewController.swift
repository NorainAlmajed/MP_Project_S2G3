import UIKit
import FirebaseAuth
import FirebaseFirestore

class SetupProfileViewController: UIViewController,
                                  UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate,
                                  UITextViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var bioTitleLabel: UILabel!
    @IBOutlet weak var bioCounterLabel: UILabel!
    @IBOutlet weak var notificationsSwitch: UISwitch!

    private let maxBioLength = 240
    private var bioPlaceholderText = ""

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Setup Profile"
        navigationItem.hidesBackButton = true

        styleActionButton(continueButton)
        styleActionButton(uploadButton)

        preloadUserData()
        configureBioTitle()
        configureBioTextView()

        bioCounterLabel.text = "0 / \(maxBioLength)"
        
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        profileImageView.applyProfileStyle(
            cornerRadius: 12
        )
    }

    // MARK: - Preload
    func preloadUserData() {
        fullNameTextField.text = SessionManager.shared.fullName

        if let imageUrl = SessionManager.shared.profileImageURL {
            profileImageView.loadProfileImage(from: imageUrl)
        }
    }

    // MARK: - Bio Configuration
    func configureBioTitle() {
        if SessionManager.shared.isNGO {
            bioTitleLabel.text = "Mission"
            bioPlaceholderText = "Describe your NGO mission"
        } else {
            bioTitleLabel.text = "Bio"
            bioPlaceholderText = "Tell us about yourself"
        }
    }

    func configureBioTextView() {
        bioTextView.delegate = self
        bioTextView.layer.cornerRadius = 8
        bioTextView.layer.borderWidth = 1
        bioTextView.layer.borderColor = UIColor.systemGray4.cgColor
        bioTextView.backgroundColor = .systemBackground
        bioTextView.font = UIFont.systemFont(ofSize: 16)
        bioTextView.textContainerInset = UIEdgeInsets(
            top: 12, left: 10, bottom: 12, right: 10
        )

        bioTextView.text = bioPlaceholderText
        bioTextView.textColor = .placeholderText
    }

    // MARK: - UITextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
        textView.layer.borderColor = UIColor.systemBlue.cgColor
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = bioPlaceholderText
            textView.textColor = .placeholderText
            bioCounterLabel.text = "0 / \(maxBioLength)"
        }
        textView.layer.borderColor = UIColor.systemGray4.cgColor
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > maxBioLength {
            textView.text = String(textView.text.prefix(maxBioLength))
        }
        bioCounterLabel.text = "\(textView.text.count) / \(maxBioLength)"
    }

    // MARK: - Image Picker
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

            profileImageView.applyProfileStyle(
                cornerRadius: 12
            )
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    // MARK: - Continue
    @IBAction func continueTapped(_ sender: UIButton) {

        guard let fullName = fullNameTextField.text, !fullName.isEmpty else {
            showAlert(title: "Missing Name", message: "Please enter your full name.")
            return
        }

        let bio = bioTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if bio.isEmpty || bioTextView.textColor == .placeholderText {
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

        CloudinaryService().uploadImage(image) { [weak self] imageUrl in
            guard let self = self else { return }

            guard let imageUrl = imageUrl else {
                self.continueButton.isEnabled = true
                self.showAlert(title: "Upload Failed", message: "Could not upload profile image.")
                return
            }

            self.saveProfile(
                fullName: fullName,
                bio: bio,
                profileImageUrl: imageUrl
            )
        }
    }

    // MARK: - Save Profile
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

                self.routeToLogin()
            }
    }

    // MARK: - Routing (LOGIN)
    func routeToLogin() {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        guard let loginVC = storyboard.instantiateInitialViewController() else { return }

        guard let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate else { return }

        sceneDelegate.window?.rootViewController = loginVC
        sceneDelegate.window?.makeKeyAndVisible()
    }

    // MARK: - Helpers
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

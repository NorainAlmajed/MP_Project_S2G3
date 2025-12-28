import UIKit
import FirebaseAuth
import FirebaseFirestore

class NGOSignupViewController: UIViewController,
                              UIPickerViewDelegate,
                              UIPickerViewDataSource,
                              UIImagePickerControllerDelegate,
                              UINavigationControllerDelegate {

    // MARK: - Pickers
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

    // MARK: - Outlets
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        styleActionButton(uploadButton)
        styleActionButton(signupButton)
        navigationItem.title = "Sign Up"

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

    // MARK: - Navigation
    @IBAction func goToLoginTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Image Picker
    @IBAction func uploadLicenseTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

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

    // MARK: - Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        pickerView.tag == 1 ? causes.count : governorates.count
    }

    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        pickerView.tag == 1 ? causes[row] : governorates[row]
    }

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if pickerView.tag == 1 {
            causeTextField.text = causes[row]
        } else {
            governorateTextField.text = governorates[row]
        }
    }

    func addToolbar(to textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let done = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneTapped)
        )

        toolbar.setItems([done], animated: false)
        textField.inputAccessoryView = toolbar
    }

    @objc func doneTapped() {
        view.endEditing(true)
    }

    // MARK: - Register
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard validateInputs() else { return }

        guard let licenseImage = licenseImageView.image else {
            showAlert(title: "Missing License", message: "Please upload NGO license.")
            return
        }

        signupButton.isEnabled = false

        let cloudinaryService = CloudinaryService()
        cloudinaryService.uploadImage(licenseImage) { url in
            if let url = url {
                self.createNGOAccount(licenseUrl: url)
            } else {
                self.signupButton.isEnabled = true
                self.showAlert(title: "Upload Failed", message: "Could not upload NGO license.")
            }
        }
    }

    // MARK: - Validation
    func validateInputs() -> Bool {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let confirm = confirmPasswordTextField.text ?? ""
        let phone = phoneNumberTextField.text ?? ""

        guard !email.isEmpty else { showAlert(title: "Missing Email", message: "Enter email"); return false }
        guard !password.isEmpty else { showAlert(title: "Missing Password", message: "Enter password"); return false }
        guard password == confirm else { showAlert(title: "Password Mismatch", message: "Passwords do not match"); return false }
        guard password.count >= 6 else { showAlert(title: "Weak Password", message: "At least 6 characters"); return false }
        guard phone.count >= 8, phone.allSatisfy({ $0.isNumber }) else {
            showAlert(title: "Invalid Phone", message: "Digits only, min 8")
            return false
        }
        return true
    }

    // MARK: - Firebase Auth
    func createNGOAccount(licenseUrl: String) {
        let email = emailTextField.text!
        let password = passwordTextField.text!

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.signupButton.isEnabled = true
                self.showAlert(title: "Registration Failed", message: error.localizedDescription)
                return
            }

            guard let uid = result?.user.uid else { return }
            self.saveNGO(uid: uid, licenseUrl: licenseUrl)
        }
    }

    // MARK: - Firestore
    func saveNGO(uid: String, licenseUrl: String) {
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .setData([
                "role": "3",
                "email": emailTextField.text ?? "",
                "username": usernameTextField.text ?? "",
                "organization_name": nameTextField.text ?? "",
                "phone_number": phoneNumberTextField.text ?? "",
                "address": addressTextField.text ?? "",
                "cause": causeTextField.text ?? "",
                "governorate": governorateTextField.text ?? "",
                "ngo_license_url": licenseUrl,
                "profile_completed": false,
                "created_at": Timestamp()
            ]) { [weak self] error in
                guard let self = self else { return }

                if let error = error {
                    self.signupButton.isEnabled = true
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }

                self.loadSessionAndRoute()
            }
    }

    // MARK: - Session + Routing
    func loadSessionAndRoute() {

        SessionManager.shared.fetchUserRole { success in
            DispatchQueue.main.async {
                if success {

                    let vc = UIStoryboard(
                        name: "Authentication",
                        bundle: nil
                    ).instantiateViewController(
                        withIdentifier: "SetupProfileViewController"
                    )

                    let nav = UINavigationController(rootViewController: vc)

                    if let sceneDelegate = UIApplication.shared.connectedScenes
                        .first?.delegate as? SceneDelegate {

                        sceneDelegate.window?.rootViewController = nav
                        sceneDelegate.window?.makeKeyAndVisible()
                    }

                } else {
                    self.signupButton.isEnabled = true
                    self.showAlert(
                        title: "Error",
                        message: "Unable to load user session."
                    )
                }
            }
        }
    }

    // MARK: - UI Helpers
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func styleActionButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
    }
}

import UIKit
import FirebaseAuth
import FirebaseFirestore

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

    override func viewDidLoad() {
        super.viewDidLoad()

        styleActionButton(uploadButton)
        styleActionButton(signupButton)

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

    @IBAction func goToLoginTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    // MARK: - Image Picker
    @IBAction func uploadLicenseTapped(_ sender: Any) {
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

    // MARK: - Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView.tag == 1 ? causes.count : governorates.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerView.tag == 1 ? causes[row] : governorates[row]
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

    // MARK: - Signup Flow
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard validateInputs() else { return }

        guard let licenseImage = licenseImageView.image else {
            showAlert(title: "Missing License", message: "Please upload NGO license.")
            return
        }

        signupButton.isEnabled = false

        CloudinaryService.shared.uploadImage(licenseImage) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let licenseUrl):
                self.createNGOAccount(licenseUrl: licenseUrl)

            case .failure(let error):
                self.signupButton.isEnabled = true
                self.showAlert(title: "Upload Failed", message: error.localizedDescription)
            }
        }
    }

    func validateInputs() -> Bool {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let confirm = confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let phone = phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !email.isEmpty else {
            showAlert(title: "Missing Email", message: "Please enter an email.")
            return false
        }

        guard !password.isEmpty else {
            showAlert(title: "Missing Password", message: "Please enter a password.")
            return false
        }

        guard password == confirm else {
            showAlert(title: "Password Mismatch", message: "Passwords do not match.")
            return false
        }

        guard password.count >= 6 else {
            showAlert(title: "Weak Password", message: "Password must be at least 6 characters.")
            return false
        }

        guard !phone.isEmpty else {
            showAlert(title: "Missing Phone Number", message: "Please enter your phone number.")
            return false
        }

        guard phone.allSatisfy({ $0.isNumber }) else {
            showAlert(title: "Invalid Phone Number", message: "Digits only.")
            return false
        }

        guard phone.count >= 8 else {
            showAlert(title: "Invalid Phone Number", message: "At least 8 digits.")
            return false
        }

        guard licenseImageView.image != nil else {
            showAlert(title: "Missing License", message: "Upload NGO license.")
            return false
        }

        return true
    }

    func createNGOAccount(licenseUrl: String) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.signupButton.isEnabled = true
                self.showAlert(title: "Registration Failed", message: error.localizedDescription)
                return
            }

            guard let uid = result?.user.uid else {
                self.signupButton.isEnabled = true
                return
            }

            self.saveNGOToFirestore(uid: uid, licenseUrl: licenseUrl)
        }
    }

    func saveNGOToFirestore(uid: String, licenseUrl: String) {
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
                    self.showAlert(title: "Registration Failed", message: error.localizedDescription)
                    return
                }

                SessionManager.shared.fetchUserRole { success in
                    DispatchQueue.main.async {
                        if success {
                            let vc = UIStoryboard(name: "Authentication", bundle: nil)
                                .instantiateViewController(withIdentifier: "SetupProfileViewController")
                                as! SetupProfileViewController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true)
                        } else {
                            self.signupButton.isEnabled = true
                            self.showAlert(title: "Error", message: "Session load failed.")
                        }
                    }
                }
            }
    }

    // MARK: - UI
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func styleActionButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
    }
}

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditProfileViewController: UIViewController {

    // MARK: - TextFields
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var causeField: UITextField!
    @IBOutlet weak var governorateField: UITextField!

    // MARK: - Labels (IMPORTANT)
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var causeLabel: UILabel!
    @IBOutlet weak var governorateLabel: UILabel!

    @IBOutlet weak var saveButton: UIButton!

    private let db = Firestore.firestore()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        styleActionButton(saveButton)
        fetchProfile()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureFieldsForRole()
    }

    // MARK: - Role-Based UI
    func configureFieldsForRole() {

        // Hide ALL optional fields + labels by default
        addressField.isHidden = true
        causeField.isHidden = true
        governorateField.isHidden = true

        addressLabel.isHidden = true
        causeLabel.isHidden = true
        governorateLabel.isHidden = true

        guard Auth.auth().currentUser != nil else { return }

        if SessionManager.shared.isDonor {
            addressField.isHidden = false
            addressLabel.isHidden = false
        }

        if SessionManager.shared.isNGO {
            addressField.isHidden = false
            causeField.isHidden = false
            governorateField.isHidden = false

            addressLabel.isHidden = false
            causeLabel.isHidden = false
            governorateLabel.isHidden = false
        }
    }

    // MARK: - Fetch Profile
    func fetchProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }

            DispatchQueue.main.async {
                self.nameField.text =
                    data["full_name"] as? String ??
                    data["organization_name"] as? String

                // 🔧 FIXED KEY
                self.phoneField.text = data["number"] as? String
                self.addressField.text = data["address"] as? String
                self.causeField.text = data["cause"] as? String
                self.governorateField.text = data["governorate"] as? String
            }
        }
    }

    // MARK: - Save
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        saveButton.isEnabled = false

        var updateData: [String: Any] = [
            // 🔧 MATCH FIRESTORE KEY
            "number": phoneField.text ?? ""
        ]

        if SessionManager.shared.isAdmin || SessionManager.shared.isDonor {
            updateData["full_name"] = nameField.text ?? ""
        }

        if SessionManager.shared.isDonor {
            updateData["address"] = addressField.text ?? ""
        }

        if SessionManager.shared.isNGO {
            updateData["organization_name"] = nameField.text ?? ""
            updateData["address"] = addressField.text ?? ""
            updateData["cause"] = causeField.text ?? ""
            updateData["governorate"] = governorateField.text ?? ""
        }

        db.collection("users").document(uid).updateData(updateData) { error in
            DispatchQueue.main.async {
                self.saveButton.isEnabled = true

                if let error = error {
                    self.showAlert("Error", error.localizedDescription)
                } else {
                    self.showAlert("Success", "Profile updated successfully")
                }
            }
        }
    }

    // MARK: - Alert
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Button Style
    private func styleActionButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
    }
}

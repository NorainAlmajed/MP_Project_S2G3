import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditProfileViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var causeField: UITextField!
    @IBOutlet weak var governorateField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    let db = Firestore.firestore()

    // TEMP — later replace with SessionManager
    enum UserRole {
        case admin
        case donor
        case ngo
    }

    var currentRole: UserRole = .donor

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        configureFieldsForRole()
        fetchProfile()
    }

    // MARK: - Role UI
    func configureFieldsForRole() {
        switch currentRole {
        case .admin:
            addressField.isHidden = true
            causeField.isHidden = true
            governorateField.isHidden = true

        case .donor:
            causeField.isHidden = true
            governorateField.isHidden = true

        case .ngo:
            // show all fields
            break
        }
    }

    // MARK: - Fetch Profile
    func fetchProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                self.nameField.text = data["organization_name"] as? String
                    ?? data["name"] as? String

                self.phoneField.text = data["phone_number"] as? String
                self.addressField.text = data["address"] as? String
                self.causeField.text = data["cause"] as? String
                self.governorateField.text = data["governorate"] as? String
            }
        }
    }

    // MARK: - Save Profile
    @IBAction func saveTapped(_ sender: UIButton) {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        var updateData: [String: Any] = [
            "phone_number": phoneField.text ?? ""
        ]

        switch currentRole {
        case .admin:
            updateData["name"] = nameField.text ?? ""

        case .donor:
            updateData["name"] = nameField.text ?? ""
            updateData["address"] = addressField.text ?? ""

        case .ngo:
            updateData["organization_name"] = nameField.text ?? ""
            updateData["address"] = addressField.text ?? ""
            updateData["cause"] = causeField.text ?? ""
            updateData["governorate"] = governorateField.text ?? ""
        }

        db.collection("users").document(uid).updateData(updateData) { error in
            if let error = error {
                self.showAlert("Error", error.localizedDescription)
            } else {
                self.showAlert("Success", "Profile updated successfully")
            }
        }
    }

    // MARK: - Alert
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

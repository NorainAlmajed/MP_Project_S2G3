import UIKit
import FirebaseAuth
import FirebaseFirestore

class UpdateNGOLicenseViewController: UIViewController,
                                     UIImagePickerControllerDelegate,
                                     UINavigationControllerDelegate {

    @IBOutlet weak var licenseImageView: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Update NGO License"
        uploadButton.isEnabled = false
    }

    // MARK: - Select Image
    @IBAction func selectLicenseTapped(_ sender: UIButton) {
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

        uploadButton.isEnabled = true
        dismiss(animated: true)
    }

    // MARK: - Upload & Update
    @IBAction func uploadLicenseTapped(_ sender: UIButton) {

        guard let image = licenseImageView.image else {
            showAlert("Missing Image", "Please select a license image")
            return
        }

        guard let uid = Auth.auth().currentUser?.uid else {
            showAlert("Error", "User not logged in")
            return
        }

        uploadButton.isEnabled = false

        CloudinaryService.shared.uploadImage(image) { result in
            switch result {
            case .success(let url):
                self.updateLicense(uid: uid, url: url)

            case .failure(let error):
                self.uploadButton.isEnabled = true
                self.showAlert("Upload Failed", error.localizedDescription)
            }
        }
    }

    // MARK: - Firestore Update
    func updateLicense(uid: String, url: String) {
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .updateData([
                "ngo_license_url": url,
                "license_status": "pending",
                "license_updated_at": Timestamp()
            ]) { error in
                if let error = error {
                    self.showAlert("Error", error.localizedDescription)
                    self.uploadButton.isEnabled = true
                } else {
                    self.showAlert(
                        "Success",
                        "License updated successfully. Pending review."
                    )
                    self.uploadButton.isEnabled = true
                }
            }
    }

    // MARK: - Alert Helper
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

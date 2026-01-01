import UIKit
import FirebaseFirestore
import FirebaseAuth

class UpdateNGOLicenseViewController: UIViewController,
                                     UIImagePickerControllerDelegate,
                                     UINavigationControllerDelegate {

    @IBOutlet weak var licenseImageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Update NGO License"

        styleActionButton(uploadButton)
        styleActionButton(saveButton)
        styleLicenseImageView()
        loadExistingLicense()
    }

    // MARK: - License Image Styling
    func styleLicenseImageView() {
        licenseImageView.layer.cornerRadius = 7
        licenseImageView.clipsToBounds = true
        licenseImageView.layer.borderWidth = 1
        licenseImageView.layer.borderColor = UIColor.systemGray.cgColor
        licenseImageView.contentMode = .scaleAspectFill
    }

    // MARK: - Load Existing License
    func loadExistingLicense() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument { [weak self] snapshot, _ in
                guard let data = snapshot?.data(),
                      let urlString = data["ngo_license_url"] as? String,
                      let url = URL(string: urlString) else { return }

                URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data,
                          let image = UIImage(data: data) else { return }

                    DispatchQueue.main.async {
                        self?.licenseImageView.image = image
                    }
                }.resume()
            }
    }

    // MARK: - Pick New License
    @IBAction func uploadTapped(_ sender: UIButton) {
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
            licenseImageView.image = image
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    // MARK: - Save Updated License
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let image = licenseImageView.image else {
            showAlert(title: "Missing License", message: "Please upload a license image.")
            return
        }

        saveButton.isEnabled = false

        let cloudinaryService = CloudinaryService()
        cloudinaryService.uploadImage(image) { [weak self] url in
            guard let self = self,
                  let licenseUrl = url,
                  let uid = Auth.auth().currentUser?.uid else {
                self?.saveButton.isEnabled = true
                return
            }

            Firestore.firestore()
                .collection("users")
                .document(uid)
                .updateData([
                    "ngo_license_url": licenseUrl,
                    "status": NGOStatus.pending.rawValue
                ]) { error in
                    self.saveButton.isEnabled = true

                    if let error = error {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        self.showAlert(
                            title: "Submitted",
                            message: "Your updated license has been sent for review."
                        )
                    }
                }
        }
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

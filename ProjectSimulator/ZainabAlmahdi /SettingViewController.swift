import UIKit

class SettingViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!

    // MARK: - Rows
    enum SettingsRow {
        case editProfile
        case security
        case savedAddresses
        case notifications
        case updateNGOLicense
    }

    var rows: [SettingsRow] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        styleProfileImageView()
        configureRows()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameLabel.text = SessionManager.shared.fullName ?? "User"
        roleLabel.text = SessionManager.shared.roleDisplayName

        loadProfileImage()
        configureRows()
        tableView.reloadData()
    }

    // MARK: - Profile Image Styling (MATCHES TEAMMATE)
    func styleProfileImageView() {
        profileImageView.layer.cornerRadius = 7
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.systemGray.cgColor
        profileImageView.contentMode = .scaleAspectFill

        // Placeholder
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .systemGray3
    }

    // MARK: - Load Profile Image
    func loadProfileImage() {
        guard let urlString = SessionManager.shared.profileImageURL,
              !urlString.isEmpty,
              let url = URL(string: urlString) else {
            return
        }

        // Placeholder while loading
        profileImageView.image = UIImage(systemName: "person.circle.fill")

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data,
                  let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self?.profileImageView.image = image
            }
        }.resume()
    }

    // MARK: - Configure Rows
    func configureRows() {
        rows = [.editProfile, .security]

        if SessionManager.shared.isDonor || SessionManager.shared.isNGO {
            rows.append(.savedAddresses)
            rows.append(.notifications)
        }

        if SessionManager.shared.isAdmin {
            rows.append(.notifications)
        }

        if SessionManager.shared.isNGO {
            rows.append(.updateNGOLicense)
        }
    }

    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SettingsCell",
            for: indexPath
        )

        cell.textLabel?.textColor = .label
        cell.accessoryType = .disclosureIndicator

        switch rows[indexPath.row] {
        case .editProfile:
            cell.textLabel?.text = "Edit Profile"

        case .security:
            cell.textLabel?.text = "Security Settings"

        case .savedAddresses:
            cell.textLabel?.text = "Saved Addresses"

        case .notifications:
            cell.textLabel?.text = "Notification Settings"

        case .updateNGOLicense:
            cell.textLabel?.text = "Update NGO License"
        }

        return cell
    }

    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        switch rows[indexPath.row] {
        case .editProfile:
            goToEditProfile()

        case .security:
            goToSecurity()

        case .savedAddresses:
            goToSavedAddresses()

        case .notifications:
            goToNotifications()

        case .updateNGOLicense:
            goToUpdateNGOLicense()
        }
    }

    // MARK: - Navigation
    func goToEditProfile() {
        let vc = UIStoryboard(name: "Settings", bundle: nil)
            .instantiateViewController(withIdentifier: "EditProfileViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    func goToSecurity() {
        let vc = UIStoryboard(name: "Settings", bundle: nil)
            .instantiateViewController(withIdentifier: "SecuritySettingsViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    func goToSavedAddresses() {
        let vc = UIStoryboard(name: "Settings", bundle: nil)
            .instantiateViewController(withIdentifier: "SavedAddressesViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    func goToNotifications() {
        let vc = UIStoryboard(name: "Settings", bundle: nil)
            .instantiateViewController(withIdentifier: "NotificationSettingsViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    func goToUpdateNGOLicense() {
        let vc = UIStoryboard(name: "Settings", bundle: nil)
            .instantiateViewController(withIdentifier: "UpdateNGOLicenseViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
}

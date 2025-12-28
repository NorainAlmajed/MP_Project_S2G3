import UIKit

class SettingViewController: UITableViewController {

    enum UserRole {
        case admin
        case donor
        case ngo
    }
    
    var currentRole: UserRole = .ngo
    
    enum SettingsRow {
        case editProfile
        case security
        case savedAddresses
        case notifications
        case updateNGOLicense
    }

    var rows: [SettingsRow] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        configureRows()
    }

    func configureRows() {
        rows = [.editProfile, .security]

        switch currentRole {
        case .admin:
            rows.append(.notifications)

        case .donor:
            rows.append(.savedAddresses)
            rows.append(.notifications)

        case .ngo:
            rows.append(.savedAddresses)
            rows.append(.notifications)
            rows.append(.updateNGOLicense)
        }
    }

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

//
//  AccViewController.swift
//  ProjectSimulator
//

import UIKit
import FirebaseAuth

class AccViewController: UITableViewController {

    // MARK: - Roles
    enum UserRole {
        case admin
        case ngo
        case donor
    }

    var currentRole: UserRole = .admin

    // MARK: - Rows
    enum AccountRow {
        case settings
        case createDonor
        case createNGO
        case contactSupport
        case terms
        case logout
    }

    var rows: [AccountRow] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"
        configureRows()
    }

    // MARK: - Configure Rows
    func configureRows() {
        rows = [.settings]

        switch currentRole {
        case .admin:
            rows.append(.createDonor)
            rows.append(.createNGO)

        case .donor, .ngo:
            rows.append(.contactSupport)
        }

        rows.append(.terms)
        rows.append(.logout)
    }

    // MARK: - Table Data Source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "AccountCell",
            for: indexPath
        )

        cell.textLabel?.textColor = .label
        cell.accessoryType = .disclosureIndicator

        switch rows[indexPath.row] {
        case .settings:
            cell.textLabel?.text = "Settings"

        case .createDonor:
            cell.textLabel?.text = "Create Donor Account"

        case .createNGO:
            cell.textLabel?.text = "Create NGO Account"

        case .contactSupport:
            cell.textLabel?.text = "Contact Support"

        case .terms:
            cell.textLabel?.text = "Terms and Conditions"

        case .logout:
            cell.textLabel?.text = "Logout"
            cell.textLabel?.textColor = .systemRed
            cell.accessoryType = .none
        }

        return cell
    }

    // MARK: - Handle Taps
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        switch rows[indexPath.row] {
        case .settings:
            goToSettings()

        case .createDonor:
            goToCreateDonor()

        case .createNGO:
            goToCreateNGO()

        case .contactSupport:
            goToContactSupport()

        case .terms:
            goToTerms()

        case .logout:
            logoutUser()
        }
    }

    // MARK: - Navigation Helpers
    func goToSettings() {
        let vc = UIStoryboard(name: "Settings", bundle: nil)
            .instantiateViewController(withIdentifier: "SettingViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    func goToCreateDonor() {
        let vc = UIStoryboard(name: "Authentication", bundle: nil)
            .instantiateViewController(withIdentifier: "DonorSignupViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    func goToCreateNGO() {
        let vc = UIStoryboard(name: "Authentication", bundle: nil)
            .instantiateViewController(withIdentifier: "NGOSignupViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    func goToContactSupport() {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "ContactSupportViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    func goToTerms() {
        let vc = UIStoryboard(name: "Authentication", bundle: nil)
            .instantiateViewController(withIdentifier: "TermsViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    func logoutUser() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
            do {
                try Auth.auth().signOut()
                self.navigationController?.popToRootViewController(animated: true)
            } catch {
                self.showLogoutError()
            }
        })

        present(alert, animated: true)
    }

    func showLogoutError() {
        let alert = UIAlertController(
            title: "Error",
            message: "Could not log out. Please try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

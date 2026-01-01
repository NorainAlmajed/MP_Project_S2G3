//
//  AccViewController.swift
//  ProjectSimulator
//

import UIKit
import FirebaseAuth

class AccViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var roleLabel: UILabel!
    
    enum AccountRow {
        case settings
        case createDonor
        case createNGO
        case contactSupport
        case logout
    }

    var rows: [AccountRow] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"
        configureRows()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        SessionManager.shared.loadUserSession { [weak self] success in
            guard success else { return }

            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }
    
    func updateUI() {
        nameLabel.text = SessionManager.shared.fullName ?? "User"
        roleLabel.text = SessionManager.shared.roleDisplayName

        configureRows()
        tableView.reloadData()

        loadProfileImage()
    }
    
    func loadProfileImage() {
        guard let urlString = SessionManager.shared.profileImageURL,
              let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self?.profileImageView.image = UIImage(data: data)
            }
        }.resume()
    }

    
    func configureRows() {
        rows = [.settings]

        if SessionManager.shared.isAdmin {
            rows.append(.createDonor)
            rows.append(.createNGO)
        }

        if SessionManager.shared.isDonor || SessionManager.shared.isNGO {
            rows.append(.contactSupport)
        }
        rows.append(.logout)
    }

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


        case .logout:
            cell.textLabel?.text = "Logout"
            cell.textLabel?.textColor = .systemRed
            cell.accessoryType = .none
        }

        return cell
    }

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
            
        case .logout:
            logoutUser()
        }
    }
    
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
                SessionManager.shared.clear()

                let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
                let loginVC = storyboard.instantiateInitialViewController()

                if let sceneDelegate = UIApplication.shared.connectedScenes
                    .first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = loginVC
                    sceneDelegate.window?.makeKeyAndVisible()
                }

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

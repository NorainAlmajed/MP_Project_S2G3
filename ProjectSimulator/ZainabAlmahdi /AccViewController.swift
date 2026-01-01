//
//  AccViewController.swift
//  ProjectSimulator
//

import UIKit
import FirebaseAuth

class AccViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!

    // MARK: - Rows
    enum AccountRow {
        case settings
        case createDonor
        case createNGO
        case contactSupport
        case logout
    }

    var rows: [AccountRow] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"
        styleProfileImageView()
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

    // MARK: - UI Update
    func updateUI() {
        nameLabel.text = SessionManager.shared.fullName ?? "User"
        roleLabel.text = SessionManager.shared.roleDisplayName

        configureRows()
        tableView.reloadData()

        loadProfileImage()
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

    // MARK: - Rows Config
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

    // MARK: - TableView DataSource
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

    // MARK: - TableView Delegate
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

    // MARK: - Navigation
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
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)

        guard let chatVC = storyboard.instantiateViewController(
            withIdentifier: "ChatListViewController"
        ) as? ChatListViewController else {
            print("ChatListViewController not found")
            return
        }

        navigationController?.pushViewController(chatVC, animated: true)
    }

    // MARK: - Logout
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

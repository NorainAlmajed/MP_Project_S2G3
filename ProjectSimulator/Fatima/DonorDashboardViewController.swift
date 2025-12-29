import UIKit
import FirebaseAuth
import FirebaseFirestore

// MARK: - Impact Model
struct ImpactData {
    let totalDonations: Int
    let mealsProvided: Int
    let livesImpacted: Int
}
// Shared dashboard for Admin / Donor / NGO


class DonorDashboardViewController: UIViewController {

    // MARK: - Roles
    enum UserRole: Int {
        case admin = 1
        case donor = 2
        case ngo = 3
    }

    // MARK: - Sections
    enum DashboardSection {
        case welcome
        case quickActions
        case impactTracker
        case graph
        case browseNGOs
        case recentDonations
        case allDonations
        case pendingDonations
        case manageUsers
    }

    // MARK: - State
    // we set the current user to donor because its the safest state and most common & to avoid crashing
    private var currentRole: UserRole = .donor
    private var sections: [DashboardSection] = []
    // for admin & ngo shared usage
    private var roleBasedDonations: [Donation1] = []

    private var currentUserName: String = "there"
    private var currentUserID: String?

    private let db = Firestore.firestore()

    private var ngosFromFirestore: [FatimaNGO] = []
    // for donor
    private var recentDonations: [Donation1] = []
    // for thr admin
    private var allDonations: [Donation1] = []

    private var ngosListener: ListenerRegistration?
    private var donationsListener: ListenerRegistration?

    @IBOutlet weak var mainTableView: UITableView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none

        setupEllipsisMenu()
        loadCurrentUser()
        startListeningForNGOs()
    }

    // MARK: - Configure sections by role
    private func configureSections(for role: UserRole) {
        switch role {

        case .donor:
            sections = [
                .welcome,
                .quickActions,
                .impactTracker,
                .graph,
                .browseNGOs,
                .recentDonations
            ]

        case .ngo:
            sections = [
                .welcome,
                .quickActions,
                .impactTracker,
                .pendingDonations
            ]

        case .admin:
            sections = [
                .welcome,
                .quickActions,
                .impactTracker,
                .allDonations,
                .manageUsers,
                .browseNGOs
            ]
        }
    }
    @objc private func browseNGOsTapped() {
        goToBrowseNGOs()
    }

    // MARK: - User
    private func loadCurrentUser() {
        guard let user = Auth.auth().currentUser else { return }

        currentUserID = user.uid

        // Fetch role
        db.collection("users").document(user.uid).getDocument { [weak self] snapshot, _ in
            guard
                let self = self,
                let data = snapshot?.data(),
                let roleInt = data["role"] as? Int,
                let role = UserRole(rawValue: roleInt)
            else { return }

            self.currentRole = role
            self.configureSections(for: role)
            // added this for fetching donations based on role, just a test
            self.startListeningForDonationsByRole()

            self.mainTableView.reloadData()
        }

        // Name
        if let name = user.displayName, !name.isEmpty {
            currentUserName = name
        } else if let email = user.email {
            currentUserName = email.components(separatedBy: "@").first?.capitalized ?? "there"
        }

        //startListeningForRecentDonations()
        //startListeningForImpactDonations()
    }
    private func startListeningForDonationsByRole() {

        donationsListener?.remove()

        switch currentRole {

        case .donor:
            startListeningForRecentDonations()

        case .admin:
            startListeningForAdminDonations()

        case .ngo:
            startListeningForPendingDonations()
        }
    }
    private func startListeningForAdminDonations() {

        donationsListener = db.collection("Donation")
            .order(by: "creationDate", descending: true)
            .limit(to: 3)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let self = self else { return }

                self.roleBasedDonations =
                    snapshot?.documents.compactMap { Donation1(document: $0) } ?? []

                self.mainTableView.reloadData()
            }
    }
    private func startListeningForPendingDonations() {
        guard let uid = currentUserID else { return }

        let ngoRef = db.collection("users").document(uid)

        donationsListener = db.collection("Donation")
            .whereField("ngo", isEqualTo: ngoRef)   // 🔑 THIS WAS MISSING
            .whereField("status", isEqualTo: 1)     // Pending
            .order(by: "creationDate", descending: true)
            .limit(to: 3)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ NGO donation error:", error)
                    return
                }

                self.roleBasedDonations =
                    snapshot?.documents.compactMap { Donation1(document: $0) } ?? []

                print("🧪 NGO pending donations:", self.roleBasedDonations.count)

                self.mainTableView.reloadData()
            }
    }

    private func goToBrowseNGOs() {
        let storyboard = UIStoryboard(name: "Raghad1", bundle: nil)

        guard let ngoVC = storyboard.instantiateViewController(
            withIdentifier: "NgoViewController"
        ) as? NgoViewController else {
            fatalError("❌ NgoViewController not found in Raghad1.storyboard")
        }

        navigationController?.pushViewController(ngoVC, animated: true)
    }

    // MARK: - Firestore listeners
    private func startListeningForNGOs() {
        ngosListener?.remove()

        ngosListener = db.collection("users")
            .whereField("role", isEqualTo: 3)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let self = self else { return }
                self.ngosFromFirestore = snapshot?.documents.compactMap { FatimaNGO(document: $0) } ?? []
                self.mainTableView.reloadData()
            }
    }

    private func startListeningForRecentDonations() {
        guard let uid = currentUserID else { return }

        let userRef = db.collection("users").document(uid)

        donationsListener = db.collection("Donation")
            .whereField("donor", isEqualTo: userRef)
            .limit(to: 5)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let self = self else { return }
                self.recentDonations = snapshot?.documents.compactMap { Donation1(document: $0) } ?? []
                self.mainTableView.reloadData()
            }
    }

    private func startListeningForImpactDonations() {
        guard let uid = currentUserID else { return }

        let userRef = db.collection("users").document(uid)

        db.collection("Donation")
            .whereField("donor", isEqualTo: userRef)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let self = self else { return }
                self.allDonations = snapshot?.documents.compactMap { Donation1(document: $0) } ?? []
                self.mainTableView.reloadData()
            }
    }

    // MARK: - Impact Logic
    private var impactData: ImpactData {
        let valid = allDonations.filter { $0.status == 2 || $0.status == 3 }
        let meals = valid.reduce(0) { $0 + $1.quantity }
        return ImpactData(
            totalDonations: valid.count,
            mealsProvided: meals,
            livesImpacted: meals / 3
        )
    }

    // MARK: - Menu and ellipses
    private func setupEllipsisMenu() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            menu: UIMenu(children: [
                UIAction(title: "Notifications", image: UIImage(systemName: "bell")) { _ in },
                UIAction(title: "Chat", image: UIImage(systemName: "message")) { _ in }
            ])
        )
    }
}

// MARK: - TableView
extension DonorDashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int { 1 }
    
    // MARK: To make the size responsive on iPads and iPhone
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let isPad = traitCollection.userInterfaceIdiom == .pad
        let section = sections[indexPath.section]
        
        switch section {
        case .welcome: return isPad ? 120 : 80
        case .quickActions: return isPad ? 110 : 80
        case .impactTracker: return isPad ? 180 : 140
        case .graph: return isPad ? 260 : 200
        case .browseNGOs: return isPad ? 280 : 220
        case .recentDonations,
                .allDonations,
                .pendingDonations,
                .manageUsers:
            return isPad ? 400 : 300
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = sections[indexPath.section]
        
        switch section {
            // MARK: Welcome msg
        case .welcome:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            
            let label = UILabel()
            label.font = .boldSystemFont(ofSize: 20)
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            // diso
            switch currentRole {
            case .admin:
                label.text = "Welcome back, Nourish Bahrain Admin!"
            case .donor:
                label.text = "Hi \(currentUserName), thank you for your generosity!"
            case .ngo:
                let name = currentUserName.trimmingCharacters(in: .whitespacesAndNewlines)

                if name.isEmpty || name.lowercased().hasPrefix("contact") {
                    label.text = "Welcome back, our partner NGO"
                } else {
                    label.text = "Welcome back, \(name)"
                }

            }
            
            cell.contentView.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 16),
                label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -16)
            ])
            
            return cell
            // MARK: quick actions
        case .quickActions:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "QuickActionsCell",
                for: indexPath
            )
            cell.selectionStyle = .none

            // Find buttons by tag
            let firstButton = cell.contentView.viewWithTag(1) as? UIButton
            let secondButton = cell.contentView.viewWithTag(2) as? UIButton

            switch currentRole {

            case .donor:
                firstButton?.setTitle("View Donations", for: .normal)
                secondButton?.setTitle("Browse NGOs", for: .normal)

                secondButton?.addTarget(
                    self,
                    action: #selector(browseNGOsTapped),
                    for: .touchUpInside
                )

            case .ngo:
                firstButton?.setTitle("Manage Donations", for: .normal)
                secondButton?.setTitle("Manage Profile", for: .normal)

            case .admin:
                firstButton?.setTitle("Manage Users", for: .normal)
                secondButton?.setTitle("Manage Donations", for: .normal)
            }

            return cell
// MARK: impact tracker
        case .impactTracker:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImpactTrackerCell", for: indexPath) as! ImpactTrackerTableViewCell
            cell.configure(
                totalDonations: impactData.totalDonations,
                mealsProvided: impactData.mealsProvided,
                livesImpacted: impactData.livesImpacted
            )
            cell.selectionStyle = .none
            return cell
            // MARK: GRAPH
        case .graph:
            // Placeholder (keep section, don’t remove)
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = .systemGray6
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = "📊 Graph (Placeholder)"
            return cell
          // MARK: browse ngo
        case .browseNGOs:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedNGOsCell", for: indexPath) as! RecommendedNGOsTableViewCell
            cell.configure(with: ngosFromFirestore)
            cell.onSeeAllTapped = { [weak self] in
                self?.goToBrowseNGOs()
            }
            cell.onNGOSelected = { ngo in print("Open NGO page: \(ngo.organizationName)") }
            cell.selectionStyle = .none
            return cell
            // MARK: donations section
        case .recentDonations:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "RecentDonationsCell",
                for: indexPath
            ) as! RecentDonationTableViewCell

            cell.headerView.text = "Recent Donations"
            cell.configure(with: recentDonations)
            return cell

        case .allDonations:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "RecentDonationsCell",
                for: indexPath
            ) as! RecentDonationTableViewCell

            cell.headerView.text = "Latest Donations"
            cell.configure(with: roleBasedDonations)
            return cell

            
        case .pendingDonations:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "RecentDonationsCell",
                for: indexPath
            ) as! RecentDonationTableViewCell

            cell.headerView.text = "Pending Donations"
            cell.configure(with: roleBasedDonations)
            return cell

            
        case .manageUsers:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = "👥 Manage Users (Admin) - Placeholder"
            return cell
        }
    }
}

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
    // 🔥 FULL DATASETS FOR IMPACT
    private var allPlatformDonations: [Donation1] = [] // admin
    private var allNGODonations: [Donation1] = []       // ngo
    private var approvedNGOsCount: Int = 0
    private var approvedDonorsCount: Int = 0


    @objc private func browseNgoTapped() {
        goToBrowseNGOs()
    }
    @objc private func dismissManageUsers() {
        dismiss(animated: true)
    }
    // MARK: manage user tapped func
    @objc private func manageUsersTapped() {
        let storyboard = UIStoryboard(name: "norain-admin-controls1", bundle: nil)

        guard let usersVC = storyboard.instantiateViewController(
            withIdentifier: "NourishUsersViewController"
        ) as? NourishUsersViewController else {
            print("❌ NourishUsersViewController not found")
            return
        }

        usersVC.modalPresentationStyle = .fullScreen

        // ✅ Create chevron button
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(dismissManageUsers), for: .touchUpInside)

        // ✅ Wrap in UIBarButtonItem
        let barButton = UIBarButtonItem(customView: backButton)

        // ✅ IMPORTANT: set it on HER nav bar outlet
        usersVC.loadViewIfNeeded() // ensures outlets are connected
        usersVC.NavBar.leftBarButtonItem = barButton

        present(usersVC, animated: true)
    }


// MARK: Donor impact math
    private func donorImpactStats() -> [ImpactStat] {

        let valid = allDonations.filter { $0.status == 2 || $0.status == 3 }

        let meals = valid.reduce(0) { $0 + $1.quantity }
        let lives = meals / 3

        return [
            ImpactStat(title: "Total Donations", value: valid.count),
            ImpactStat(title: "Meals Served", value: meals),
            ImpactStat(title: "Lives Saved", value: lives)
        ]
    }

// MARK: NGO impact math
    private func ngoImpactStats() -> [ImpactStat] {

        let valid = allNGODonations.filter { $0.status == 2 || $0.status == 3 }

        let meals = valid.reduce(0) { $0 + $1.quantity }
        let beneficiaries = meals / 3

        let wastePreventedKG = valid.reduce(0) { $0 + $1.weight } // REAL

        let today = Date()
        let calendar = Calendar.current

        let todayCount = valid.filter {
            calendar.isDate($0.creationDate, inSameDayAs: today)
        }.count

        let monthlyCount = valid.filter {
            calendar.isDate($0.creationDate, equalTo: today, toGranularity: .month)
        }.count

        return [
            ImpactStat(title: "Donations Received", value: valid.count),
            ImpactStat(title: "Waste Prevented (KG)", value: wastePreventedKG),
            ImpactStat(title: "Total Beneficiaries", value: beneficiaries),
            ImpactStat(title: "Meals Provided", value: meals),
            ImpactStat(title: "Today’s Stats", value: todayCount),
            ImpactStat(title: "Monthly Stats", value: monthlyCount)
        ]
    }

// MARK: admin impact

    private func adminImpactStats() -> [ImpactStat] {

        let valid = allPlatformDonations.filter { $0.status == 2 || $0.status == 3 }

        let meals = valid.reduce(0) { $0 + $1.quantity }
        let wasteKG = valid.reduce(0) { $0 + $1.weight }

        let totalDonors = approvedDonorsCount
        let totalApprovedNGOs = approvedNGOsCount


        return [
            ImpactStat(title: "Total Donations", value: valid.count),
            ImpactStat(title: "Total Donors", value: totalDonors),
            ImpactStat(title: "Total NGOs", value: totalApprovedNGOs),
            ImpactStat(title: "Meals Provided", value: meals),
            ImpactStat(title: "Beneficiaries Served", value: meals / 3),
            ImpactStat(title: "Waste Prevented (KG)", value: wasteKG)
        ]
    }


    @objc private func openChatsTapped() {
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)

        guard let chatListVC = storyboard.instantiateViewController(
            withIdentifier: "ChatListViewController"
        ) as? ChatListViewController else {
            print("❌ ChatListViewController not found in Chats storyboard")
            return
        }
        chatListVC.hidesBottomBarWhenPushed = true

        navigationController?.pushViewController(chatListVC, animated: true)
    }

    @objc private func manageDonationsTapped() {
        let storyboard = UIStoryboard(name: "Donations", bundle: nil)

        guard let vc = storyboard.instantiateViewController(
            withIdentifier: "DonationViewController"
        ) as? DonationViewController else {
            print("❌ DonationViewController not found")
            return
        }

        navigationController?.pushViewController(vc, animated: true)
    }

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
        // 🔙 Back chevron only (no "Home" text)
            navigationItem.backButtonTitle = ""

            // 🎨 Black chevron color
        navigationController?.navigationBar.tintColor = .label
        setupEllipsisMenu()
        loadCurrentUser()
        startListeningForNGOs()
        mainTableView.allowsSelection = false
        mainTableView.allowsMultipleSelection = false
        

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
                .graph,
                .pendingDonations
            ]

        case .admin:
            sections = [
                .welcome,
                .quickActions,
                .impactTracker,
                .graph,     
                .allDonations,
                .browseNGOs,
                .manageUsers
            ]
        }
    }


    // MARK: - User
    private func loadCurrentUser() {
        guard let user = Auth.auth().currentUser else { return }

        currentUserID = user.uid
        // Fetch role + name correctly
        db.collection("users").document(user.uid).getDocument { [weak self] snapshot, _ in
            guard
                let self = self,
                let data = snapshot?.data(),
                let roleInt = data["role"] as? Int,
                let role = UserRole(rawValue: roleInt)
            else { return }

            self.currentRole = role
            self.configureSections(for: role)

            // ✅ NAME LOGIC (IMPORTANT PART)
            switch role {

            case .ngo:
                // Always use NGO full name
                if let fullName = data["full_name"] as? String, !fullName.isEmpty {
                    self.currentUserName = fullName
                } else if let orgName = data["organization_name"] as? String {
                    self.currentUserName = orgName
                } else {
                    self.currentUserName = "Our Partner NGO"
                }

            case .donor:
                // Donor name
                if let fullName = data["full_name"] as? String, !fullName.isEmpty {
                    self.currentUserName = fullName
                } else if let username = data["username"] as? String {
                    self.currentUserName = username
                } else if let email = user.email {
                    self.currentUserName = email.components(separatedBy: "@").first?.capitalized ?? "there"
                }

            case .admin:
                self.currentUserName = "Nourish Bahrain Admin"
            }

            // Start listeners
            self.startListeningForDonationsByRole()

            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
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
            startListeningForApprovedNGOsCount()
            startListeningForApprovedDonorsCount()



        case .ngo:
            startListeningForPendingDonations()
            startListeningForNGOImpact()

        }
    }
    // MARK: start listning for admin donations
    private func startListeningForAdminDonations() {
        donationsListener?.remove()

        donationsListener = db.collection("Donation")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ Admin listener error:", error)
                    return
                }

                let all = snapshot?.documents.compactMap {
                    Donation1(document: $0)
                } ?? []

                // 🔥 FULL DATASET FOR IMPACT
                self.allPlatformDonations = all

                // 🔥 ONLY LAST 3 FOR UI
                let sorted = all.sorted { $0.creationDate > $1.creationDate }
                self.roleBasedDonations = Array(sorted.prefix(3))

                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
            }
    }
    private func startListeningForNGOImpact() {
        guard let uid = currentUserID else { return }

        let ngoRef = db.collection("users").document(uid)

        db.collection("Donation")
            .whereField("ngo", isEqualTo: ngoRef)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ NGO impact listener error:", error)
                    return
                }

                self.allNGODonations = snapshot?.documents.compactMap {
                    Donation1(document: $0)
                } ?? []

                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
            }
    }

    private func startListeningForApprovedDonorsCount() {

        db.collection("users")
            .whereField("role", isEqualTo: 2)          // donors
            // .whereField("status", isEqualTo: "Approved") // only if you use status for donors
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ Approved donors listener error:", error)
                    return
                }

                self.approvedDonorsCount = snapshot?.documents.count ?? 0

                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
            }
    }


    private func clearCellSelection(_ cell: UITableViewCell) {
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.selectedBackgroundView = UIView() // 🔥 kills gray overlay
    }
// MARK: start listning for pending donations
    private func startListeningForPendingDonations() {
        guard let uid = currentUserID else { return }

        let ngoRef = db.collection("users").document(uid)
        donationsListener?.remove()

        donationsListener = db.collection("Donation")
            .whereField("ngo", isEqualTo: ngoRef)
            .whereField("status", isEqualTo: 1) // ✅ PENDING ONLY
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ NGO listener error:", error)
                    return
                }

                let pending = snapshot?.documents.compactMap {
                    Donation1(document: $0)
                } ?? []

                let sorted = pending.sorted {
                    $0.creationDate > $1.creationDate
                }

                // ✅ LAST 3 PENDING ONLY
                self.roleBasedDonations = Array(sorted.prefix(3))

                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
            }
    }




    private func startListeningForApprovedNGOsCount() {

        db.collection("users")
            .whereField("role", isEqualTo: 3)
            .whereField("status", isEqualTo: "Approved")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ Approved NGOs listener error:", error)
                    return
                }

                self.approvedNGOsCount = snapshot?.documents.count ?? 0

                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
            }
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
// MARK: start listning for recent donations
    private func startListeningForRecentDonations() {
        guard let uid = currentUserID else { return }

        let userRef = db.collection("users").document(uid)
        donationsListener?.remove()

        donationsListener = db.collection("Donation")
            .whereField("donor", isEqualTo: userRef)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ Donor listener error:", error)
                    return
                }

                let all = snapshot?.documents.compactMap {
                    Donation1(document: $0)
                } ?? []

                // 🔥 SORT BY CREATION DATE (NEWEST FIRST)
                let sorted = all.sorted {
                    $0.creationDate > $1.creationDate
                }

                // 🔥 ALWAYS TAKE LAST 3 — NO FILTERS
                self.recentDonations = Array(sorted.prefix(3))
                self.allDonations = sorted

                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
            }
    }


// MARK: start listning for impact donations

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

                // 🔔 Notifications
                UIAction(
                    title: "Notifications",
                    image: UIImage(systemName: "bell")
                ) { [weak self] _ in
                    self?.openNotifications()
                },

                // 💬 Chat
                UIAction(
                    title: "Chat",
                    image: UIImage(systemName: "message")
                ) { [weak self] _ in
                    self?.openChatsTapped()
                }
            ])
        )
    }
    // MARK: - Notifications Navigation
    private func openNotifications() {
        let storyboard = UIStoryboard(name: "Donations", bundle: nil)

        guard let notificationsVC = storyboard.instantiateViewController(
            withIdentifier: "NotificationsViewController"
        ) as? NotificationsViewController else {
            print("❌ NotificationsViewController not found in Donations storyboard")
            return
        }

        navigationController?.pushViewController(notificationsVC, animated: true)
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
        // MARK: Height Section
        switch section {
        case .welcome: return isPad ? 120 : 90
        case .quickActions: return isPad ? 110 : 100
        case .impactTracker:
            switch currentRole {
            case .donor: return isPad ? 140 : 140
            case .ngo:   return isPad ? 320 : 280
            case .admin: return isPad ? 320 : 280
            }

        case .graph: return isPad ? 260 : 350
        case .browseNGOs: return isPad ? 280 : 220
        case .recentDonations,
             .allDonations,
             .pendingDonations:

            let count: Int
            switch section {
            case .recentDonations:
                count = recentDonations.prefix(3).count
            case .allDonations, .pendingDonations:
                count = roleBasedDonations.prefix(3).count
            default:
                count = 0
            }

            let cardHeight: CGFloat = 120
            let spacing: CGFloat = 12
            let header: CGFloat = 50
            let topSpacing: CGFloat = 8
            let padding: CGFloat = 24

            return header
                 + topSpacing
                 + CGFloat(count) * cardHeight
                 + CGFloat(max(0, count - 1)) * spacing
                 + padding
        case .manageUsers:
            return isPad ? 700 : 520

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
            label.font = .boldSystemFont(ofSize: 19)
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false

            switch currentRole {
            case .admin:
                label.text = "Welcome back, Nourish Bahrain Admin!"

            case .donor:
                label.text = "Hi \(currentUserName), thank you for your generosity!"

            case .ngo:
                label.text = "Welcome back, \(currentUserName)"
            }

            cell.contentView.addSubview(label)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 16),
                label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -16)
            ])

            
            return cell
            // MARK: - Quick Actions
            case .quickActions:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "QuickActionsCell",
                    for: indexPath
                )
                cell.selectionStyle = .none

                guard
                    let firstButton = cell.contentView.viewWithTag(1) as? UIButton,
                    let secondButton = cell.contentView.viewWithTag(2) as? UIButton
                else {
                    return cell
                }

                // 🔁 Clear old actions
                firstButton.removeTarget(nil, action: nil, for: .allEvents)
                secondButton.removeTarget(nil, action: nil, for: .allEvents)

                // 🎨 STYLE (shared for all roles)
                styleQuickActionButton(firstButton)
                styleQuickActionButton(secondButton)

                // 🧠 ROLE-BASED LOGIC (UNCHANGED)
                switch currentRole {

                case .donor:
                    firstButton.setTitle("View Donations", for: .normal)
                    secondButton.setTitle("Browse NGOs", for: .normal)

                    firstButton.addTarget(
                        self,
                        action: #selector(manageDonationsTapped),
                        for: .touchUpInside
                    )

                    secondButton.addTarget(
                        self,
                        action: #selector(browseNgoTapped),
                        for: .touchUpInside
                    )

                case .ngo:
                    firstButton.setTitle("Manage Donations", for: .normal)
                    secondButton.setTitle("Manage Profile", for: .normal)

                    firstButton.addTarget(
                        self,
                        action: #selector(manageDonationsTapped),
                        for: .touchUpInside
                    )

                case .admin:
                    firstButton.setTitle("Manage Users", for: .normal)
                    secondButton.setTitle("Manage Donations", for: .normal)

                    firstButton.addTarget(
                        self,
                        action: #selector(manageUsersTapped),
                        for: .touchUpInside
                    )

                    secondButton.addTarget(
                        self,
                        action: #selector(manageDonationsTapped),
                        for: .touchUpInside
                    )
                }

                return cell



            
// MARK: impact tracker
        case .impactTracker:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ImpactTrackerCell",
                for: indexPath
            ) as! ImpactTrackerTableViewCell

            let stats: [ImpactStat]

            switch currentRole {
            case .donor:
                stats = donorImpactStats()
            case .ngo:
                stats = ngoImpactStats()
            case .admin:
                stats = adminImpactStats()
            }

            cell.configure(role: currentRole, stats: stats)
            cell.selectionStyle = .none
            return cell

            // MARK: GRAPH
        case .graph:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ImpactGraphCell",
                for: indexPath
            ) as! ImpactGraphTableViewCell

            switch currentRole {
            case .donor:
                cell.configure(with: allDonations)
            case .ngo:
                cell.configure(with: allNGODonations)
            case .admin:
                cell.configure(with: allPlatformDonations)
            }

            cell.selectionStyle = .none
            return cell



          // MARK: browse ngo
        case .browseNGOs:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedNGOsCell", for: indexPath) as! RecommendedNGOsTableViewCell
            cell.configure(with: ngosFromFirestore)
            cell.onSeeAllTapped = { [weak self] in
                self?.goToBrowseNGOs()
            }

            cell.onNGOSelected = { [weak self] ngo in
                self?.goToNgoDetails(ngo)
            }

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

            cell.onDonationSelected = { [weak self] donation in
                self?.openDonationFromDashboard(donation)
            }

            cell.onHeaderTapped = { [weak self] in
                self?.manageDonationsTapped()
            }



            return cell

                // admin all donations
        case .allDonations:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "RecentDonationsCell",
                for: indexPath
            ) as! RecentDonationTableViewCell

            cell.headerView.text = "Latest Donations"
            cell.configure(with: roleBasedDonations)

            // ✅ Donation card → Donations page
            cell.onDonationSelected = { [weak self] _ in
                self?.manageDonationsTapped()
            }

            // ✅ Header → Donations page
            cell.onHeaderTapped = { [weak self] in
                self?.manageDonationsTapped()
            }

            return cell


// MARK: PENDING donations for the ngo dashboard
        case .pendingDonations:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "RecentDonationsCell",
                for: indexPath
            ) as! RecentDonationTableViewCell

            cell.headerView.text = "Pending Donations"
            cell.configure(with: roleBasedDonations)

            // ✅ Donation card → Donations page
            cell.onHeaderTapped = { [weak self] in
                self?.manageDonationsTapped()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    NotificationCenter.default.post(name: .openPendingDonations, object: nil)
                }

            }

            cell.onDonationSelected = { [weak self] _ in
                self?.manageDonationsTapped()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    NotificationCenter.default.post(name: .openPendingDonations, object: nil)
                   }
            }

            return cell


        case .manageUsers:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ManageUsersCell",
                for: indexPath
            ) as! ManageUsersPreviewTableViewCell

            // ✅ Header "Manage Users >" tapped
            cell.onHeaderTapped = { [weak self] in
                self?.manageUsersTapped()
            }

            // ✅ User card tapped
            cell.onUserSelected = { [weak self] selectedUser in
                self?.openEditUser(userID: selectedUser.id)
            }

            return cell



        }
    }
    private func openDonationFromDashboard(_ donation: Donation1) {
        manageDonationsTapped()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            NotificationCenter.default.post(
                name: .openDonationDetailsFromDashboard,
                object: nil,
                userInfo: [
                    "firestoreID": donation.firestoreID
                ]
            )
        }
    }


    private func openEditUser(userID: String) {
        let storyboard = UIStoryboard(name: "norain-admin-controls1", bundle: nil)

        guard let editVC = storyboard.instantiateViewController(
            withIdentifier: "EditUsersViewController"
        ) as? EditUsersViewController else {
            print("❌ EditUsersViewController not found")
            return
        }

        // Fetch user document, then map into NorainDonor / NorainNGO (no model edits)
        db.collection("users").document(userID).getDocument { [weak self] doc, error in
            guard let self = self else { return }

            if let error = error {
                print("❌ Failed to fetch user for edit:", error.localizedDescription)
                return
            }

            guard let doc = doc, doc.exists, let data = doc.data() else {
                print("⚠️ User doc missing")
                return
            }

            let role = data["role"] as? Int ?? 0

            // ✅ Use Norain’s existing initializers (already in her code)
            let userToEdit: NorainAppUser
            if role == 3 {
                userToEdit = NorainNGO(documentID: doc.documentID, dictionary: data)
            } else {
                userToEdit = NorainDonor(documentID: doc.documentID, dictionary: data)
            }

            editVC.userToEdit = userToEdit

            // Keep the same presentation style Norain uses (no nav bar edits)
            let nav = UINavigationController(rootViewController: editVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }

    // MARK: - Navigation to Raghad1 storyboard

    private func goToBrowseNGOs() {
        let storyboard = UIStoryboard(name: "Raghad1", bundle: nil)

        guard let ngoVC = storyboard.instantiateViewController(
            withIdentifier: "NgoViewController"
        ) as? NgoViewController else {
            print("❌ NgoViewController not found in Raghad1 storyboard")
            return
        }

        navigationController?.pushViewController(ngoVC, animated: true)
    }

    private func goToNgoDetails(_ ngo: FatimaNGO) {
        let storyboard = UIStoryboard(name: "Raghad1", bundle: nil)

        guard let detailsVC = storyboard.instantiateViewController(
            withIdentifier: "NgoDetailsViewController"
        ) as? NgoDetailsViewController else {
            print("❌ NgoDetailsViewController not found")
            return
        }

        // 🔁 Convert FatimaNGO → NGO (Raghad’s model)
        detailsVC.selectedNgo = NGO(
            id: ngo.id,
            name: ngo.organizationName,
            category: ngo.cause,
            photo: ngo.profileImageURL,
            mission: ngo.mission,
            phoneNumber: ngo.number,
            email: ngo.email
        )

        navigationController?.pushViewController(detailsVC, animated: true)
    }

}
// MARK: - Quick Action Button Styling (iOS 15+ safe)
private func styleQuickActionButton(_ button: UIButton) {

    var config = UIButton.Configuration.filled()

    // 🎨 Background
    config.background.backgroundColor =  UIColor(named: "greenCol")
    config.background.cornerRadius = 24   // pill shape

    // 🧱 Padding (REPLACES contentEdgeInsets)
    config.contentInsets = NSDirectionalEdgeInsets(
        top: 12,
        leading: 20,
        bottom: 12,
        trailing: 20
    )

    // 🖋 Title
    config.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 16, weight: .semibold)
            outgoing.foregroundColor = .white
            return outgoing
        }

    button.configuration = config

    // 🌫 Shadow (still on layer)
    button.layer.shadowColor = UIColor.black.cgColor
    button.layer.shadowOpacity = 0.08
    button.layer.shadowRadius = 6
    button.layer.shadowOffset = CGSize(width: 0, height: 3)
    button.layer.masksToBounds = false
}
extension Notification.Name {
    static let openPendingDonations = Notification.Name("openPendingDonations")
}
extension Notification.Name {
    static let openDonationDetailsFromDashboard =
        Notification.Name("openDonationDetailsFromDashboard")
}


extension UIView {
    func applyBeigeSurface() {
        if traitCollection.userInterfaceStyle == .dark {
            backgroundColor = UIColor(named: "BeigeCol")?.withAlphaComponent(0.9)
        } else {
            backgroundColor = UIColor(named: "BeigeCol")
        }
    }
}

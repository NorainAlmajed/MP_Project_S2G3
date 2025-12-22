import UIKit

// MARK: Impact Model (derived data)
struct ImpactData {
    let totalDonations: Int
    let mealsProvided: Int
    let livesImpacted: Int
}

class DonorDashboardViewController: UIViewController {

    // MARK: Section indexes
    private let WELCOME_SECTION = 0
    private let QUICK_ACTIONS_SECTION = 1
    private let IMPACT_TRACKER_SECTION = 2
    private let GRAPH_SECTION = 3
    private let NGOS_SECTION = 4
    private let DONATIONS_SECTION = 5

    @IBOutlet weak var mainTableView: UITableView!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none

        setupEllipsisMenu()
    }

    // MARK: - Impact calculation (CORE LOGIC)
    private var impactData: ImpactData {
        calculateImpact(from: donations)
    }

    private func calculateImpact(from donations: [Donation]) -> ImpactData {

        let totalDonations = donations.count

        let mealsProvided = donations.reduce(0) { result, donation in
            result + donation.quantity
        }

        // MARK: 1 live per 3 meals
        let livesImpacted = mealsProvided / 3

        return ImpactData(
            totalDonations: totalDonations,
            mealsProvided: mealsProvided,
            livesImpacted: livesImpacted
        )
    }

    // MARK: - The ellipses in the navigation menu
    private func setupEllipsisMenu() {

        let notificationsAction = UIAction(
            title: "Notifications",
            image: UIImage(systemName: "bell")
        ) { _ in
            print("Notifications tapped")
        }

        let chatAction = UIAction(
            title: "Chat",
            image: UIImage(systemName: "message")
        ) { _ in
            print("Chat tapped")
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            menu: UIMenu(children: [notificationsAction, chatAction])
        )
    }
}

// MARK: - Table View
extension DonorDashboardViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.section {
        case WELCOME_SECTION: return 80
        case QUICK_ACTIONS_SECTION: return 80
        case IMPACT_TRACKER_SECTION: return 140
        case GRAPH_SECTION: return 200
        case NGOS_SECTION: return 220
        case DONATIONS_SECTION: return 200
        default: return 100
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // MARK: - Welcome Section
        if indexPath.section == WELCOME_SECTION {

            let cell = UITableViewCell()
            cell.selectionStyle = .none

            let label = UILabel()
            label.text = "Hi Zahraa, thank you for your generosity!"
            label.font = .boldSystemFont(ofSize: 20)
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false

            cell.contentView.addSubview(label)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 16),
                label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -16)
            ])

            return cell
        }

        // MARK: Quick Actions (view donations and browse ngo)
        if indexPath.section == QUICK_ACTIONS_SECTION {

            let cell = tableView.dequeueReusableCell(
                withIdentifier: "QuickActionsCell",
                for: indexPath
            )
            cell.selectionStyle = .none
            return cell
        }

        // MARK: - Impact Tracker
        if indexPath.section == IMPACT_TRACKER_SECTION {

            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ImpactTrackerCell",
                for: indexPath
            ) as! ImpactTrackerTableViewCell

            cell.configure(
                totalDonations: impactData.totalDonations,
                mealsProvided: impactData.mealsProvided,
                livesImpacted: impactData.livesImpacted
            )

            cell.selectionStyle = .none
            return cell
        }
        if indexPath.section == NGOS_SECTION {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "RecommendedNGOsCell",
                for: indexPath
            ) as! RecommendedNGOsTableViewCell

            cell.configure(with: recommendedNGOs)

            cell.onSeeAllTapped = {
                print("Go to NGO discovery page")
            }

            cell.onNGOSelected = { ngo in
                print("Open NGO page: \(ngo.name)")
            }

            cell.selectionStyle = .none
            return cell
        }

        // MARK: - Placeholder sections
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .systemGray5
        cell.textLabel?.text = "Section \(indexPath.section)"
        cell.textLabel?.font = .boldSystemFont(ofSize: 18)

        return cell
    }
}

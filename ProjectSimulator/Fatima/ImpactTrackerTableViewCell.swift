import UIKit

class ImpactTrackerTableViewCell: UITableViewCell {

    // MARK: - Outlets from Storyboard

    // Section title: "Impact Tracker"
    @IBOutlet weak var impactTrackerLabel: UILabel!
    private var allDonations: [Donation1] = []

    // Card containers
    @IBOutlet weak var totalCardView: UIView!
    @IBOutlet weak var mealsCardView: UIView!
    @IBOutlet weak var livesCardView: UIView!

    // Labels that show title + number inside each card
    @IBOutlet weak var totalDonationsNum: UILabel!
    @IBOutlet weak var mealsProvidedNum: UILabel!
    @IBOutlet weak var livesImpactedNum: UILabel!

    // Stack view created in code to control layout reliably
    private let cardsStackView = UIStackView()

    override func awakeFromNib() {
        super.awakeFromNib()

        // Build layout & styling once the cell is loaded
        setupLayout()
        styleCards()

        // Ensure labels can show title + number on two lines
        [totalDonationsNum, mealsProvidedNum, livesImpactedNum].forEach {
            $0?.numberOfLines = 2
            $0?.textAlignment = .center
        }
    }

    // MARK: - Layout (ALL done in code to avoid Auto Layout issues)
    private func setupLayout() {

        // Disable autoresizing masks so Auto Layout works
        impactTrackerLabel.translatesAutoresizingMaskIntoConstraints = false
        totalCardView.translatesAutoresizingMaskIntoConstraints = false
        mealsCardView.translatesAutoresizingMaskIntoConstraints = false
        livesCardView.translatesAutoresizingMaskIntoConstraints = false

        // Configure stack view for the three cards
        cardsStackView.axis = .horizontal
        cardsStackView.alignment = .fill
        cardsStackView.distribution = .fillEqually
        cardsStackView.spacing = 16
        cardsStackView.translatesAutoresizingMaskIntoConstraints = false

        // Add card views to stack view
        cardsStackView.addArrangedSubview(totalCardView)
        cardsStackView.addArrangedSubview(mealsCardView)
        cardsStackView.addArrangedSubview(livesCardView)

        // Add stack view to the cell’s content view
        contentView.addSubview(cardsStackView)

        // Layout constraints
        NSLayoutConstraint.activate([

            // Impact Tracker title at the top
            impactTrackerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            impactTrackerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            impactTrackerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Cards stack view under the title
            cardsStackView.topAnchor.constraint(equalTo: impactTrackerLabel.bottomAnchor, constant: 12),
            cardsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            // Controls card height
            cardsStackView.heightAnchor.constraint(equalToConstant: 56)
        ])

        // Center labels inside each card
        [totalDonationsNum, mealsProvidedNum, livesImpactedNum].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            totalDonationsNum.centerXAnchor.constraint(equalTo: totalCardView.centerXAnchor),
            totalDonationsNum.centerYAnchor.constraint(equalTo: totalCardView.centerYAnchor),

            mealsProvidedNum.centerXAnchor.constraint(equalTo: mealsCardView.centerXAnchor),
            mealsProvidedNum.centerYAnchor.constraint(equalTo: mealsCardView.centerYAnchor),

            livesImpactedNum.centerXAnchor.constraint(equalTo: livesCardView.centerXAnchor),
            livesImpactedNum.centerYAnchor.constraint(equalTo: livesCardView.centerYAnchor)
        ])
    }

    // MARK: - Visual styling
    private func styleCards() {
        let radius: CGFloat = 24

        // Apply consistent rounded style to all cards
        [totalCardView, mealsCardView, livesCardView].forEach {
            $0?.layer.cornerRadius = radius
            $0?.clipsToBounds = true
        }
    }

    // MARK: - Public configuration (called from dashboard)
    func configure(
        totalDonations: Int,
        mealsProvided: Int,
        livesImpacted: Int
    ) {
        totalDonationsNum.attributedText = makeStatText(
            title: "All Donations",
            value: totalDonations
        )

        mealsProvidedNum.attributedText = makeStatText(
            title: "Meals Given",
            value: mealsProvided
        )

        livesImpactedNum.attributedText = makeStatText(
            title: "Lives Impacted",
            value: livesImpacted
        )
    }

    // MARK: - Helper: formats text as title + number
    private func makeStatText(title: String, value: Int) -> NSAttributedString {

        // Style for the top title text
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.darkGray
        ]

        // Style for the main number (emphasis)
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold),
            .foregroundColor: UIColor.black
        ]

        // Combine title and value into a single label
        let result = NSMutableAttributedString(
            string: "\(title)\n",
            attributes: titleAttributes
        )

        result.append(
            NSAttributedString(
                string: "\(value)",
                attributes: valueAttributes
            )
        )

        return result
    }
}

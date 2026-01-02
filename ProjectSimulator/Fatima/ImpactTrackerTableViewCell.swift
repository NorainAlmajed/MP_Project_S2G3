import UIKit

class ImpactTrackerTableViewCell: UITableViewCell {

    // MARK: - Storyboard Outlets
    @IBOutlet weak var impactTrackerLabel: UILabel!

    @IBOutlet weak var totalCardView: UIView!
    @IBOutlet weak var mealsCardView: UIView!
    @IBOutlet weak var livesCardView: UIView!

    @IBOutlet weak var totalDonationsNum: UILabel!
    @IBOutlet weak var mealsProvidedNum: UILabel!
    @IBOutlet weak var livesImpactedNum: UILabel!

    // MARK: - Layout Containers
    private let mainStack = UIStackView()

    // MARK: - Constants
    private let smallCardHeight: CGFloat = 60   // Donor
    private let largeCardHeight: CGFloat = 65   // NGO/Admin (Figma)
    private let cornerRadius: CGFloat = 24

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBaseLayout()
        styleStaticCards()
    }

    // MARK: - Base Layout
    private func setupBaseLayout() {

        mainStack.axis = .vertical
        mainStack.spacing = 14
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: impactTrackerLabel.bottomAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Public Configure
    func configure(
        role: DonorDashboardViewController.UserRole,
        stats: [ImpactStat]
    ) {
        clearStack()

        if stats.count == 3 {
            configureDonor(stats)
        } else {
            configureGrid(stats)
        }
    }

    // MARK: - Donor Layout (3 Cards)
    private func configureDonor(_ stats: [ImpactStat]) {

        let row = makeRow()

        row.addArrangedSubview(bindStaticCard(
            card: totalCardView,
            label: totalDonationsNum,
            stat: stats[0],
            height: smallCardHeight
        ))

        row.addArrangedSubview(bindStaticCard(
            card: mealsCardView,
            label: mealsProvidedNum,
            stat: stats[1],
            height: smallCardHeight
        ))

        row.addArrangedSubview(bindStaticCard(
            card: livesCardView,
            label: livesImpactedNum,
            stat: stats[2],
            height: smallCardHeight
        ))

        mainStack.addArrangedSubview(row)
    }

    // MARK: - NGO / Admin Layout (2 Columns × N Rows)
    private func configureGrid(_ stats: [ImpactStat]) {

        let pairs = stride(from: 0, to: stats.count, by: 2)

        for index in pairs {
            let row = makeRow()

            row.addArrangedSubview(
                createDynamicCard(stat: stats[index])
            )

            if index + 1 < stats.count {
                row.addArrangedSubview(
                    createDynamicCard(stat: stats[index + 1])
                )
            }

            mainStack.addArrangedSubview(row)
        }
    }

    // MARK: - Row Factory
    private func makeRow() -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 14
        row.distribution = .fillEqually
        return row
    }

    // MARK: - Static Card Binder
    private func bindStaticCard(
        card: UIView,
        label: UILabel,
        stat: ImpactStat,
        height: CGFloat
    ) -> UIView {

        label.attributedText = makeStatText(
            title: stat.title,
            value: stat.value
        )

        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8),
            label.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            card.heightAnchor.constraint(equalToConstant: height)
        ])

        return card
    }

    // MARK: - Dynamic Card Factory
    private func createDynamicCard(stat: ImpactStat) -> UIView {

        let card = UIView()
        card.applyBeigeSurface()
        card.layer.cornerRadius = cornerRadius
        card.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.attributedText = makeStatText(
            title: stat.title,
            value: stat.value
        )
        label.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(label)

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: largeCardHeight),

            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            label.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])

        return card
    }

    // MARK: - Styling
    private func styleStaticCards() {
        [totalCardView, mealsCardView, livesCardView].forEach {
            $0?.layer.cornerRadius = cornerRadius
            $0?.clipsToBounds = true
        }
    }

    // MARK: - Cleanup
    private func clearStack() {
        mainStack.arrangedSubviews.forEach {
            mainStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    // MARK: - Text Formatter (min font = 12)
    private func makeStatText(title: String, value: Int) -> NSAttributedString {

        let titleAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.black
        ]

        let valueAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 22, weight: .semibold),
            .foregroundColor: UIColor.black
        ]

        let text = NSMutableAttributedString(
            string: "\(title)\n",
            attributes: titleAttrs
        )

        text.append(
            NSAttributedString(
                string: "\(value)",
                attributes: valueAttrs
            )
        )

        return text
    }
}

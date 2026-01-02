import UIKit
import DGCharts

final class ImpactGraphTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var chartContainer: UIView!
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Properties
    private let lineChart = LineChartView()
    private var donations: [Donation1] = []

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupChart()
    }

    // MARK: - Public Config
    func configure(with donations: [Donation1]) {
        self.donations = donations
        updateChart()
    }

    // MARK: - Chart Setup
    private func setupChart() {
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        chartContainer.addSubview(lineChart)

        NSLayoutConstraint.activate([
            lineChart.topAnchor.constraint(equalTo: chartContainer.topAnchor),
            lineChart.bottomAnchor.constraint(equalTo: chartContainer.bottomAnchor),
            lineChart.leadingAnchor.constraint(equalTo: chartContainer.leadingAnchor),
            lineChart.trailingAnchor.constraint(equalTo: chartContainer.trailingAnchor)
        ])

        // General
        lineChart.rightAxis.enabled = false
        lineChart.legend.enabled = false
        lineChart.chartDescription.enabled = false
        lineChart.backgroundColor = .clear
        lineChart.drawGridBackgroundEnabled = false

        // X Axis
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.xAxis.granularity = 1
        lineChart.xAxis.gridColor = .clear

        // Y Axis
        lineChart.leftAxis.axisMinimum = 0
        lineChart.leftAxis.gridLineDashLengths = [4, 4]
        lineChart.leftAxis.labelFont = .systemFont(ofSize: 11)

        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        let green = UIColor(named: "greenCol") ?? .systemGreen

        lineChart.xAxis.labelTextColor = isDarkMode ? .white : green
        lineChart.leftAxis.labelTextColor = isDarkMode ? .white : green
        lineChart.leftAxis.gridColor = UIColor.white.withAlphaComponent(0.15)
    }

    // MARK: - Chart Update
    private func updateChart() {
        guard !donations.isEmpty else {
            lineChart.data = nil
            return
        }

        // ✅ FILTER: only ACTIVE donations
        let activeDonations = donations.filter {
            $0.status == 2 || $0.status == 3
        }

        guard !activeDonations.isEmpty else {
            lineChart.data = nil
            return
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Last 7 days
        let days: [Date] = (0..<7).compactMap {
            calendar.date(byAdding: .day, value: -$0, to: today)
        }.reversed()

        let grouped = Dictionary(grouping: activeDonations) {
            calendar.startOfDay(for: $0.creationDate)
        }

        var entries: [ChartDataEntry] = []
        var cumulative = 0

        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"

        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(
            values: days.map { formatter.string(from: $0) }
        )

        for (index, day) in days.enumerated() {
            let count = grouped[day]?.count ?? 0
            cumulative += count
            entries.append(ChartDataEntry(x: Double(index), y: Double(cumulative)))
        }

        configureYAxis(maxValue: entries.map { $0.y }.max() ?? 1)
        configureDescription()

        let dataSet = LineChartDataSet(entries: entries, label: "")
        style(dataSet)

        lineChart.data = LineChartData(dataSet: dataSet)
        lineChart.animate(xAxisDuration: 0.4, yAxisDuration: 0.4)

        // 🔴 IMPORTANT: force refresh
        lineChart.notifyDataSetChanged()
    }

    // MARK: - Y Axis Configuration
    private func configureYAxis(maxValue: Double) {
        let paddedMax = maxValue * 1.2

        lineChart.leftAxis.axisMinimum = 0
        lineChart.leftAxis.axisMaximum = max(paddedMax, 4)

        let range = lineChart.leftAxis.axisMaximum
        let step: Double = range <= 10 ? 1 :
                           range <= 50 ? 5 :
                           range <= 100 ? 10 : 20

        lineChart.leftAxis.granularity = step
        lineChart.leftAxis.labelCount = 5
        lineChart.leftAxis.forceLabelsEnabled = false
        lineChart.leftAxis.decimals = 0

        lineChart.leftAxis.valueFormatter =
            DefaultAxisValueFormatter { value, _ in
                "\(Int(value))"
            }
    }

    // MARK: - Description
    private func configureDescription() {
        descriptionLabel?.text =
        "Shows the cumulative number of approved donations over the last 7 days."
    }

    // MARK: - Styling
    private func style(_ dataSet: LineChartDataSet) {
        let green = UIColor(named: "greenCol") ?? .systemGreen

        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 3
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.colors = [green]

        let gradientColors = [
            green.withAlphaComponent(0.4).cgColor,
            UIColor.clear.cgColor
        ] as CFArray

        let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: gradientColors,
            locations: [0.0, 1.0]
        )!

        dataSet.fill = LinearGradientFill(gradient: gradient, angle: 90)
        dataSet.drawFilledEnabled = true
    }
}

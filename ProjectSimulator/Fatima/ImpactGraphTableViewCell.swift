import UIKit
import DGCharts

final class ImpactGraphTableViewCell: UITableViewCell {

    @IBOutlet weak var chartContainer: UIView!
    @IBOutlet weak var descriptionLabel: UILabel?

    private let lineChart = LineChartView()
    private var donations: [Donation1] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        setupChart()
    }

    func configure(with donations: [Donation1]) {
        self.donations = donations
        updateChart()
    }

    private func setupChart() {
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        chartContainer.addSubview(lineChart)

        NSLayoutConstraint.activate([
            lineChart.topAnchor.constraint(equalTo: chartContainer.topAnchor),
            lineChart.bottomAnchor.constraint(equalTo: chartContainer.bottomAnchor),
            lineChart.leadingAnchor.constraint(equalTo: chartContainer.leadingAnchor),
            lineChart.trailingAnchor.constraint(equalTo: chartContainer.trailingAnchor)
        ])

        lineChart.rightAxis.enabled = false
        lineChart.legend.enabled = false
        lineChart.chartDescription.enabled = false

        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.xAxis.granularity = 1

        lineChart.leftAxis.axisMinimum = 0
        lineChart.leftAxis.gridColor = .systemGray5
        lineChart.leftAxis.labelFont = .systemFont(ofSize: 11)
        lineChart.leftAxis.labelTextColor = .darkGray
        lineChart.leftAxis.gridColor = UIColor.systemGray4.withAlphaComponent(0.4)
        lineChart.leftAxis.gridLineDashLengths = [4, 4]
        lineChart.xAxis.gridColor = UIColor.clear

    }
    private func updateChart() {
        guard !donations.isEmpty else {
            lineChart.data = nil
            return
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // 🔹 Always show last 7 days
        let days: [Date] = (0..<7).compactMap {
            calendar.date(byAdding: .day, value: -$0, to: today)
        }.reversed()

        let grouped = Dictionary(grouping: donations) {
            calendar.startOfDay(for: $0.creationDate)
        }

        var entries: [ChartDataEntry] = []
        var cumulative = 0

        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"

        lineChart.xAxis.valueFormatter =
            IndexAxisValueFormatter(values: days.map {
                formatter.string(from: $0)
            })

        for (index, day) in days.enumerated() {
            let count = grouped[day]?.count ?? 0
            cumulative += count
            entries.append(
                ChartDataEntry(x: Double(index), y: Double(cumulative))
            )
        }

        configureYAxis(maxValue: entries.map { $0.y }.max() ?? 2)
        configureDescription()

        let dataSet = LineChartDataSet(entries: entries, label: "")
        style(dataSet)

        lineChart.data = LineChartData(dataSet: dataSet)
        lineChart.animate(xAxisDuration: 0.4, yAxisDuration: 0.4)
    }


    // ✅ IMPORTANT FIX: force visible scale
    private func configureYAxis(maxValue: Double) {
        let safeMax = max(maxValue, 2)
        let step: Double = safeMax <= 10 ? 2 : safeMax <= 50 ? 5 : 10

        lineChart.leftAxis.granularity = step
        lineChart.leftAxis.axisMaximum = ceil(safeMax / step) * step
        lineChart.leftAxis.valueFormatter =
            DefaultAxisValueFormatter { value, _ in "\(Int(value))" }
    }

    private func configureDescription() {
        descriptionLabel?.text =
        "Shows the number of donations received per day, highlighting platform activity trends."
    }
    private func style(_ dataSet: LineChartDataSet) {
        let green = UIColor(named: "greenCol") ?? .systemGreen

        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 3
        dataSet.drawValuesEnabled = false

        // ❌ NO POINTS
        dataSet.drawCirclesEnabled = false

        // 🟢 Line
        dataSet.colors = [green]

        // 🌿 Smooth gradient fill
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

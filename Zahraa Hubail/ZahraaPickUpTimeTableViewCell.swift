//
//  ZahraaPickUpTimeTableViewCell.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 27/12/2025.
//

import UIKit

class ZahraaPickUpTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var timeframeTableView: UITableView!
    @IBOutlet weak var pickupTimeLbl: UILabel!
    
    @IBOutlet weak var pickupLblLeading: NSLayoutConstraint!
    
    @IBOutlet weak var pickupTableLeading: NSLayoutConstraint!
    
    private var _selectedTimeframe: String?


        // List of predefined timeframes
        var timeframes: [String] = [
            "Any Time : 9AM - 4PM",
            "9AM - 11AM",
            "12PM-1PM",
            "2PM-4PM"
        ]



        // Callback to notify parent when a timeframe is selected
        var onTimeframeSelected: ((String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        timeframeTableView.delegate = self
        timeframeTableView.dataSource = self
        timeframeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TimeframeCell")

        // ✅ Make the outer cell background adaptive
        backgroundColor = .systemBackground          // cell container
        timeframeTableView.backgroundColor = .systemBackground // inner table matches cell

        // ✅ Separator color
        if traitCollection.userInterfaceStyle == .dark {
            timeframeTableView.separatorColor = .gray
        } else {
            timeframeTableView.separatorColor = .separator // default color
        }

        if UIDevice.current.userInterfaceIdiom == .pad {
            pickupLblLeading.constant = 94
            pickupTableLeading.constant = 0
            layoutIfNeeded()
        }
    }

    
    
    }





extension ZahraaPickUpTimeTableViewCell: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeframes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeframeCell", for: indexPath)
        let time = timeframes[indexPath.row]
        cell.textLabel?.text = time

        // ✅ Text color: white only in dark mode, default in light mode
        if traitCollection.userInterfaceStyle == .dark {
            cell.textLabel?.textColor = .white
        } else {
            cell.textLabel?.textColor = nil // default color (black in light mode)
        }

        cell.backgroundColor = .clear   // shows the table view background
        cell.accessoryType = (time == _selectedTimeframe) ? .checkmark : .none
        cell.tintColor = .systemBlue

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < timeframes.count else { return }
        let selected = timeframes[indexPath.row]
        _selectedTimeframe = selected
        onTimeframeSelected?(selected)
        tableView.reloadData()
    }

    func configure(selected: String?) {
        self._selectedTimeframe = selected
        timeframeTableView.reloadData()
    }
}


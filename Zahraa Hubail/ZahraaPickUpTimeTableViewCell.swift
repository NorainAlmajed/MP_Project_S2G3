//
//  ZahraaPickUpTimeTableViewCell.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 27/12/2025.
//

import UIKit

class ZahraaPickUpTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var timeframeTableView: UITableView!
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

            // ✅ Use _selectedTimeframe instead of selectedTimeframe
            cell.accessoryType = (time == _selectedTimeframe) ? .checkmark : .none

            return cell
        }


        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard indexPath.row < timeframes.count else { return }
            let selected = timeframes[indexPath.row]
            _selectedTimeframe = selected
            if let callback = onTimeframeSelected {
                callback(selected)
            }

            tableView.reloadData()
        }

        

        func configure(selected: String?) {
            // update table view without storing it in the cell
            timeframeTableView.reloadData()
            
            // store in a private variable ONLY for table view logic
            self._selectedTimeframe = selected
        }
            

        
    }

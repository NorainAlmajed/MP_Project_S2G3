//
//  TestViewController.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 12/12/2025.
//

import UIKit

class DonationDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    var donation: Donation? 
    
    @IBOutlet weak var donationTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set delegate and dataSource
        donationTableview.delegate = self
        donationTableview.dataSource = self
        
        // Set the navigation bar title
        self.title = "Donation Details"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        
    }
    
    // Number of sections
        func numberOfSections(in tableView: UITableView) -> Int {
            return 3 // Three sections for your three blocks
        }

        // Number of rows in each section
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1 // One cell per section
        }

        // Cell for each section
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Section1Cell", for: indexPath) as! Section1TableViewCell
                // Configure NGO name, creation time, donation ID here
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Section2Cell", for: indexPath) as! Section2TableViewCell
                // Configure donor username, address, delivery date here
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Section3Cell", for: indexPath) as! Section3TableViewCell
                // Configure donation summary and buttons here
                return cell
            default:
                return UITableViewCell()
            }
        }

        // MARK: - Table View Delegate

        // Set different heights for each section
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch indexPath.section {
            case 0: return 128     // Small section
            case 1: return 196    // Medium section
            case 2: return 800    // Long section
            default: return 44
            }
        }
    
    
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



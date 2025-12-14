//
//  TestViewController.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 12/12/2025.
//

import UIKit

class DonationDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var donation: Donation? 
    
    @IBOutlet weak var donationTableview: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set delegate and dataSource
        donationTableview.delegate = self
        donationTableview.dataSource = self
        
        donationTableview.rowHeight = UITableView.automaticDimension
        donationTableview.estimatedRowHeight = 800   // any reasonable estimate

        
        // Set the navigation bar title
        self.title = "Donation Details"
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    
    //To make the donation page title appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Donation Details"
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
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {

        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "Section1Cell",
                for: indexPath
            ) as! Section1TableViewCell

            if let donation = donation {
                cell.setup(with: donation)
            }
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "Section2Cell",
                for: indexPath
            ) as! Section2TableViewCell

            if let donation = donation {
                cell.setup(with: donation)
            }
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "Section3Cell",
                for: indexPath
            ) as! Section3TableViewCell

            guard let donation = donation else { return cell }

            cell.setup(with: donation)

            cell.onCancelTapped = { [weak self] in
                guard let self = self else { return }

                let alert = UIAlertController(
                    title: "Confirmation",
                    message: "Are you sure you want to cancel the donation?",
                    preferredStyle: .alert
                )

                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

                alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                    // ✅ update optional safely
                    self.donation?.status = 5

                    let successAlert = UIAlertController(
                        title: "Success",
                        message: "The donation has been cancelled successfully",
                        preferredStyle: .alert
                    )

                    successAlert.addAction(
                        UIAlertAction(title: "Dismiss", style: .default) { _ in
                            self.donationTableview.reloadData()
                        }
                    )

                    self.present(successAlert, animated: true)
                })

                self.present(alert, animated: true)
            }
            
            cell.onAcceptTapped = { [weak self] in
                guard let self = self else { return }

                let alert = UIAlertController(
                    title: "Confirmation",
                    message: "Are you sure you want to accept the donation?",
                    preferredStyle: .alert
                )

                // Cancel button (left)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

                // Yes button (right) – changes status
                alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                    self.donation?.status = 2  // Accepted

                    let successAlert = UIAlertController(
                        title: "Success",
                        message: "The donation has been accepted successfully",
                        preferredStyle: .alert
                    )

                    // Dismiss button
                    successAlert.addAction(UIAlertAction(title: "Dismiss", style: .default) { _ in
                        self.donationTableview.reloadData() // Refresh table
                    })

                    self.present(successAlert, animated: true)
                })

                self.present(alert, animated: true)
            }

            cell.onCollectedTapped = { [weak self] in
                guard let self = self else { return }

                let alert = UIAlertController(
                    title: "Confirmation",
                    message: "Are you sure you want to mark donation as collected?",
                    preferredStyle: .alert
                )

                // Cancel button (left)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

                // Yes button (right) – changes status
                alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                    self.donation?.status = 3  // Collected

                    let successAlert = UIAlertController(
                        title: "Success",
                        message: "The donation has been marked collected successfully",
                        preferredStyle: .alert
                    )

                    // Dismiss button
                    successAlert.addAction(UIAlertAction(title: "Dismiss", style: .default) { _ in
                        self.donationTableview.reloadData() // Refresh table
                    })

                    self.present(successAlert, animated: true)
                })

                self.present(alert, animated: true)
            }

            
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
            case 2: return UITableView.automaticDimension    // Long section
            default: return UITableView.automaticDimension
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



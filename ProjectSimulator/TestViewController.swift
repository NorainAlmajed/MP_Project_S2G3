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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            
            
            
            
            
            
            
            
            // Actions when cancel button clicked
            cell.onCancelTapped = { [weak self] in
                guard let self = self, let donation = self.donation else { return }
                
                let alert = UIAlertController(
                    title: "Confirmation",
                    message: "Are you sure you want to cancel the donation?",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                    // Update the donation status
                    donation.status = 5 // Cancelled
                    
                    let currentDate = Date()
                    
                    switch user.userType {
                    case 1: // Admin
                        // Notify donor
                        if donation.donor.enableNotification {
                            donation.donor.notifications.append(Notification(
                                title: "Donation Canceled",
                                description: "Donation #\(donation.donationID) has been canceled by the admin.",
                                date: currentDate
                            ))
                        }
                        
                        
                        // Notify NGO
                        if donation.ngo.enableNotification {
                            donation.ngo.notifications.append(Notification(
                                title: "Donation Canceled",
                                description: "Donation #\(donation.donationID) has been canceled by the admin.",
                                date: currentDate
                            ))
                        }
                        
                        
                    case 2: // Donor
                        // Notify only NGO
                        if donation.ngo.enableNotification {
                            donation.ngo.notifications.append(Notification(
                                title: "Donation Canceled",
                                description: "Donation #\(donation.donationID) has been canceled by \(user.username).",
                                date: currentDate
                            ))
                        }
                        
                        
                    default:
                        break
                    }
                    
                    // -----------------------------------------------------------
                    // After appending the notifications for donor, NGO, and admin
                    //
                    // Get the latest notification for donor, NGO, and admin
//                    let lastDonorNotification = donation.donor.notifications?.last?.description ?? "No notifications"
//                    let lastNgoNotification = donation.ngo.notifications.last?.description ?? "No notifications"
//                    let lastAdminNotification = admin.notifications?.last?.description ?? "No notifications"
//                    
//                    // Create the message for the alert
//                    let notificationDetails = """
//                    Donor Last Notification: \(lastDonorNotification)
//                    NGO Last Notification: \(lastNgoNotification)
//                    Admin Last Notification: \(lastAdminNotification)
//                    """
//                    
//                    // Create the alert
//                    let alert = UIAlertController(
//                        title: "Notification Details",
//                        message: notificationDetails,
//                        preferredStyle: .alert
//                    )
//                    
//                    // Add a dismiss button
//                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
//                    
//                    // Present the alert to show the last notifications
//                    self.present(alert, animated: true)
//                    
//                    // --------------------------
//                    // Print last notifications for testing
//                    print("==== Notifications Test ====")
//                    print("Admin last notification:", admin.notifications?.last ?? "No notifications")
//                    print("Donor last notification:", donation.donor.notifications?.last ?? "No notifications")
//                    print("NGO last notification:", donation.ngo.notifications.last ?? "No notifications")
//                    print("Current user type:", user.userType)
//                    print("============================")
//                    // --------------------------
                    
                    // Show success alert
                    let successAlert = UIAlertController(
                        title: "Success",
                        message: "The donation has been cancelled successfully",
                        preferredStyle: .alert
                    )
                    successAlert.addAction(UIAlertAction(title: "Dismiss", style: .default) { _ in
                        self.donationTableview.reloadData()
                    })
                    self.present(successAlert, animated: true)
                })
                
                self.present(alert, animated: true)
            }
            
            //----------------------------------------------------------------------------------
            // Actions when pressing the accept button
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
                    
                    let currentDate = Date()
                    
                    // Check userType and add notifications
                    switch user.userType {
                    case 1: // Admin
                        // Notify donor
                        if donation.donor.enableNotification {
                            donation.donor.notifications.append(Notification(
                                title: "Donation Accepted",
                                description: "Donation #\(self.donation?.donationID ?? 0) has been accepted by the admin.",
                                date: currentDate
                            ))
                        }
                        
                        
                        // Notify NGO
                        if donation.ngo.enableNotification {
                            donation.ngo.notifications.append(Notification(
                                title: "Donation Accepted",
                                description: "Donation #\(self.donation?.donationID ?? 0) has been accepted by the admin.",
                                date: currentDate
                            ))
                        }
                        
                        
                    case 3: // NGO
                        // Notify only Donor
                        if donation.donor.enableNotification {
                            donation.donor.notifications.append(Notification(
                                title: "Donation Accepted",
                                description: "Donation #\(self.donation?.donationID ?? 0) has been accepted by \(self.donation?.ngo.ngoName ?? "the NGO").",
                                date: currentDate
                            ))
                        }
                    
                        
                    default:
                        break
                    }
                    
                    
                    
//                    // -----------------------------------------------------------
//                    // After appending the notifications for donor, NGO, and admin
//                    //
//                    // Get the latest notification for donor, NGO, and admin
//                    let lastDonorNotification = donation.donor.notifications?.last?.description ?? "No notifications"
//                    let lastNgoNotification = donation.ngo.notifications.last?.description ?? "No notifications"
//                    let lastAdminNotification = admin.notifications?.last?.description ?? "No notifications"
//                     //Create the message for the alert
//                    let notificationDetails = """
//                        Donor Last Notification: \(lastDonorNotification)
//                        NGO Last Notification: \(lastNgoNotification)
//                        Admin Last Notification: \(lastAdminNotification)
//                        """
//                    
//
//                    // Create the alert
//                    let alert = UIAlertController(
//                        title: "Notification Details",
//                        message: notificationDetails,
//                        preferredStyle: .alert
//                    )
//                    
//                    // Add a dismiss button
//                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
//                    
//                    // Present the alert to show the last notifications
//                    self.present(alert, animated: true)
//                    
//                    // --------------------------
//                    // Print last notifications for testing
//                    print("==== Notifications Test ====")
//                    print("Admin last notification:", admin.notifications?.last ?? "No notifications")
//                    print("Donor last notification:", donation.donor.notifications?.last ?? "No notifications")
//                    print("NGO last notification:", donation.ngo.notifications.last ?? "No notifications")
//                    print("Current user type:", user.userType)
//                    print("============================")
//                    // --------------------------
                    
                    
                    
                    
                    
                    // Show success alert
                    let successAlert = UIAlertController(
                        title: "Success",
                        message: "The donation has been accepted successfully",
                        preferredStyle: .alert
                    )
                    
                    successAlert.addAction(UIAlertAction(title: "Dismiss", style: .default) { _ in
                        self.donationTableview.reloadData()
                    })
                    
                    self.present(successAlert, animated: true)
                })
                
                self.present(alert, animated: true)
            }
            
            
            
            
            
            
            
            //----------------------------------------------------------------------------------
            // Actions when pressing the collected button
            cell.onCollectedTapped = { [weak self] in
                guard let self = self else { return }
                
                let alert = UIAlertController(
                    title: "Confirmation",
                    message: "Are you sure you want to mark donation as collected?",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                    self.donation?.status = 3  // Collected
                    
                    // Current Date and Time
                    let currentDate = Date()

                    // Check userType and add notifications
                    switch user.userType {
                    case 1: // Admin
                        // Notify donor
                        if donation.donor.enableNotification {
                            donation.donor.notifications.append(Notification(
                                title: "Donation Marked as Collected",
                                description: "Donation #\(self.donation?.donationID ?? 0) has been marked as collected by the admin.",
                                date: currentDate
                            ))
                        }
                        
                        
                        // Notify NGO
                        if donation.ngo.enableNotification {
                            donation.ngo.notifications.append(Notification(
                                title: "Donation Marked as Collected",
                                description: "Donation #\(self.donation?.donationID ?? 0) has been marked as collected by the admin.",
                                date: currentDate
                            ))
                        }
                        
                        
                    case 3: // NGO
                        // Notify only Donor
                        if donation.donor.enableNotification {
                            donation.donor.notifications.append(Notification(
                                title: "Donation Marked as Collected",
                                description: "Donation #\(self.donation?.donationID ?? 0) has been marked as collected by \(self.donation?.ngo.ngoName ?? "the NGO").",
                                date: currentDate
                            ))
                        }
                        
                        
                    default:
                        break
                    }
                    
                    
//                                        // -----------------------------------------------------------
//                                        // After appending the notifications for donor, NGO, and admin
//                                        //
//                                        // Get the latest notification for donor, NGO, and admin
//                                        let lastDonorNotification = donation.donor.notifications?.last?.description ?? "No notifications"
//                                        let lastNgoNotification = donation.ngo.notifications.last?.description ?? "No notifications"
//                                        let lastAdminNotification = admin.notifications?.last?.description ?? "No notifications"
//                                         //Create the message for the alert
//                                        let notificationDetails = """
//                                            Donor Last Notification: \(lastDonorNotification)
//                                            NGO Last Notification: \(lastNgoNotification)
//                                            Admin Last Notification: \(lastAdminNotification)
//                                            """
//                    
//                    
//                                        // Create the alert
//                                        let alert = UIAlertController(
//                                            title: "Notification Details",
//                                            message: notificationDetails,
//                                            preferredStyle: .alert
//                                        )
//                    
//                                        // Add a dismiss button
//                                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
//                    
//                                        // Present the alert to show the last notifications
//                                        self.present(alert, animated: true)
//                    
//                                        // --------------------------
//                                        // Print last notifications for testing
//                                        print("==== Notifications Test ====")
//                                        print("Admin last notification:", admin.notifications?.last ?? "No notifications")
//                                        print("Donor last notification:", donation.donor.notifications?.last ?? "No notifications")
//                                        print("NGO last notification:", donation.ngo.notifications.last ?? "No notifications")
//                                        print("Current user type:", user.userType)
//                                        print("============================")
//                                        // --------------------------
                    
                    
                    // Show success alert
                    let successAlert = UIAlertController(
                        title: "Success",
                        message: "The donation has been marked collected successfully",
                        preferredStyle: .alert
                    )
                    
                    successAlert.addAction(UIAlertAction(title: "Dismiss", style: .default) { _ in
                        self.donationTableview.reloadData() // Refresh table
                    })
                    
                    self.present(successAlert, animated: true)
                })
                
                self.present(alert, animated: true)
            }


            
            
            
            
            
            //----------------------------------------------------------------------------------
            // Actions when pressing the reject button
            cell.onRejectTapped = { [weak self] in
                guard let self = self else { return }
                
                let alert = UIAlertController(
                    title: "Confirmation",
                    message: "Are you sure you want to reject the donation?",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                // Yes button (right) → navigate to modal rejection page
                alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                    // Initialize the rejection page
                    let storyboard = UIStoryboard(name: "Donations", bundle: nil) // replace "Main" if your storyboard has another name
                    
                    if let rejectionVC = storyboard.instantiateViewController(
                        withIdentifier: "ZHRejectionReasonViewController"
                    ) as? ZHRejectionReasonViewController {

                        // Optional: pass donation data if needed
                        rejectionVC.donation = self.donation
                        
                        rejectionVC.onRejectionCompleted = { [weak self] in
                            self?.donationTableview.reloadData()
                        }

                        // Present modally
                        rejectionVC.modalPresentationStyle = .pageSheet // slides above
                        rejectionVC.modalTransitionStyle = .coverVertical // slide up animation

                        self.present(rejectionVC, animated: true)
                    }
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


//
//  TestViewController.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 12/12/2025.
//

import UIKit
import PDFKit


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
        
        //Export button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(exportTapped)
        )

    }
    
    
    //Preparing data for exporting
    private func buildDonationReport(for donation: Donation) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let createdDate = dateFormatter.string(from: donation.creationDate)
        let pickupDate = dateFormatter.string(from: donation.pickupDate)
        let expiryDate = dateFormatter.string(from: donation.expiryDate)
        
        // Address formatting
        var addressText = """
        Building: \(donation.address.building)
        Road: \(donation.address.road)
        Block: \(donation.address.block)
        Area: \(donation.address.area)
        Governorate: \(donation.address.governorate)
        """
        
        if let flat = donation.address.flat {
            addressText += "\nFlat: \(flat)"
        }
        
        // Optional fields
        let weightText = donation.weight != nil ? "\(donation.weight!) kg" : nil
        let descriptionText = donation.description?.trimmingCharacters(in: .whitespacesAndNewlines)
        let rejectionReasonText = donation.rejectionReason?.trimmingCharacters(in: .whitespacesAndNewlines)
        let recurrenceText = donation.recurrence > 0 ? "Every \(donation.recurrence) days" : nil
        
        var report = """
        ====================================
                DONATION REPORT
        ====================================

        ▶ BASIC INFORMATION
        ------------------------------------
        Donation ID:        \(donation.donationID)
        NGO Name:           \(donation.ngo.ngoName)
        Donor Username:    \(donation.donor.username)
        Created On:        \(createdDate)
        Status:            \(statusText(for: donation.status))

        ▶ DONATION DETAILS
        ------------------------------------
        Category:          \(donation.Category)
        Quantity:          \(donation.quantity)
        """
        
        if let weightText {
            report += "\nWeight:            \(weightText)"
        }
        
        report += """

        ▶ PICKUP INFORMATION
        ------------------------------------
        Pickup Date:       \(pickupDate)
        Pickup Time:       \(donation.pickupTime)

        ▶ ADDRESS
        ------------------------------------
        \(addressText)

        ▶ EXPIRY
        ------------------------------------
        Expiry Date:       \(expiryDate)
        """
        
        if let descriptionText, !descriptionText.isEmpty {
            report += """

            ▶ DESCRIPTION
            ------------------------------------
            \(descriptionText)
            """
        }
        
        if let rejectionReasonText, !rejectionReasonText.isEmpty {
            report += """

            ▶ REJECTION REASON
            ------------------------------------
            \(rejectionReasonText)
            """
        }
        
        if let recurrenceText {
            report += """

            ▶ RECURRENCE
            ------------------------------------
            \(recurrenceText)
            """
        }
        
        report += """

        ====================================
        Generated On: \(DateFormatter.localizedString(
            from: Date(),
            dateStyle: .medium,
            timeStyle: .short
        ))
        ProjectSimulator App
        ====================================
        """
        
        return report
    }

    
    
    //For exporting data
    @objc private func exportTapped() {
        guard let donation = donation else { return }

        // PDF
        let pdfData = buildDonationPDF(for: donation)
        let pdfURL = FileManager.default.temporaryDirectory.appendingPathComponent("DonationReport.pdf")
        try? pdfData.write(to: pdfURL)
        
        // Plain text
        let textReport = buildDonationReport(for: donation)
        
        // Share both
        let activityVC = UIActivityViewController(activityItems: [textReport, pdfURL], applicationActivities: nil)
        
        if let popover = activityVC.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(activityVC, animated: true)
    }



    
    //To make the donation page title appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Donation Details"
        
        // Remove default navigation bar shadow
        navigationController?.navigationBar.shadowImage = UIImage()

        // Avoid adding the line multiple times
        navigationController?.navigationBar.subviews
            .filter { $0.tag == 999 }
            .forEach { $0.removeFromSuperview() }

        // Add custom bottom line
        let bottomLine = UIView()
        bottomLine.tag = 999
        bottomLine.backgroundColor = UIColor.systemGray4
        bottomLine.translatesAutoresizingMaskIntoConstraints = false

        navigationController?.navigationBar.addSubview(bottomLine)

        NSLayoutConstraint.activate([
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
            bottomLine.leadingAnchor.constraint(equalTo: navigationController!.navigationBar.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: navigationController!.navigationBar.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor)
        ])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.subviews
            .filter { $0.tag == 999 }
            .forEach { $0.removeFromSuperview() }
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
    
    
    //Setting the status
    private func statusText(for status: Int) -> String {
        switch status {
        case 1: return "Pending"
        case 2: return "Accepted"
        case 3: return "Collected"
        case 4: return "Rejected"
        case 5: return "Cancelled"
        default: return "Unknown"
        }
    }
    
    //For PDF exporting
    private func buildDonationPDF(for donation: Donation) -> Data {
        let reportText = buildDonationReport(for: donation)
        
        let pdfMetaData = [
            kCGPDFContextCreator: "ProjectSimulator",
            kCGPDFContextAuthor: user.username,
            kCGPDFContextTitle: "Donation Report"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 595.2   // A4 width in points
        let pageHeight = 841.8  // A4 height in points
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.black
            ]
            
            reportText.draw(in: CGRect(x: 20, y: 20, width: pageRect.width - 40, height: pageRect.height - 40), withAttributes: attributes)
        }
        
        return data
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


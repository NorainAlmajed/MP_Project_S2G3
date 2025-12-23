//
//  TestViewController.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 12/12/2025.
//

import UIKit
import PDFKit
import FirebaseFirestore



class DonationDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var donation: Donation?
    var currentUser: User?

    
    @IBOutlet weak var donationTableview: UITableView!
    
 
        
        
        override func viewDidLoad() {
            super.viewDidLoad()

            // Set delegate and dataSource
            donationTableview.delegate = self
            donationTableview.dataSource = self
            
            donationTableview.rowHeight = UITableView.automaticDimension
            donationTableview.estimatedRowHeight = 800

            // Set the navigation bar title
            self.title = "Donation Details"
            navigationController?.navigationBar.prefersLargeTitles = false
            
            // Export button
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "square.and.arrow.up"),
                style: .plain,
                target: self,
                action: #selector(exportTapped)
            )
        }
        
        @IBAction func exportDonation(_ sender: UIButton) {
            guard let donation = donation else {
                print("No donation available")
                return
            }
            ExcelExporter.shareCSV(from: self, donation: donation)
        }
        
        private func buildDonationReport(for donation: Donation) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            let createdDate = dateFormatter.string(from: donation.creationDate.dateValue())
            let pickupDate = dateFormatter.string(from: donation.pickupDate.dateValue())
            let expiryDate = dateFormatter.string(from: donation.expiryDate.dateValue())

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
            NGO Name:           \(donation.ngo.organization_name)
            Donor Username:     \(donation.donor.username)
            Created On:         \(createdDate)
            Status:             \(statusText(for: donation.status))

            ▶ DONATION DETAILS
            ------------------------------------
            Category:           \(donation.category)
            Quantity:           \(donation.quantity)
            """
            
            if let weightText {
                report += "\nWeight:            \(weightText)"
            }
            
            report += """

            ▶ PICKUP INFORMATION
            ------------------------------------
            Pickup Date:        \(pickupDate)
            Pickup Time:        \(donation.pickupTime)

            ▶ ADDRESS
            ------------------------------------
            \(addressText)

            ▶ EXPIRY
            ------------------------------------
            Expiry Date:        \(expiryDate)
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
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
            navigationController?.navigationBar.prefersLargeTitles = false
            title = "Donation Details"
            navigationController?.navigationBar.shadowImage = UIImage()

            navigationController?.navigationBar.subviews
                .filter { $0.tag == 999 }
                .forEach { $0.removeFromSuperview() }

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

        // MARK: - Table View DataSource

        func numberOfSections(in tableView: UITableView) -> Int { 3 }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Section1Cell", for: indexPath) as! Section1TableViewCell
                if let donation = donation { cell.setup(with: donation) }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Section2Cell", for: indexPath) as! Section2TableViewCell
                if let donation = donation { cell.setup(with: donation) }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Section3Cell", for: indexPath) as! Section3TableViewCell
                guard let donation = donation, let currentUser = currentUser else { return cell }
                cell.setup(with: donation, currentUser: currentUser)

                // Cancel button
                cell.onCancelTapped = { [weak self] in
                    guard let self = self else { return }

                    let alert = UIAlertController(
                        title: "Confirmation",
                        message: "Are you sure you want to cancel the donation?",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                        guard let donation = self.donation, let firestoreID = donation.firestoreID else {
                            print("No donation or firestoreID")
                            return
                        }

                        let donationRef = Firestore.firestore().collection("Donation").document(firestoreID)
                        donationRef.updateData(["status": 5]) { error in
                            if let error = error {
                                print("Error updating donation status: \(error.localizedDescription)")
                                return
                            }

                            // Update the local donation object
                            donation.status = 5

                            // =========================
                            // NOTIFICATIONS LOGIC START
                            // =========================
                            let currentDate = Date()

                            if let currentUser = self.currentUser {
                                switch currentUser.role {
                                case 1: // Admin: notify both donor and NGO
                                    // Donor notification
                                    if donation.donor.enableNotification {
                                        Firestore.firestore().collection("Notification").addDocument(data: [
                                            "title": "Donation Canceled",
                                            "description": "Donation #\(donation.donationID) has been canceled by the admin.",
                                            "userID": donation.donor.userID,
                                            "date": currentDate
                                        ])
                                    }
                                    // NGO notification
                                    if donation.ngo.enableNotification {
                                        Firestore.firestore().collection("Notification").addDocument(data: [
                                            "title": "Donation Canceled",
                                            "description": "Donation #\(donation.donationID) has been canceled by the admin.",
                                            "userID": donation.ngo.userID,
                                            "date": currentDate
                                        ])
                                    }

                                case 2: // Donor: notify only NGO
                                    if donation.ngo.enableNotification {
                                        Firestore.firestore().collection("Notification").addDocument(data: [
                                            "title": "Donation Canceled",
                                            "description": "Donation #\(donation.donationID) has been canceled by \(donation.donor.username).",
                                            "userID": donation.ngo.userID,
                                            "date": currentDate
                                        ])
                                    }

                                default:
                                    break
                                }
                            }
                            // =========================
                            // NOTIFICATIONS LOGIC END
                            // =========================

                            // Reload table to reflect the new status
                            self.donationTableview.reloadData()

                            // Show success message
                            let successAlert = UIAlertController(
                                title: "Success",
                                message: "The donation has been cancelled successfully",
                                preferredStyle: .alert
                            )
                            successAlert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                            self.present(successAlert, animated: true)
                        }
                    })
                    self.present(alert, animated: true)
                }


                
                
                
                
                

                // Accept button
                cell.onAcceptTapped = { [weak self] in
                    guard let self = self else { return }
                    let alert = UIAlertController(
                        title: "Confirmation",
                        message: "Are you sure you want to accept the donation?",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                        guard let donation = self.donation, let firestoreID = donation.firestoreID else {
                            print("No donation or firestoreID")
                            return
                        }

                        let donationRef = Firestore.firestore().collection("Donation").document(firestoreID)
                        donationRef.updateData(["status": 2]) { error in
                            if let error = error {
                                print("Error updating donation status: \(error.localizedDescription)")
                                return
                            }

                            // Update the local donation object
                            donation.status = 2

                            // =========================
                            // NOTIFICATIONS LOGIC START
                            // =========================
                            let currentDate = Date()

                            if let currentUser = self.currentUser {
                                switch currentUser.role {
                                case 1: // Admin: notify both donor and NGO
                                    // Donor notification
                                    if donation.donor.enableNotification {
                                        Firestore.firestore().collection("Notification").addDocument(data: [
                                            "title": "Donation Accepted",
                                            "description": "Donation #\(donation.donationID) has been accepted by the admin.",
                                            "userID": donation.donor.userID,
                                            "date": currentDate
                                        ])
                                    }
                                    // NGO notification
                                    if donation.ngo.enableNotification {
                                        Firestore.firestore().collection("Notification").addDocument(data: [
                                            "title": "Donation Accepted",
                                            "description": "Donation #\(donation.donationID) has been accepted by the admin.",
                                            "userID": donation.ngo.userID,
                                            "date": currentDate
                                        ])
                                    }

                           

                                case 3: // NGO: notify only donor
                                    if donation.donor.enableNotification {
                                        Firestore.firestore().collection("Notification").addDocument(data: [
                                            "title": "Donation Accepted",
                                            "description": "Donation #\(donation.donationID) has been accepted by \(String(describing: currentUser.organization_name)).",
                                            "userID": donation.donor.userID,
                                            "date": currentDate
                                        ])
                                    }

                                default:
                                    break
                                }
                            }
                            // =========================
                            // NOTIFICATIONS LOGIC END
                            // =========================

                            // Reload table to reflect the new status
                            self.donationTableview.reloadData()

                            // Show success message
                            let successAlert = UIAlertController(
                                title: "Success",
                                message: "The donation has been accepted successfully",
                                preferredStyle: .alert
                            )
                            successAlert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                            self.present(successAlert, animated: true)
                        }
                    })
                    self.present(alert, animated: true)
                }


                
                
                
                
                
                // Collected button
                cell.onCollectedTapped = { [weak self] in
                    guard let self = self else { return }
                    let alert = UIAlertController(
                        title: "Confirmation",
                        message: "Are you sure you want to mark the donation as collected?",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                        guard let donation = self.donation, let firestoreID = donation.firestoreID else {
                            print("No donation or firestoreID")
                            return
                        }

                        let donationRef = Firestore.firestore().collection("Donation").document(firestoreID)
                        donationRef.updateData(["status": 3]) { error in
                            if let error = error {
                                print("Error updating donation status: \(error.localizedDescription)")
                                return
                            }

                            // Update the local donation object
                            donation.status = 3

                            // =========================
                            // NOTIFICATIONS LOGIC START
                            // =========================
                            let currentDate = Date()

                            if let currentUser = self.currentUser {
                                switch currentUser.role {
                                case 1: // Admin: notify both donor and NGO
                                    // Donor notification
                                    if donation.donor.enableNotification {
                                        Firestore.firestore().collection("Notification").addDocument(data: [
                                            "title": "Donation Marked as Collected",
                                            "description": "Donation #\(donation.donationID) has been marked as collected by the admin.",
                                            "userID": donation.donor.userID,
                                            "date": currentDate
                                        ])
                                    }
                                    // NGO notification
                                    if donation.ngo.enableNotification {
                                        Firestore.firestore().collection("Notification").addDocument(data: [
                                            "title": "Donation Marked as Collected",
                                            "description": "Donation #\(donation.donationID) has been marked as collected by the admin.",
                                            "userID": donation.ngo.userID,
                                            "date": currentDate
                                        ])
                                    }

                                case 3: // NGO: notify only donor
                                    if donation.donor.enableNotification {
                                        Firestore.firestore().collection("Notification").addDocument(data: [
                                            "title": "Donation Marked as Collected",
                                            "description": "Donation #\(donation.donationID) has been marked as collected by \(currentUser.organization_name ?? "the NGO").",
                                            "userID": donation.donor.userID,
                                            "date": currentDate
                                        ])
                                    }

                                default:
                                    break
                                }
                            }
                            // =========================
                            // NOTIFICATIONS LOGIC END
                            // =========================

                            // Reload table to reflect the new status
                            self.donationTableview.reloadData()

                            // Show success message
                            let successAlert = UIAlertController(
                                title: "Success",
                                message: "The donation has been marked collected successfully",
                                preferredStyle: .alert
                            )
                            successAlert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                            self.present(successAlert, animated: true)
                        }
                    })
                    self.present(alert, animated: true)
                }

                
                
                
                // Reject button
                cell.onRejectTapped = { [weak self] in
                    guard let self = self else { return }
                    let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to reject the donation?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                        let storyboard = UIStoryboard(name: "Donations", bundle: nil)
                        if let rejectionVC = storyboard.instantiateViewController(withIdentifier: "ZHRejectionReasonViewController") as? ZHRejectionReasonViewController {
                            rejectionVC.donation = self.donation
                            rejectionVC.onRejectionCompleted = { [weak self] in
                                self?.donationTableview.reloadData()
                            }
                            rejectionVC.modalPresentationStyle = .pageSheet
                            rejectionVC.modalTransitionStyle = .coverVertical
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

    
    
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch indexPath.section {
            case 0: return 128
            case 1: return 196
            case 2: return UITableView.automaticDimension
            default: return UITableView.automaticDimension
            }
        }

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

    private func buildDonationPDF(for donation: Donation) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "ProjectSimulator",
            kCGPDFContextAuthor: currentUser?.username ?? "Unknown",
            kCGPDFContextTitle: "Donation Report"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth: CGFloat = 595.2
        let pageHeight: CGFloat = 841.8
        let margin: CGFloat = 40
        
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            let reportText = buildDonationReport(for: donation)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .left
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .paragraphStyle: paragraphStyle
            ]
            
            let textRect = CGRect(x: margin, y: margin, width: pageWidth - 2 * margin, height: pageHeight - 2 * margin)
            reportText.draw(in: textRect, withAttributes: attributes)
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


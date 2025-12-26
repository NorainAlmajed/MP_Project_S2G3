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
    var currentUser: ZahraaUser?
    var donationImage: UIImage?


    
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
            
            preloadDonationImage()
            
            // Ensure separators are shown
            donationTableview.separatorStyle = .singleLine

            // Set separator color to be visible in both light and dark mode
            donationTableview.separatorColor = UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? .lightGray : .gray
            }
            
            // Remove back button text for the next VC
                let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigationItem.backBarButtonItem = backItem

        }
        
        @IBAction func exportDonation(_ sender: UIButton) {
            guard let donation = donation else {
                print("No donation available")
                return
            }
            ExcelExporter.shareCSV(from: self, donation: donation)
        }
    
    
    
        
    private func buildDonationReport(for donation: Donation) -> NSAttributedString {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        let createdDate = dateFormatter.string(from: donation.creationDate.dateValue())
        let pickupDate = dateFormatter.string(from: donation.pickupDate.dateValue())
        let expiryDate = dateFormatter.string(from: donation.expiryDate.dateValue())

        // Convert address fields to strings
        var addressLines: [String: String] = [
            "Building": String(donation.address.building),
            "Road": String(donation.address.road),
            "Block": String(donation.address.block),
            "Area": donation.address.area,
            "Governorate": donation.address.governorate
        ]

        if let flat = donation.address.flat, flat > 0 {
            addressLines["Flat"] = String(flat)
        }

        // Only include meaningful weight
        let weightText = (donation.weight != nil && donation.weight! > 0) ? "\(donation.weight!) kg" : nil
        let descriptionText = donation.description?.trimmingCharacters(in: .whitespacesAndNewlines)
        let rejectionReasonText = donation.rejectionReason?.trimmingCharacters(in: .whitespacesAndNewlines)
        let recurrenceText = donation.recurrence > 0 ? "Every \(donation.recurrence) days" : nil

        // Monospaced font for table-like layout
        let monoFont = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        let boldMonoFont = UIFont.monospacedSystemFont(ofSize: 16, weight: .bold)

        let report = NSMutableAttributedString()

        // Helper to append centered title
        func appendCentered(_ text: String) {
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            let attr = NSAttributedString(string: text + "\n\n", attributes: [.font: boldMonoFont, .paragraphStyle: paragraph])
            report.append(attr)
        }

        // Helper to append normal rows
        func appendRow(label: String, value: String) {
            let paddedLabel = label.padding(toLength: 20, withPad: " ", startingAt: 0)
            let line = "\(paddedLabel): \(value)\n"
            let attr = NSAttributedString(string: line, attributes: [.font: monoFont])
            report.append(attr)
        }

        // Helper to append section headers
        func appendSectionHeader(_ text: String) {
            let line = "------------------------------------------------------------\n"
            let attrLine = NSAttributedString(string: line, attributes: [.font: monoFont])
            report.append(attrLine)
            let attrHeader = NSAttributedString(string: text + "\n", attributes: [.font: boldMonoFont])
            report.append(attrHeader)
            report.append(attrLine)
        }

        // Top border
        let topLine = NSAttributedString(string: "=============================================\n", attributes: [.font: monoFont])
        report.append(topLine)

        appendCentered("DONATION REPORT")

        report.append(topLine)
        report.append(NSAttributedString(string: "\n", attributes: [.font: monoFont]))

        // Basic Information
        appendSectionHeader("▶ BASIC INFORMATION")
        appendRow(label: "Donation ID", value: "#\(donation.donationID)")
        appendRow(label: "NGO Name", value: donation.ngo.organization_name ?? donation.ngo.username)
        appendRow(label: "Donor Username", value: donation.donor.username)
        appendRow(label: "Created On", value: createdDate)
        appendRow(label: "Status", value: statusText(for: donation.status))

        // Donation Details
        appendSectionHeader("▶ DONATION DETAILS")
        appendRow(label: "Category", value: donation.category)
        appendRow(label: "Quantity", value: "\(donation.quantity)")
        if let weightText { appendRow(label: "Weight", value: weightText) }

        if let descriptionText, !descriptionText.isEmpty {
            appendSectionHeader("▶ DESCRIPTION")
            report.append(NSAttributedString(string: descriptionText + "\n", attributes: [.font: monoFont]))
        }

        if let rejectionReasonText, !rejectionReasonText.isEmpty {
            appendSectionHeader("▶ REJECTION REASON")
            report.append(NSAttributedString(string: rejectionReasonText + "\n", attributes: [.font: monoFont]))
        }

        // Pickup Information
        appendSectionHeader("▶ PICKUP INFORMATION")
        appendRow(label: "Pickup Date", value: pickupDate)
        appendRow(label: "Pickup Time", value: donation.pickupTime)

        // Address
        appendSectionHeader("▶ ADDRESS")
        for (key, value) in addressLines {
            appendRow(label: key, value: value)
        }

        // Expiry
        appendSectionHeader("▶ EXPIRY")
        appendRow(label: "Expiry Date", value: expiryDate)

        // Recurrence
        if let recurrenceText {
            appendSectionHeader("▶ RECURRENCE")
            report.append(NSAttributedString(string: recurrenceText + "\n", attributes: [.font: monoFont]))
        }

        // Bottom border & footer
        report.append(NSAttributedString(string: "\n", attributes: [.font: monoFont]))
        report.append(topLine)
        let generated = "Generated On: \(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short))\nProjectSimulator App\n"
        report.append(NSAttributedString(string: generated, attributes: [.font: monoFont]))
        report.append(topLine)

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
            
            navigationController?.navigationBar.tintColor = UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? .white : .black
            }


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
                                        let ngoName = currentUser.organization_name ?? "the NGO"
                                        Firestore.firestore().collection("Notification").addDocument(data: [
                                            "title": "Donation Accepted",
                                            "description": "Donation #\(donation.donationID) has been accepted by \(ngoName).",
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
                            rejectionVC.currentUser = self.currentUser   // <-- Pass the current user
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

    //Prepating pdf
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
        let imageMaxSize: CGFloat = 150
        let lineSpacing: CGFloat = 6

        var isFirstPage = true

        let renderer = UIGraphicsPDFRenderer(
            bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight),
            format: format
        )

        let data = renderer.pdfData { context in
            var yPosition: CGFloat = margin

            let greenColor = UIColor(named: "greenCol") ?? .systemGreen

            func drawLine(at y: CGFloat, thickness: CGFloat = 1) {
                let path = UIBezierPath()
                path.move(to: CGPoint(x: margin, y: y))
                path.addLine(to: CGPoint(x: pageWidth - margin, y: y))
                greenColor.setStroke()
                path.lineWidth = thickness
                path.stroke()
            }

            func drawHeader(_ text: String, y: inout CGFloat) {
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .left
                paragraph.lineSpacing = lineSpacing

                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 16),
                    .foregroundColor: greenColor,
                    .paragraphStyle: paragraph
                ]

                let nsText = NSString(string: text)
                let rect = CGRect(x: margin, y: y, width: pageWidth - margin * 2, height: .greatestFiniteMagnitude)

                let size = nsText.boundingRect(
                    with: rect.size,
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    attributes: attributes,
                    context: nil
                )

                // Check if next content fits in page, else start new page
                if y + size.height > pageHeight - margin {
                    context.beginPage()
                    y = margin
                }

                nsText.draw(
                    with: CGRect(x: margin, y: y, width: rect.width, height: size.height),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    attributes: attributes,
                    context: nil
                )

                y += size.height + 4
                drawLine(at: y, thickness: 1.5)
                y += 10
            }

            func drawText(_ text: String, y: inout CGFloat, font: UIFont = .systemFont(ofSize: 12)) {
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .left
                paragraph.lineSpacing = lineSpacing

                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: UIColor.label,
                    .paragraphStyle: paragraph
                ]

                let nsText = NSString(string: text)
                let rect = CGRect(x: margin, y: y, width: pageWidth - margin * 2, height: .greatestFiniteMagnitude)

                let size = nsText.boundingRect(
                    with: rect.size,
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    attributes: attributes,
                    context: nil
                )

                // Check if next content fits in page, else start new page
                if y + size.height > pageHeight - margin {
                    context.beginPage()
                    y = margin
                }

                nsText.draw(
                    with: CGRect(x: margin, y: y, width: rect.width, height: size.height),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    attributes: attributes,
                    context: nil
                )

                y += size.height + 8
            }

            func drawPage() {
                context.beginPage()
                yPosition = margin

                // Only show image on first page
                if isFirstPage, let image = donationImage {


                    let aspectRatio = image.size.width / image.size.height
                    var width = imageMaxSize
                    var height = imageMaxSize

                    if aspectRatio > 1 {
                        height = imageMaxSize / aspectRatio
                    } else {
                        width = imageMaxSize * aspectRatio
                    }

                    let x = (pageWidth - width) / 2
                    image.draw(in: CGRect(x: x, y: yPosition, width: width, height: height))
                    yPosition += height + 20

                    isFirstPage = false
                }

                let title = "DONATION REPORT"
                let titleAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 22),
                    .foregroundColor: greenColor
                ]

                let titleSize = (title as NSString).size(withAttributes: titleAttrs)
                let titleX = (pageWidth - titleSize.width) / 2
                (title as NSString).draw(at: CGPoint(x: titleX, y: yPosition), withAttributes: titleAttrs)
                yPosition += titleSize.height + 20

                drawHeader("▶ BASIC INFORMATION", y: &yPosition)

                let df = DateFormatter()
                df.dateStyle = .medium

                drawText("Donation ID: #\(donation.donationID)", y: &yPosition)
                drawText("NGO Name: \(donation.ngo.organization_name ?? donation.ngo.username)", y: &yPosition)
                drawText("Donor Username: \(donation.donor.username)", y: &yPosition)
                df.dateFormat = "dd MMM yyyy, hh:mm a" // day month year, hour:minute AM/PM

                drawText("Created On: \(df.string(from: donation.creationDate.dateValue()))", y: &yPosition)
                drawText("Status: \(statusText(for: donation.status))", y: &yPosition)

                drawHeader("▶ DONATION DETAILS", y: &yPosition)
                drawText("Category: \(donation.category)", y: &yPosition)
                drawText("Quantity: \(donation.quantity)", y: &yPosition)
                if let weight = donation.weight {
                    drawText("Weight: \(weight) kg", y: &yPosition)
                }
                if let desc = donation.description, !desc.isEmpty {
                    drawText("Description: \(desc)", y: &yPosition)
                }
                if let rejection = donation.rejectionReason, !rejection.isEmpty {
                    drawText("Rejection Reason: \(rejection)", y: &yPosition)
                }

                drawHeader("▶ PICKUP INFORMATION", y: &yPosition)
                drawText("Pickup Date: \(df.string(from: donation.pickupDate.dateValue()))", y: &yPosition)
                drawText("Pickup Time: \(donation.pickupTime)", y: &yPosition)

                drawHeader("▶ ADDRESS", y: &yPosition)
                let a = donation.address
                drawText("Building: \(a.building)", y: &yPosition)
                drawText("Road: \(a.road)", y: &yPosition)
                drawText("Block: \(a.block)", y: &yPosition)
                drawText("Area: \(a.area)", y: &yPosition)
                drawText("Governorate: \(a.governorate)", y: &yPosition)
                if let flat = a.flat {
                    drawText("Flat: \(flat)", y: &yPosition)
                }

                drawHeader("▶ EXPIRY", y: &yPosition)
                drawText("Expiry Date: \(df.string(from: donation.expiryDate.dateValue()))", y: &yPosition)

                if donation.recurrence > 0 {
                    drawHeader("▶ RECURRENCE", y: &yPosition)
                    drawText("Every \(donation.recurrence) days", y: &yPosition)
                }

                drawLine(at: yPosition)
                yPosition += 8
                drawText("Generated On: \(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short))", y: &yPosition)
                drawText("ProjectSimulator App", y: &yPosition, font: .boldSystemFont(ofSize: 14))
            }

            drawPage()
        }

        return data
    }

    
    private func loadImageSync(from urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }

        let semaphore = DispatchSemaphore(value: 0)
        var loadedImage: UIImage?

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                loadedImage = UIImage(data: data)
            }
            semaphore.signal()
        }.resume()

        semaphore.wait()
        return loadedImage
    }
    
    
    
    
    private func preloadDonationImage() {
        guard let urlString = donation?.foodImageUrl, let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.donationImage = image
                }
            } else {
                print("Failed to load donation image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editDonationSegue",
           let editVC = segue.destination as? EditDonationViewController {
            editVC.donation = self.donation

            // Set closure to refresh when returning
            editVC.onDonationUpdated = { [weak self] updatedDonation in
                guard let self = self else { return }

                // 1) Update local donation
                self.donation = updatedDonation

                // 2) Reload table view and image
                self.preloadDonationImage() // if you have a method for image loading
                self.donationTableview.reloadData()
            }
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


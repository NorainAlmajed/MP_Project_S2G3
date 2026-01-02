//import UIKit
//
//extension DonationViewController {
//
//    // MARK: - Dashboard → Donation Details
//
//    // Store the donation to open
//    static var pendingDonationID: String?
//
//    // Call once in viewDidLoad
//    func enableDashboardDonationNavigation() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(handleDashboardDonationOpen),
//        //    name: .openPendingDonations,
//            object: nil
//        )
//    }
//
//    @objc private func handleDashboardDonationOpen(_ notification: Notification) {
//        // Expect the firestoreID to be sent as notification.object
//        guard let firestoreID = notification.object as? String else { return }
//
//        DonationViewController.pendingDonationID = firestoreID
//    }
//
//    // Call AFTER donations load
//    func tryOpenPendingDonationIfPossible() {
//        guard
//            let firestoreID = DonationViewController.pendingDonationID,
//            let index = displayedDonations.firstIndex(where: { $0.firestoreID == firestoreID })
//        else { return }
//
//        DonationViewController.pendingDonationID = nil
//
//        let indexPath = IndexPath(item: index, section: 0)
//
//        // Select cell exactly like user tap
//        donationsCollectionView.selectItem(
//            at: indexPath,
//            animated: false,
//            scrollPosition: .centeredVertically
//        )
//
//        // Trigger Zahra’s storyboard segue
//        performSegue(withIdentifier: "showDonationDetails", sender: self)
//    }
//}

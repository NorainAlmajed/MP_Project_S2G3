/*import UIKit
import FirebaseFirestore

extension DonationViewController {

    // MARK: - Dashboard → Donation Details bridge
    private static var pendingDonationID: String?

    func enableDashboardDonationNavigation() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDashboardDonationOpen(_:)),
            name: .openDonationDetailsFromDashboard,
            object: nil
        )
    }

    @objc private func handleDashboardDonationOpen(_ notification: Notification) {
        print("🔥 DASHBOARD NOTIFICATION RECEIVED")

        guard
            let userInfo = notification.userInfo,
            let firestoreID = userInfo["firestoreID"] as? String
        else {
            print("❌ No firestoreID")
            return
        }

        print("🔥 Pending donation ID:", firestoreID)

        DonationViewController.pendingDonationID = firestoreID
        tryOpenPendingDonationIfPossible()
    }

    func tryOpenPendingDonationIfPossible() {
        print("🟡 tryOpenPendingDonationIfPossible CALLED")
        print("🟡 displayedDonations count:", displayedDonations.count)

        guard
            let firestoreID = DonationViewController.pendingDonationID
        else {
            print("❌ No pendingDonationID")
            return
        }

        print("🟡 Looking for donation with ID:", firestoreID)

        guard let index = displayedDonations.firstIndex(where: {
            $0.firestoreID == firestoreID
        }) else {
            print("❌ Donation NOT FOUND in displayedDonations")
            return
        }

        print("✅ Donation FOUND at index:", index)

        DonationViewController.pendingDonationID = nil

        let indexPath = IndexPath(item: index, section: 0)

        donationsCollectionView.selectItem(
            at: indexPath,
            animated: false,
            scrollPosition: .centeredVertically
        )

        print("✅ Cell selected, performing segue")

        performSegue(withIdentifier: "showDonationDetails", sender: self)
    }


  


    private func openDonationDetailsSafely(_ donation: Donation) {
        let storyboard = UIStoryboard(name: "Donations", bundle: nil)

        guard let detailsVC =
            storyboard.instantiateViewController(
                withIdentifier: "DonationDetailsViewController"
            ) as? DonationDetailsViewController
        else {
            print("❌ DonationDetailsViewController not found")
            return
        }

        detailsVC.donation = donation
        detailsVC.currentUser = self.currentUser

        navigationController?.pushViewController(detailsVC, animated: true)
    }
}*/

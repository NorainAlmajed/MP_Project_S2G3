import UIKit
import FirebaseAuth
import FirebaseFirestore

class NotificationSettingsViewController: UIViewController {

    @IBOutlet weak var realtimeNotificationSwitch: UISwitch!

    let db = Firestore.firestore()

    // Track last confirmed value
    var previousSwitchState: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notification Settings"
        loadSetting()
    }

    // MARK: - Load setting
    func loadSetting() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).getDocument { snapshot, _ in
            let data = snapshot?.data()

            DispatchQueue.main.async {
                let isOn = data?["realtime_notifications"] as? Bool ?? true
                self.realtimeNotificationSwitch.isOn = isOn
                self.previousSwitchState = isOn
            }
        }
    }

    // MARK: - Switch toggle with confirmation
    @IBAction func realtimeSwitchChanged(_ sender: UISwitch) {

        let newValue = sender.isOn
        let actionText = newValue ? "enable" : "disable"

        let alert = UIAlertController(
            title: "Confirm",
            message: "Are you sure you want to \(actionText) real-time notifications?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // Revert to previous confirmed state
            sender.setOn(self.previousSwitchState, animated: true)
        })

        alert.addAction(UIAlertAction(title: "Confirm", style: .default) { _ in
            // Accept change
            self.previousSwitchState = newValue
            self.saveSetting()
        })

        present(alert, animated: true)
    }

    func saveSetting() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users")
            .document(uid)
            .updateData([
                "realtime_notifications": realtimeNotificationSwitch.isOn
            ])
    }
}

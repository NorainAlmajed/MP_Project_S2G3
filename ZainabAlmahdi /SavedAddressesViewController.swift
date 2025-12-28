import UIKit
import FirebaseAuth
import FirebaseFirestore

class SavedAddressesViewController: UITableViewController {

    struct Address {
        let id: String
        let label: String
        let address: String
    }

    var addresses: [Address] = []
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Saved Addresses"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addAddressTapped)
        )

        fetchAddresses()
    }

    // MARK: - Fetch
    func fetchAddresses() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users")
            .document(uid)
            .collection("addresses")
            .getDocuments { snapshot, error in

                if let error = error {
                    print(error.localizedDescription)
                    return
                }

                self.addresses = snapshot?.documents.map {
                    Address(
                        id: $0.documentID,
                        label: $0["label"] as? String ?? "",
                        address: $0["address"] as? String ?? ""
                    )
                } ?? []

                self.tableView.reloadData()
            }
    }

    // MARK: - Add Address
    @objc func addAddressTapped() {
        let alert = UIAlertController(
            title: "New Address",
            message: "Enter address details",
            preferredStyle: .alert
        )

        alert.addTextField { $0.placeholder = "Label (e.g. Home)" }
        alert.addTextField { $0.placeholder = "Full Address" }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            let label = alert.textFields?[0].text ?? ""
            let address = alert.textFields?[1].text ?? ""
            self.saveAddress(label: label, address: address)
        })

        present(alert, animated: true)
    }

    func saveAddress(label: String, address: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users")
            .document(uid)
            .collection("addresses")
            .addDocument(data: [
                "label": label,
                "address": address
            ]) { _ in
                self.fetchAddresses()
            }
    }

    // MARK: - Table Data Source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        addresses.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "AddressCell",
            for: indexPath
        )

        let address = addresses[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(address.label)\n\(address.address)"

        return cell
    }

    // MARK: - Delete
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            deleteAddress(at: indexPath)
        }
    }

    func deleteAddress(at indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let addressId = addresses[indexPath.row].id

        db.collection("users")
            .document(uid)
            .collection("addresses")
            .document(addressId)
            .delete { _ in
                self.addresses.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
    }
}

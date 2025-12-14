//
//  RaghadDonorListViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 14/12/2025.
//


//
//  RaghadDonorListViewController.swift
//  ProjectSimulator
//

import UIKit

protocol DonorSelectionDelegate: AnyObject {
    func didSelectDonor(name: String)
}

class RaghadDonorListViewController: UIViewController,
                                    UITableViewDelegate,
                                    UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    // ✅ NEW: Get donors from your shared data file (arrDonors)
    // Make sure arrDonors exists in your "Raghad file"
    private let donors: [User] = users

    weak var delegate: DonorSelectionDelegate?

    private var selectedIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Choose Donor"

        tableView.delegate = self
        tableView.dataSource = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneTapped)
        )
    }

    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donors.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "DonorCell", for: indexPath)

        // ✅ CHANGED: donor is a struct, so show username
        cell.textLabel?.text = donors[indexPath.row].username

        // ✅ checkmark on selected row
        cell.accessoryType = (indexPath == selectedIndex) ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        selectedIndex = indexPath
        tableView.reloadData()
    }

    // MARK: - Actions

    @objc func cancelTapped() {
        dismiss(animated: true)
    }

    @objc func doneTapped() {
        guard let index = selectedIndex else { return }

        // ✅ CHANGED: send back username
        delegate?.didSelectDonor(name: donors[index.row].username)

        dismiss(animated: true)
    }
}

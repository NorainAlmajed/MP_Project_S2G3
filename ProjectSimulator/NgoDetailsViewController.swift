//
//  NgoDetailsViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 12/12/2025.
//

import UIKit

//class NgoDetailsViewController: UIViewController {
class NgoDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var selectedNgo: NGO?

    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NGO Details"

        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

        // Bottom line under navigation bar
        navigationController?.navigationBar.shadowImage = UIImage()

        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.systemGray4
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        navigationController?.navigationBar.addSubview(bottomLine)

        NSLayoutConstraint.activate([
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
            bottomLine.leadingAnchor.constraint(equalTo: navigationController!.navigationBar.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: navigationController!.navigationBar.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor)
        ])

        // Hide back text
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        
        
        
        
        tableView.cellLayoutMarginsFollowReadableWidth = false
          tableView.layoutMargins = .zero
          tableView.separatorInset = .zero

          // Optional but helpful
          tableView.insetsContentViewsToSafeArea = false
        
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
        tableView.directionalLayoutMargins = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        
        
        
        
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground

        
        
    }

    // MARK: - TableView DataSource

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 4 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let ngo = selectedNgo else { return UITableViewCell() }

        switch indexPath.row {

        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NgoHeaderCell", for: indexPath) as! RaghadNgoDetailsHeaderTableViewCell
            cell.configure(ngo: ngo)
            cell.selectionStyle = .none
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NgoMissionCell", for: indexPath) as! RaghadNgoDetailsMissionTableViewCell
            cell.configure(mission: ngo.mission)
            cell.selectionStyle = .none
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NgoContactCell", for: indexPath) as! RaghadNgoDetailsContactTableViewCell
            cell.configure(phone: ngo.phoneNumber, email: ngo.email)
            cell.selectionStyle = .none
            return cell

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NgoActionsCell", for: indexPath) as! RaghadNgoDetailsNgoActionsTableViewCell

            cell.onDonateTapped = { [weak self] in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "toDonationForm", sender: nil)
            }

            cell.onChatTapped = {
                // TODO: open chat page / action
            }

            cell.selectionStyle = .none
            return cell
        }
    }

    // MARK: - Row Heights (like your other page)

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 251                       // Header
        case 1: return 211
        case 2: return 155                      // Contact
        case 3: return 130                      // Buttons
        default: return UITableView.automaticDimension
        }
    }

    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDonationForm" {
//            // If you want to pass NGO to donation form, uncomment and change VC name if needed:
//            // let vc = segue.destination as! RaghadDonatoinFormViewController
//            // vc.selectedNgo = selectedNgo
//        }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDonationForm" {
            let vc = segue.destination as! RaghadDonatoinFormViewController
            vc.selectedNgo = selectedNgo
        }
    }

    
    
    
    
    }


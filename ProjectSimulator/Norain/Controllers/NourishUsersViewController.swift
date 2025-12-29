//
//  NourishUsersViewController.swift
//  ProjectSimulator
//
//  Created by Norain  on 23/12/2025.
//

import UIKit
import FirebaseFirestore

class NourishUsersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate
{

  
    @IBOutlet weak var searchUsers: UISearchBar!
    @IBOutlet weak var NavBar: UINavigationItem!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var segmentUsers: UISegmentedControl!
    @IBOutlet weak var btnPending: UIButton!
    @IBOutlet weak var btnApproved: UIButton!
    @IBOutlet weak var btnRejected: UIButton!
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    var users: [NorainAppUser] = []
    var displayedUsers : [NorainAppUser] = []
    var ngoBeingProcessed: NorainNGO?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonStyles()
        fetchUsersFromFirestore()
        searchUsers.delegate = self
        self.displayedUsers = self.users
        setButtonsHidden(false)
        
        self.usersTableView.reloadData()
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    private func fetchUsersFromFirestore() {
        // We listen to the "users" collection (adjust name if your collection is different)
        listener = db.collection("users").addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching users: \(error)")
                return
            }
            
            self.db.collection("users").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else { return }
                
                self.users = documents.compactMap { document -> NorainAppUser? in
                    let data = document.data()

                    let docID = document.documentID
                    
                    let role = data["role"] as? Int ?? 0
                    
                    // 2. Pass that ID into your initializer
                    if role == 3 {
                        return NorainNGO(documentID: docID, dictionary: data)
                    } else if role == 2 {
                        return NorainDonor(documentID: docID, dictionary: data)
                    }
                    return nil
                }
                DispatchQueue.main.async {
                            self.applyCurrentFilters()
                        }
            }
        }
    }
    
    private func applyCurrentFilters() {
        let searchText = searchUsers.text?.lowercased() ?? ""
        
        // Filter by Segment
        var filtered = users
        switch segmentUsers.selectedSegmentIndex {
        case 1: filtered = users.filter { $0 is NorainNGO }
        case 2: filtered = users.filter { $0 is NorainDonor }
        default: break
        }
        if !searchText.isEmpty {
                    filtered = filtered.filter { $0.name.lowercased().contains(searchText) }
                }
                
                self.displayedUsers = filtered
                self.usersTableView.reloadData()
    }
    func createAcceptAction(for ngo: NorainNGO, indexPath: IndexPath) -> UIContextualAction {
            let action = UIContextualAction(style: .normal, title: "Accept") { [weak self] (_, _, completionHandler) in
                self?.db.collection("users").document(ngo.documentID).updateData([
                    "status": NGOStatus.approved.rawValue
                ]) { error in
                    completionHandler(error == nil)
                }
            }
            action.backgroundColor = .greenCol
            return action
        }

        func deleteUserFromFirestore(user: NorainAppUser, indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
            // ⭐ Delete from Firestore
            db.collection("users").document(user.documentID).delete { error in
                if let error = error {
                    print("Error removing document: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }

        

        // MARK: - Helper Mappers (Matches your JSON fields)
    private func mapToNGO(documentID: String,data: [String: Any]) -> NorainNGO {
        return NorainNGO(documentID: documentID, dictionary: data)    }

    private func mapToDonor(documentID: String,data: [String: Any]) -> NorainDonor {
        return NorainDonor(documentID: documentID, dictionary: data)
    }
    
    private func setupButtonStyles() {
        let buttons = [btnPending, btnApproved, btnRejected]
        
        for button in buttons {
            guard let btn = button else { continue }
            
            // Make capsule shape
            btn.layer.cornerRadius = btn.frame.height / 2
            btn.clipsToBounds = true
            
            btn.setBackgroundImage(nil, for: .normal)
                    btn.setBackgroundImage(nil, for: .highlighted)
                    
                    // Set custom styling
                    btn.backgroundColor = .white
                    btn.layer.borderWidth = 2
            btn.layer.borderColor = UIColor(named: "greenCol")?.cgColor
            btn.setTitleColor(UIColor(named: "greenCol"), for: .normal)
            // Green stroke, white fill, green text (default state)
            btn.backgroundColor = .white
            btn.layer.borderWidth = 2
            btn.layer.borderColor = UIColor(named: "greenCol")?.cgColor
            btn.setTitleColor(UIColor(named: "greenCol"), for: .normal)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Determine the current filter based on Segmented Control
        let currentSegmentList: [NorainAppUser]
        switch segmentUsers.selectedSegmentIndex {
        case 1: currentSegmentList = users.filter { $0 is NorainNGO }
        case 2: currentSegmentList = users.filter { $0 is NorainDonor }
        default: currentSegmentList = users
        }

        if searchText.isEmpty {
            displayedUsers = currentSegmentList
        } else {
            displayedUsers = currentSegmentList.filter { user in
                user.name.lowercased().contains(searchText.lowercased())
            }
        }
        usersTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Hides keyboard
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        displayedUsers = users
        searchBar.resignFirstResponder()
        usersTableView.reloadData()
    }
    @objc func dismissKeyboard() {

        view.endEditing(true)
    }
    
    @IBAction func SegDidChange(_ sender: UISegmentedControl) {
        resetFilterButtonColors()
        switch sender.selectedSegmentIndex {
        case 1:
            // NGO Segment selected
            displayedUsers = users.filter({ $0 is NorainNGO })
            setButtonsHidden(true) // Show buttons
            NavBar.title = "Nourish NGOs"
        case 2:
            // Donor Segment selected
            displayedUsers = users.filter({ $0 is NorainDonor })
            setButtonsHidden(false) // Hide buttons
            NavBar.title = "Nourish Donors"
        case 0:
            // All
            displayedUsers = users
            setButtonsHidden(false) // Hide buttons
            NavBar.title = "Nourish Users"
        case UISegmentedControl.noSegment:
            displayedUsers = users
            setButtonsHidden(false)
            NavBar.title = "Nourish Users"
            
        default:
            // Handles any other unexpected index
            setButtonsHidden(false)
        }
        
        usersTableView.reloadData()
    }
    
    
    func setButtonsHidden(_ hidden: Bool) {
        btnPending.isHidden = !hidden
        btnApproved.isHidden = !hidden
        btnRejected.isHidden = !hidden
        
        // Also toggle interaction to be safe
        btnPending.isEnabled = hidden
        btnApproved.isEnabled = hidden
        btnRejected.isEnabled = hidden
    }
    
    private func resetFilterButtonColors() {
         let buttons = [btnPending, btnApproved, btnRejected]
             
             for button in buttons {
                 guard let btn = button else { continue }
                 
                 var config = btn.configuration ?? UIButton.Configuration.filled()
                 config.background.backgroundColor = .white
                 config.baseForegroundColor = .greenCol
                 config.background.strokeColor = .greenCol
                 config.background.strokeWidth = 2
                 btn.configuration = config
             }
     }
    
    @IBAction func btnPendingFilter(_ sender: Any) {
        resetFilterButtonColors()
           
           var config = btnPending.configuration ?? UIButton.Configuration.filled()
           config.background.backgroundColor = UIColor(named: "greenCol")
           config.baseForegroundColor = .white
           config.background.strokeWidth = 0
           btnPending.configuration = config
           
           displayedUsers = users.compactMap { $0 as? NorainNGO }.filter { $0.status == .pending }
           usersTableView.reloadData()
    }
    
    @IBAction func btnApprovedFilter(_ sender: Any) {
        resetFilterButtonColors()
           
           var config = btnApproved.configuration ?? UIButton.Configuration.filled()
           config.background.backgroundColor = UIColor(named: "greenCol")
           config.baseForegroundColor = .white
           config.background.strokeWidth = 0
           btnApproved.configuration = config
           
        displayedUsers = users.compactMap { $0 as? NorainNGO }.filter { $0.status == .approved }
           usersTableView.reloadData()
    }
    
    
    @IBAction func btnRejectedFilter(_ sender: Any) {
        resetFilterButtonColors()
           
           var config = btnRejected.configuration ?? UIButton.Configuration.filled()
           config.background.backgroundColor = UIColor(named: "greenCol")
           config.baseForegroundColor = .white
           config.background.strokeWidth = 0
           btnRejected.configuration = config
           
        displayedUsers = users.compactMap { $0 as? NorainNGO }.filter { $0.status == .rejected }
           usersTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update corner radius after layout (ensures correct capsule shape)
        btnPending?.layer.cornerRadius = btnPending.frame.height / 2
        btnApproved?.layer.cornerRadius = btnApproved.frame.height / 2
        btnRejected?.layer.cornerRadius = btnRejected.frame.height / 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersTableView.dequeueReusableCell(withIdentifier: Cell.UserCell.rawValue, for: indexPath) as! UserTableViewCell
        
        let user = displayedUsers[indexPath.row]
        cell.configure(appUser: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedUser = displayedUsers[indexPath.row]
        if let detailsVC = storyboard?.instantiateViewController(withIdentifier: "UserDetailsViewController") as? UserDetailsViewController {
            detailsVC.currentUser = selectedUser
            detailsVC.delegate = self
            self.present(detailsVC, animated: true)
            detailsVC.modalPresentationStyle = .pageSheet
            
            self.present(detailsVC, animated: true) {
                detailsVC.configure(appUser: selectedUser)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let user = users[indexPath.row]
        let ngo = user as? NorainNGO
        let userToRemove = self.displayedUsers[indexPath.row]
                
                let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completionHandler in
                    Alerts.confirmation(on: self!, title: "Delete", message: "Confirm removal?") {
                        self?.deleteUserFromFirestore(user: userToRemove, indexPath: indexPath) { success in
                            completionHandler(success)
                        }
            }
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            let storyboard = UIStoryboard(name: "norain-admin-controls1", bundle: nil)
                let editVC = storyboard.instantiateViewController(withIdentifier: "EditUsersViewController") as! EditUsersViewController
                
              
                editVC.userToEdit = self.displayedUsers[indexPath.row]
                editVC.delegate = self
                
                let nav = UINavigationController(rootViewController: editVC)
                self.present(nav, animated: true)
                completionHandler(true)
            
        }
        editAction.backgroundColor = UIColor(named: "blueCol")
        
        var actions: [UIContextualAction] = [editAction,deleteAction]
        
        
        if let ngo = ngo {
            if ngo.status == .pending {
                // Show both Accept and Reject
                actions.append(createAcceptAction(for: ngo, indexPath: indexPath))
                actions.append(createRejectAction(for: ngo, indexPath: indexPath))
            } else if ngo.status == .rejected {
                // Show only Accept
                actions.append(createAcceptAction(for: ngo, indexPath: indexPath))
            }
        }
        
        let configuration = UISwipeActionsConfiguration(actions: actions)
        return configuration
    }
    
    
    //create Reject Action
    func createRejectAction(for ngo: NorainNGO, indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Reject") { (_, _, completionHandler) in
                // Save the NGO so the delegate knows which one to update later
                self.ngoBeingProcessed = ngo
                self.showRejectionPopup()
                completionHandler(true)
            }
            action.backgroundColor = .red
            return action
    }
    
    func showRejectionPopup() {
        let storyboard = UIStoryboard(name: "norain-admin-controls1", bundle: nil)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: "RejectionPopupViewController") as? RejectionPopupViewController {
            popupVC.delegate = self
            popupVC.modalPresentationStyle = .pageSheet
            popupVC.modalTransitionStyle = .crossDissolve // Smoother appearance
            self.present(popupVC, animated: true)
        }
    }
        

    }
extension NourishUsersViewController: UserUpdateDelegate {
    func didUpdateUser() {
        DispatchQueue.main.async
        {
            self.usersTableView.reloadData()
        }
    }
}
// 1. Add the protocol conformance here
extension NourishUsersViewController: RejectionDelegate {
    
    func didProvideReason(_ reason: String) {
        if let ngo = self.ngoBeingProcessed {
            let finalReason = reason.isEmpty ? "No specific reason provided." : reason
            
            // Update Firestore with the rejection status and reason
            db.collection("users").document(ngo.documentID).updateData([
                "status": NGOStatus.rejected.rawValue,
                "rejectionReason": finalReason
            ]) { [weak self] error in
                if let error = error {
                    print("Error updating rejection: \(error.localizedDescription)")
                } else {
                    print("Successfully rejected \(ngo.name)")
                }
                
                // Reset and refresh UI
                self?.ngoBeingProcessed = nil
                self?.usersTableView.reloadData()
            }
        }
    }
}
extension NourishUsersViewController: EditUserDelegate {
    func didEditUser() {

        self.fetchUsersFromFirestore()

    }
}

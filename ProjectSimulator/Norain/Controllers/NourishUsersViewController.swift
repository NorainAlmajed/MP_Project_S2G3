//
//  NourishUsersViewController.swift
//  ProjectSimulator
//
//  Created by Norain  on 23/12/2025.
//

import UIKit

class NourishUsersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate
{

  
    @IBOutlet weak var searchUsers: UISearchBar!
    var users = AppData.users
    var displayedUsers = AppData.users
    var ngoBeingProcessed: NGO?
    @IBOutlet weak var NavBar: UINavigationItem!
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var segmentUsers: UISegmentedControl!
    @IBOutlet weak var btnPending: UIButton!
    @IBOutlet weak var btnApproved: UIButton!
    @IBOutlet weak var btnRejected: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchUsers.delegate = self
        self.displayedUsers = self.users
        setButtonsHidden(false)
        self.usersTableView.reloadData()
        usersTableView.delegate = self
        usersTableView.dataSource = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        setupButtonStyles()

        
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
        let currentSegmentList: [AppUser]
        switch segmentUsers.selectedSegmentIndex {
        case 1: currentSegmentList = users.filter { $0 is NGO }
        case 2: currentSegmentList = users.filter { $0 is Donor }
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
            displayedUsers = users.filter({ $0 is NGO })
            setButtonsHidden(true) // Show buttons
            NavBar.title = "Nourish NGOs"
        case 2:
            // Donor Segment selected
            displayedUsers = users.filter({ $0 is Donor })
            setButtonsHidden(false) // Hide buttons
            NavBar.title = "Nourish Donors"
        case 0:
            // All
            displayedUsers = users
            setButtonsHidden(false) // Hide buttons
            NavBar.title = "Nourish Users"
        case UISegmentedControl.noSegment:
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
           
           displayedUsers = users.compactMap { $0 as? NGO }.filter { $0.status == .pending }
           usersTableView.reloadData()
    }
    
    @IBAction func btnApprovedFilter(_ sender: Any) {
        resetFilterButtonColors()
           
           var config = btnApproved.configuration ?? UIButton.Configuration.filled()
           config.background.backgroundColor = UIColor(named: "greenCol")
           config.baseForegroundColor = .white
           config.background.strokeWidth = 0
           btnApproved.configuration = config
           
        displayedUsers = users.compactMap { $0 as? NGO }.filter { $0.status == .approved }
           usersTableView.reloadData()
    }
    
    
    @IBAction func btnRejectedFilter(_ sender: Any) {
        resetFilterButtonColors()
           
           var config = btnRejected.configuration ?? UIButton.Configuration.filled()
           config.background.backgroundColor = UIColor(named: "greenCol")
           config.baseForegroundColor = .white
           config.background.strokeWidth = 0
           btnRejected.configuration = config
           
        displayedUsers = users.compactMap { $0 as? NGO }.filter { $0.status == .rejected }
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
        let ngo = user as? NGO
        
        let storyboard = UIStoryboard(name: "norain-admin-controls1", bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: "EditUsersViewController") as! EditUsersViewController
        let nav = UINavigationController(rootViewController: editVC)
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            
            Alerts.confirmation(on: self, title: "Delete Confirmation", message: "Are you sure you want to remove User?") {
                
                // 1. Get the specific user from the displayed list
                let userToRemove = self.displayedUsers[indexPath.row]
                
                // 2. Remove from the list the TableView is currently using (CRITICAL FIX)
                self.displayedUsers.remove(at: indexPath.row)
                
                // 3. Remove from the other lists by matching the ID
                self.users.removeAll { $0.userName == userToRemove.userName }
                AppData.users.removeAll { $0.userName == userToRemove.userName }
                
                // 4. Update the UI
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                completionHandler(true)
            }
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            let storyboard = UIStoryboard(name: "norain-admin-controls1", bundle: nil)
                let editVC = storyboard.instantiateViewController(withIdentifier: "EditUsersViewController") as! EditUsersViewController
                
              
                editVC.userToEdit = self.displayedUsers[indexPath.row]
                
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
    
    //create Accept Action
    func createAcceptAction(for ngo: NGO, indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Accept") { (_, _, completionHandler) in
            ngo.status = .approved
            self.usersTableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        action.backgroundColor = UIColor(named: "greenCol")
        return action
    }
    
    //create Reject Action
    func createRejectAction(for ngo: NGO, indexPath: IndexPath) -> UIContextualAction {
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
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
extension NourishUsersViewController: UserUpdateDelegate {
    func didUpdateUser() {
        DispatchQueue.main.async
        {
            self.usersTableView.reloadData()
        }
    }
}
extension NourishUsersViewController: RejectionDelegate {
    func didProvideReason(_ reason: String) {
        if let ngo = self.ngoBeingProcessed {
            ngo.status = .rejected
            
            // If the user left it empty, maybe provide a default
            ngo.rejectionReason = reason.isEmpty ? "No specific reason provided." : reason
            
            self.usersTableView.reloadData()
            self.ngoBeingProcessed = nil // Reset for the next use
            
            print("Successfully rejected \(ngo.name) for: \(reason)")
        }
    }
}

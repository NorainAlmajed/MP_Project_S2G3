//
//  NourishUsersViewController.swift
//  ProjectSimulator
//
//  Created by Norain  on 23/12/2025.
//

import UIKit

class NourishUsersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

  
    @IBOutlet weak var searchUsers: UISearchBar!
    var users = AppData.users
    var displayedUsers = AppData.users
    @IBOutlet weak var NavBar: UINavigationItem!
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var segmentUsers: UISegmentedControl!
    @IBOutlet weak var btnPending: UIButton!
    @IBOutlet weak var btnApproved: UIButton!
    @IBOutlet weak var btnRejected: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayedUsers = self.users
        setButtonsHidden(false)
        self.usersTableView.reloadData()
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
    }
    
    
    
    @IBAction func SegDidChange(_ sender: UISegmentedControl) {
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
    
    
    @IBAction func btnPendingFilter(_ sender: Any) {
        displayedUsers = users.compactMap { $0 as? NGO }.filter { $0.isPending }
        usersTableView.reloadData()
    }
    
    @IBAction func btnApprovedFilter(_ sender: Any) {
        displayedUsers = users.compactMap { $0 as? NGO }.filter { $0.isApproved }
        usersTableView.reloadData()
    }
    
    
    @IBAction func btnRejectedFilter(_ sender: Any) {
        displayedUsers = users.compactMap { $0 as? NGO }.filter { $0.isRejected }
        usersTableView.reloadData()
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
        let selectedUser = users[indexPath.row]
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
            
            Alerts.confirmation(on: self, title: "Delete Confirmation", message: "Are you sure you want to remove User?"){
                self.users.remove(at: indexPath.row)
                AppData.users.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                completionHandler(true)
            }
            
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            self.showDetailViewController(nav, sender: view)
            completionHandler(true)
        }
        editAction.backgroundColor = .blueCol
        
        var actions: [UIContextualAction] = [editAction,deleteAction]
        
        
        if let ngo = ngo {
            if ngo.isPending {
                // Show both Accept and Reject
                actions.append(createAcceptAction(for: ngo, indexPath: indexPath))
                actions.append(createRejectAction(for: ngo, indexPath: indexPath))
            } else if ngo.isRejected {
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
            ngo.isPending = false
            ngo.isApproved = true
            ngo.isRejected = false
            self.usersTableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        action.backgroundColor = .greenCol
        return action
    }
    
    //create Reject Action
    func createRejectAction(for ngo: NGO, indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Reject") { (_, _, completionHandler) in
            ngo.isPending = false
            ngo.isApproved = false
            ngo.isRejected = true
            self.usersTableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        action.backgroundColor = .redCol
        return action
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

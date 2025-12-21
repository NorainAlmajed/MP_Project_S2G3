//
//  UsersTableViewController.swift
//  ProjectSimulator
//
//  Created by Norain  on 18/12/2025.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    var users = AppData.users
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.UserCell.rawValue, for: indexPath) as! UserTableViewCell

        let user = users[indexPath.row]
        cell.configure(appUser: user)
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Default fallback
            return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let user = users[indexPath.row]
        let ngo = user as? NGO
        
        let storyboard = UIStoryboard(name: "norain-admin-controls1", bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: "EditUsersViewController") as! EditUsersViewController
        let nav = UINavigationController(rootViewController: editVC)
        

        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            self.showDetailViewController(nav, sender: view)
            completionHandler(true)
        }
        editAction.backgroundColor = .blueCol
        
        var actions: [UIContextualAction] = [editAction]
        

        if let ngo = ngo {
            if ngo.IsPending {
                // Show both Accept and Reject
                actions.append(createAcceptAction(for: ngo, indexPath: indexPath))
                actions.append(createRejectAction(for: ngo, indexPath: indexPath))
            } else if ngo.IsRejected {
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
            ngo.IsPending = false
            ngo.IsApproved = true
            ngo.IsRejected = false
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        action.backgroundColor = .greenCol
        return action
    }

    //create Reject Action
    func createRejectAction(for ngo: NGO, indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Reject") { (_, _, completionHandler) in
            ngo.IsPending = false
            ngo.IsApproved = false
            ngo.IsRejected = true
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        action.backgroundColor = .redCol
        return action
    }

    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            confirmation(title: "Delete Confirmation", message: "Are you sure you want to remove User?"){
                self.users.remove(at: indexPath.row)
                AppData.users.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

        }
    }
    
    func confirmation(title:String, message:String,confirmHandler: @escaping() ->Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default){action in
                confirmHandler()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

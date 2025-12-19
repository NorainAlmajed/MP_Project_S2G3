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
        let user = users[indexPath.row]
            
            //Logic for NGO
            if let ngo = user as? NGO {
                if ngo.IsPending{
                    return false // Cannot edit if pending
                } else if ngo.IsApproved || ngo.IsRejected {
                    return true // Can edit if approved or rejected
                }
            }

            // Default fallback
            return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmation(title: "Delete Confirmation", message: "Are you sure you want to remove User?"){
                self.users.remove(at: indexPath.row)
                AppData.users.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

        } else if editingStyle == .insert {

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

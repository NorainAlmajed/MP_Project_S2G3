//
//  NgoViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 11/12/2025.
//

import UIKit

class NgoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNgo.count //to know thet the number of the cells is the same number of the items in the array 'arrNgo'
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NgoCell") as! NgoTableTableViewCell
        
        let data = arrNgo[indexPath.row]
        
        cell.setupCell(photo: data.photo, name: data.name, category: data.category)//setupCell form NgoTableViewController

        return cell
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NgoCell", for: indexPath) as! NgoTableTableViewCell
//        let data = arrNgo[indexPath.row]
//        cell.setupCell(photo: data.photo, name: data.name, category: data.category)
//        return cell
//    }

    

    
    //to edit the height of the row 
           func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true) // added this  to deselect row
        print("cell index = \(indexPath.row)") // to show the index of the cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNgoDetails" {
            let vc = segue.destination as! NgoDetailsViewController

            if let indexPath = tableView.indexPathForSelectedRow {
                vc.selectedNgo = arrNgo[indexPath.row]
            }
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

//
//  NgoViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 11/12/2025.
//

import UIKit

class NgoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    // ✅🆕 1) Empty state label (when there are no NGOs)
    private let noNgosLabel: UILabel = {
        let label = UILabel()
        label.text = "No NGOs available"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.isHidden = true
        return label
    }()

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        
        // ✅🆕 3) Add empty label to the screen
        view.addSubview(noNgosLabel)
        noNgosLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noNgosLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNgosLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        // ✅🆕 4) Run the method once at start
        updateNoNgosLabel()

        

            title = "Browse NGOs"

            // إزالة الخط الافتراضي (إن وُجد)
            navigationController?.navigationBar.shadowImage = UIImage()

            // خط أسفل الـ Navigation Bar
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
        
        
        
        
        // ✅⬅️🆕 Hide back button text for the NEXT screen (NgoDetails)
           if #available(iOS 14.0, *) {
               navigationItem.backButtonDisplayMode = .minimal
           } else {
               navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
           }

           title = "Browse NGOs"
    }
    
    
    // ✅🆕 5) Refresh the table + empty label whenever the page appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateNoNgosLabel()
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

    // ✅🆕 2) Show label if the list is empty
    private func updateNoNgosLabel() {
        if arrNgo.isEmpty {
            noNgosLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noNgosLabel.isHidden = true
            tableView.isHidden = false
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

//
//  RaghadDonatoinFormViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 13/12/2025.
//

import UIKit

class RaghadDonatoinFormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var donationFormTableview: UITableView!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        donationFormTableview.delegate = self
        donationFormTableview.dataSource = self

        self.title = "Donation Form"
                navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func numberOfSections(in donationFormTableview: UITableView) -> Int {
        return 6   // or any number you want
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Section\(indexPath.section + 1)Cell",
                                                 for: indexPath)
        
        cell.selectionStyle = .none   // ✅ no highlight, no click
            return cell
   
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 195   // Section1Cell
        case 1:
            return 94   // Section2Cell
        case 2:
            return 140   // Section3Cell
        case 3:
            return 180   // Section4Cell
        case 4:
            return 160   // Section5Cell
        case 5:
            return 220   // Section6Cell
        default:
            return 44
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

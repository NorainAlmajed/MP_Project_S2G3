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

    
    // dismiss keyboard on tap
       let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)

       // (optional but recommended)
       donationFormTableview.keyboardDismissMode = .onDrag
        
        addDoneButtonOnKeyboard()

        
   }
  
    
    
    func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                  target: nil,
                                  action: nil)

        let done = UIBarButtonItem(title: "Done",
                                   style: .done,
                                   target: self,
                                   action: #selector(doneButtonTapped))

        toolbar.items = [flex, done]

        // attach to all textfields in this view
        view.subviews.forEach { view in
            if let textField = view as? UITextField {
                textField.inputAccessoryView = toolbar
            }
        }
    }
    
    
    
@objc func dismissKeyboard() {
    view.endEditing(true)
}

    @objc func doneButtonTapped() { //to add done in the keyboard 
        view.endEditing(true)
    }
    
    
    
    
    func numberOfSections(in donationFormTableview: UITableView) -> Int {
        return 8   // or any number you want
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
            case 6:
                return 160   // ✅ Section7Cell (choose height)
            case 7:
                return 400  // ✅ Section8Cell (choose height)
            default:
                return 44
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



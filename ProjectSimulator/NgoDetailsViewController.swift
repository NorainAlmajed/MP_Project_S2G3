//
//  NgoDetailsViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 12/12/2025.
//

import UIKit

class NgoDetailsViewController: UIViewController {

    var selectedNgo: NGO?
    @IBOutlet weak var lblMissionText: UILabel!
    
    @IBOutlet weak var lblMissionTxt: UILabel!
    
    @IBOutlet weak var lblNgoCategory: UILabel!
    @IBOutlet weak var lblNgoName: UILabel!
    @IBOutlet weak var misssionView: UIView!
    
    @IBOutlet weak var contactView: UIView!
    
    
    
    
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var lblContactNgo: UILabel!
    @IBOutlet weak var btnPhoneLogo: UIButton!
    @IBOutlet weak var lblPgoneNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnEmailLogo: UIButton!
    @IBOutlet weak var btnDonateToNgo: UIButton!
    @IBOutlet weak var btnChatWithUs: UIButton!
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "NGO Details"
        // إزالة الظل الافتراضي (لو موجود)
           navigationController?.navigationBar.shadowImage = UIImage()

           // إنشاء خط مخصص أسفل الـ navigation bar
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
       
       
        // Mission View styling
            misssionView.backgroundColor = .white
            misssionView.layer.cornerRadius = 16
            misssionView.layer.borderWidth = 1
            misssionView.layer.borderColor = UIColor.systemGray4.cgColor
            misssionView.clipsToBounds = true
        
        // ✅📞 Contact View styling (same as Mission View)
        contactView.backgroundColor = .white
        contactView.layer.cornerRadius = 16
        contactView.layer.borderWidth = 1
        contactView.layer.borderColor=UIColor.systemGray4.cgColor
        contactView.clipsToBounds = true

        

        // Image View styling (same border)
            img_logo.backgroundColor = .white
            img_logo.layer.cornerRadius = 12
            img_logo.layer.borderWidth = 1
            img_logo.layer.borderColor = UIColor.systemGray4.cgColor
            img_logo.clipsToBounds = true
        
        guard let ngo = selectedNgo else { return }

        lblNgoName.text = ngo.name
        lblNgoCategory.text = ngo.category
        img_logo.image = ngo.photo
        lblMissionText.text = ngo.mission
        lblPgoneNumber.text = String(ngo.phoneNumber)
        lblEmail.text = ngo.email
      
        
        

    

            // ✅⬅️🆕 Hide back button text for the NEXT screen (Donation Form)
            if #available(iOS 14.0, *) {
                navigationItem.backButtonDisplayMode = .minimal
            } else {
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            }

        
        

        // Buttons
                styleActionButton(btnChatWithUs)
                styleActionButton(btnDonateToNgo)


        // Do any additional setup after loading the view.
    }
    
    
    
    //For buttons radius
        private func styleActionButton(_ button: UIButton) {
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
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

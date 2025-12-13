////
////  DonationDetailsViewController.swift
////  ProjectSimulator
////
////  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 29/11/2025.
////
//
//
//import UIKit
//
//class CancelledDetailsViewController: UIViewController {
//    
//    var donation: Donation? 
//
//    @IBOutlet weak var donationAddressLbl: UILabel!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Donation Details"
//
//        //Make the title small
//        navigationItem.largeTitleDisplayMode = .never
//        // Do any additional setup after loading the view.
//        
// 
//
//        // Set the text spacing (line spacing)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 6   // change this number to increase or decrease spacing
//
//        let attributedString = NSMutableAttributedString(string: donationAddressLbl.text ?? "")
//        attributedString.addAttribute(.paragraphStyle,
//                                          value: paragraphStyle,
//                                          range: NSRange(location: 0, length: attributedString.length))
//
//        donationAddressLbl.attributedText = attributedString
//        donationAddressLbl.numberOfLines = 0
//        
//    }
//
//}

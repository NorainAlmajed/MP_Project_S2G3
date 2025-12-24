//
//  RaghadNgoDetailsNgoActionsTableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 17/12/2025.
//

import UIKit

class RaghadNgoDetailsNgoActionsTableViewCell: UITableViewCell {

    @IBOutlet weak var btnDonateToNgo: UIButton!
    @IBOutlet weak var btnChatWithUs: UIButton!

    var onDonateTapped: (() -> Void)?
       var onChatTapped: (() -> Void)?

       override func layoutSubviews() {
           super.layoutSubviews()
           style(btnDonateToNgo)
           style(btnChatWithUs)

           applyDonateStyle(btnDonateToNgo)
           applyChatStyle(btnChatWithUs)
       }

       private func style(_ button: UIButton) {
           button.layer.cornerRadius = button.frame.height / 2
           button.clipsToBounds = true
       }

       // ✅ KEEP THIS ONE ONLY (fixed dark mode = #34C759)
       private func applyDonateStyle(_ button: UIButton) {

           let donateGreen = UIColor { trait in
               if trait.userInterfaceStyle == .dark {
                   return UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0) // 🌙 #34C759
               } else {
                   return UIColor(named: "greenCol")
                       ?? UIColor(red: 18/255, green: 99/255, blue: 18/255, alpha: 1.0) // ☀️ #126312 fallback
               }
           }

           if #available(iOS 15.0, *) {
               var config = button.configuration ?? .filled()
               config.baseBackgroundColor = donateGreen
               config.baseForegroundColor = .white
               button.configuration = config
           } else {
               button.backgroundColor = donateGreen
               button.setTitleColor(.white, for: .normal)
           }
       }

    private func applyChatStyle(_ button: UIButton) {

        // ✅ same in Light + Dark
        let chatGray = UIColor(named: "grayCol")
            ?? UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1.0) // #8A8A8A

        if #available(iOS 15.0, *) {
            var config = button.configuration ?? .filled()
            config.baseBackgroundColor = chatGray
            config.baseForegroundColor = .white
            button.configuration = config
        } else {
            button.backgroundColor = chatGray
            button.setTitleColor(.white, for: .normal)
        }
    }


//    private func style(_ button: UIButton) {
//        button.layer.cornerRadius = button.frame.height / 2
//        button.clipsToBounds = true
//    }

    @IBAction func donateTapped(_ sender: Any) {
        onDonateTapped?()
    }

    @IBAction func chatTapped(_ sender: Any) {
        onChatTapped?()
    }
}

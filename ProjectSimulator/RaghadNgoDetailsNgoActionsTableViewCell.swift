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
    }

    private func style(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
    }

    @IBAction func donateTapped(_ sender: Any) {
        onDonateTapped?()
    }

    @IBAction func chatTapped(_ sender: Any) {
        onChatTapped?()
    }
}

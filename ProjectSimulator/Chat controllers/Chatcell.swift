//
//  Chatcell.swift
//  Project
//
//  Created by zainab mahdi on 25/12/2025.
//

import UIKit


class Chatcell: UITableViewCell {

    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var EndedLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ProfilePhoto: UIImageView!
    @IBOutlet weak var unreadBadgeView: UIView!
       @IBOutlet weak var unreadCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//profile photo setup
        ProfilePhoto.layer.cornerRadius = ProfilePhoto.frame.height / 2
           ProfilePhoto.clipsToBounds = true
        
        unreadBadgeView.layer.cornerRadius = unreadBadgeView.frame.height / 2
                unreadBadgeView.clipsToBounds = true
                unreadBadgeView.isHidden = true
            }

            func configureUnread(count: Int) {
                if count > 0 {
                    unreadBadgeView.isHidden = false
                    unreadCountLabel.text = "\(count)"
                } else {
                    unreadBadgeView.isHidden = true
                }
       
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        unreadBadgeView.layer.cornerRadius =
            unreadBadgeView.frame.height / 2
        unreadBadgeView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)
     }
}

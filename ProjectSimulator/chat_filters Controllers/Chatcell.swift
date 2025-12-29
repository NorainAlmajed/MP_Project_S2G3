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
    override func awakeFromNib() {
        super.awakeFromNib()
//profile photo setup
        ProfilePhoto.layer.cornerRadius = ProfilePhoto.frame.height / 2
           ProfilePhoto.clipsToBounds = true
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)
     }
    func configure(with chat: SupportChat) {
        nameLabel.text = chat.senderName

        if let timestamp = chat.lastMessageTime {
            timeStamp.text = ChatListViewController()
                .formatTimestampForChatList(timestamp.dateValue())
        } else {
            timeStamp.text = ""
        }

        ProfilePhoto.image = UIImage(named: "placeholder_pp")
    }


}

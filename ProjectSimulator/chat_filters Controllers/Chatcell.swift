//
//  Chatcell.swift
//  Project
//
//  Created by zainab mahdi on 25/12/2025.
//
import UIKit

class Chatcell: UITableViewCell {

    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ProfilePhoto: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        ProfilePhoto.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        ProfilePhoto.layer.cornerRadius = ProfilePhoto.bounds.height / 2
    }

    func configure(with chat: SupportChat) {
        nameLabel.text = chat.senderName

        if let timestamp = chat.lastMessageTime {
            timeStamp.text = DateFormatterHelper.chatListTime(timestamp.dateValue())
        } else {
            timeStamp.text = ""
        }

        loadImage(from: chat.senderProfileURL)
    }

    private func loadImage(from urlString: String) {
        guard let url = fixedCloudinaryURL(from: urlString) else {
            ProfilePhoto.image = UIImage(named: "placeholder_pp")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data,
                  let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self?.ProfilePhoto.image = image
            }
        }.resume()
    }

    private func fixedCloudinaryURL(from raw: String) -> URL? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let encoded = trimmed.addingPercentEncoding(
            withAllowedCharacters: .urlFragmentAllowed
        )

        return encoded.flatMap { URL(string: $0) }
    }
}

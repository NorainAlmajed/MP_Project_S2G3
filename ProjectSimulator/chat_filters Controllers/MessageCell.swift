//
//  MessageCell.swift
//  Project
//
//  Created by zainab mahdi on 25/12/2025.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    @IBOutlet weak var trailingConstraints: NSLayoutConstraint?
   
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var leadingConstraints: NSLayoutConstraint?
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    
    private var leftConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
         super.awakeFromNib()

         bubbleView.layer.cornerRadius = 16
         bubbleView.clipsToBounds = true

         messageLabel.numberOfLines = 0
         messageLabel.textColor = .black
         timeLabel.textColor = UIColor(white: 0.6, alpha: 1)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false

           leftConstraint = bubbleView.leadingAnchor.constraint(
               equalTo: contentView.leadingAnchor,
               constant: 12
           )

           rightConstraint = bubbleView.trailingAnchor.constraint(
               equalTo: contentView.trailingAnchor,
               constant: -12
           )

           bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
           bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
       }

     override func prepareForReuse() {
         super.prepareForReuse()
         messageLabel.text = nil
         timeLabel.text = nil
         
         leftConstraint.isActive = false
             rightConstraint.isActive = false

     }

    func configure(text: String, time: String, isIncoming: Bool) {
        messageLabel.text = text
        timeLabel.text = time

        leadingConstraints?.isActive = false
        trailingConstraints?.isActive = false

        if isIncoming {
            leftConstraint.isActive = true
            rightConstraint.isActive = false
            bubbleView.backgroundColor = UIColor(white: 0.92, alpha: 1)
        } else {
            leftConstraint.isActive = false
            rightConstraint.isActive = true
            bubbleView.backgroundColor = UIColor(red: 1.0, green: 0.93, blue: 0.75, alpha: 1)
        }

        layoutIfNeeded()
    }

     }
 

//
//  UIImageView+ProfileStyle.swift
//  ProjectSimulator
//
//  Created by user290698 on 1/1/26.
//

import Foundation

import UIKit

extension UIImageView {

    func applyProfileStyle(cornerRadius: CGFloat = 7) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.contentMode = .scaleAspectFill

        // Default placeholder
        if self.image == nil {
            self.image = UIImage(systemName: "person.circle.fill")
        }
    }

    func loadProfileImage(from urlString: String) {
        guard !urlString.isEmpty else {
            self.image = UIImage(systemName: "person.circle.fill")
            return
        }

        self.image = UIImage(systemName: "person.circle.fill")

        FetchImage.fetchImage(from: urlString) { [weak self] image in
            DispatchQueue.main.async {
                if let image = image {
                    self?.image = image
                }
            }
        }
    }
}

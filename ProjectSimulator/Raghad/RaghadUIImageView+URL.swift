//
//  RaghadUIImageView+URL.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 22/12/2025.
//

import Foundation
import UIKit

extension UIImageView {

    func setImageFromUrl(_ urlString: String?, placeholder: UIImage? = nil) {
        self.image = placeholder

        guard let urlString = urlString,
              let url = URL(string: urlString),
              !urlString.isEmpty else {
            return
        }

        //  prevents wrong images in reused table cells
        let token = UUID().uuidString
        self.accessibilityIdentifier = token

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }
            guard self.accessibilityIdentifier == token else { return }

            if let data = data, let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = img
                }
            }
        }.resume()
    }
}

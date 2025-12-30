//
//  UIImageView+URLZH.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 22/12/2025.
//

import UIKit

extension UIImageView {

    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder

        guard let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard
                let self = self,
                let data = data,
                error == nil,
                let image = UIImage(data: data)
            else {
                return
            }

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

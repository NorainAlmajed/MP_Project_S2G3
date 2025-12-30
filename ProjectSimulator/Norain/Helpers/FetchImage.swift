//
//  AppData.swift
//  ProjectSimulator
//
//  Created by Norain  on 18/12/2025.
//

import Foundation
import UIKit
class FetchImage{
    
   

        static func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }.resume()
        }
    
    
    
    
}
    


//
//  AppData.swift
//  ProjectSimulator
//
//  Created by Norain  on 18/12/2025.
//

import Foundation
import UIKit
class AppData{
    
    static var users = [AppUser]()

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
    
    static func load(){
        //load all data stored in a file
        if users.isEmpty{
            users = sampleUsers
        }
    }
    static var sampleUsers = [
        Donor(userName: "norain.hani", password:"1234", name: "norain hani", phoneNumber: 33744063, email: "norain.hani@gmail.com", address: "house 23, block 432, road 567", userImg: "some url", bio:"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.nononononooon"),
        NGO(userName: "Amal.Foundation", password: "1234", name: "Amal Foundation", phoneNumber: 17112355, email: "amalfoundation@gmail.com", cause: "Women rights", address: "building 123, block 456, road 789", governorate: "Muharraq", isApproved: true, isRejected: false, isPending: false, userImg: "some url",mission: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."),
        NGO(userName: "Amal.Foundation", password: "1234", name: "Amal Foundation", phoneNumber: 17112355, email: "amalfoundation@gmail.com", cause: "Women rights", address: "building 123, block 456, road 789", governorate: "Muharraq", isApproved: false, isRejected: false, isPending: true, userImg: "some url",mission: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."),
        NGO(userName: "Amal.Foundation", password: "1234", name: "Amal Foundation", phoneNumber: 17112355, email: "amalfoundation@gmail.com", cause: "Women rights", address: "building 123, block 456, road 789", governorate: "Muharraq", isApproved: false, isRejected: true, isPending: false, userImg: "some url",mission: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.")
    ]
    
}

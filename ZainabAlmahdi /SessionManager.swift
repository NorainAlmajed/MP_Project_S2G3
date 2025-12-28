//
//  SessionManager.swift
//  ProjectSimulator
//
//  Created by Zainab Almahdi on 12/24/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class SessionManager {

    static let shared = SessionManager()

    private init() {}

    enum UserRole: Int {
        case admin = 1
        case donor = 2
        case ngo = 3
        case unknown = 0
    }

    private(set) var role: UserRole = .unknown

    // MARK: - Public helpers
    var isAdmin: Bool { role == .admin }
    var isDonor: Bool { role == .donor }
    var isNGO: Bool { role == .ngo }

    // MARK: - Fetch role once after login
    func fetchUserRole(completion: @escaping (Bool) -> Void) {

//        guard let uid = Auth.auth().currentUser?.uid else {
//            completion(false)
//            return
//        }
        let uid = "admin"

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument { snapshot, error in

                guard
                    let data = snapshot?.data(),
                    let roleString = data["role"] as? String
                else {
                    completion(false)
                    return
                }

                switch roleString {
                case "1":
                    self.role = .admin
                case "2":
                    self.role = .donor
                case "3":
                    self.role = .ngo
                default:
                    self.role = .unknown
                }

                completion(true)
            }
    }

    func clear() {
        role = .unknown
    }
}

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

    // MARK: - Stored properties
    private(set) var role: UserRole = .unknown
    private(set) var fullName: String?

    // MARK: - Helpers
    var isAdmin: Bool { role == .admin }
    var isDonor: Bool { role == .donor }
    var isNGO: Bool { role == .ngo }

    var roleDisplayName: String {
        switch role {
        case .admin: return "Admin"
        case .donor: return "Donor"
        case .ngo: return "NGO"
        case .unknown: return "User"
        }
    }

    // MARK: - Fetch session (call after login)
    func fetchUserRole(completion: @escaping (Bool) -> Void) {

        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument { snapshot, _ in

                guard let data = snapshot?.data() else {
                    completion(false)
                    return
                }

                self.fullName = data["full_name"] as? String

                if let roleString = data["role"] as? String {
                    switch roleString {
                    case "1": self.role = .admin
                    case "2": self.role = .donor
                    case "3": self.role = .ngo
                    default: self.role = .unknown
                    }
                }

                completion(true)
            }
    }

    // MARK: - Clear on logout
    func clear() {
        role = .unknown
        fullName = nil
    }
}


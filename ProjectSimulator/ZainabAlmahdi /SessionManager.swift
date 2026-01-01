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

    // MARK: - Stored Session Data
    private(set) var role: UserRole = .unknown
    private(set) var fullName: String?
    private(set) var profileImageURL: String?

    // MARK: - Role Helpers
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

    // MARK: - MAIN Session Loader (single source of truth)
    func loadUserSession(completion: @escaping (Bool) -> Void) {

        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument { snapshot, error in

                guard let data = snapshot?.data(), error == nil else {
                    completion(false)
                    return
                }

                // Name (Donor or NGO)
                self.fullName =
                    data["full_name"] as? String ??
                    data["organization_name"] as? String

                // Role
                if let roleInt = data["role"] as? Int,
                   let role = UserRole(rawValue: roleInt) {
                    self.role = role
                } else {
                    self.role = .unknown
                }

                // Profile Image
                self.profileImageURL = data["profile_image_url"] as? String

                completion(true)
            }
    }

    // MARK: - BACKWARD COMPATIBILITY (IMPORTANT)
    /// Use this for older screens that already call fetchUserRole
    func fetchUserRole(completion: @escaping (Bool) -> Void) {
        loadUserSession(completion: completion)
    }

    // MARK: - Clear Session
    func clear() {
        role = .unknown
        fullName = nil
        profileImageURL = nil
    }
}

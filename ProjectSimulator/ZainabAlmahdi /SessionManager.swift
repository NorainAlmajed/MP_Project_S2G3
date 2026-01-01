import Foundation
import FirebaseAuth
import FirebaseFirestore

final class SessionManager {

    static let shared = SessionManager()
    private init() {}

    // MARK: - User Role
    enum UserRole: Int {
        case admin = 1
        case donor = 2
        case ngo = 3
        case unknown = 0
    }

    // MARK: - Stored Session Data
    private(set) var role: UserRole = .unknown
    private(set) var fullName: String?
    private(set) var profileImageURL: String?   // ✅ THIS IS THE CORRECT PROPERTY

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
            DispatchQueue.main.async {
                completion(false)
            }
            return
        }

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument { snapshot, error in

                guard let data = snapshot?.data(), error == nil else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }

                // ✅ Always update session on MAIN thread
                DispatchQueue.main.async {

                    // Name (Donor OR NGO)
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

                    // Profile Image URL (🔥 this fixes your error)
                    self.profileImageURL = data["profile_image_url"] as? String

                    completion(true)
                }
            }
    }

    // MARK: - BACKWARD COMPATIBILITY
    /// Use this for older screens that already call fetchUserRole
    func fetchUserRole(completion: @escaping (Bool) -> Void) {
        loadUserSession(completion: completion)
    }

    // MARK: - Clear Session (Logout)
    func clear() {
        role = .unknown
        fullName = nil
        profileImageURL = nil
    }
}

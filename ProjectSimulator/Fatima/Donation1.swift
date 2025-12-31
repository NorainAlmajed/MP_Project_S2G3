import FirebaseFirestore

struct Donation1 {

    // MARK: - Core Firestore fields
    let firestoreID: String
    let donationID: Int
    let category: String
    let status: Int
    let quantity: Int
    let creationDate: Date
    let weight: Int

    // MARK: - Derived / UI-safe values

    /// Donor dashboard → always the logged-in user
    var donorDisplayName: String {
        return "You"
    }

    /// Formatted date for UI display
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: creationDate)
    }

    // MARK: - Firestore Initializer
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()

        guard
            let donationID = data["donationID"] as? Int,
            let category = data["Category"] as? String,
            let status = data["status"] as? Int,
            let quantity = data["quantity"] as? Int,
            let weight = data["weight"] as? Int,        // ✅ ADD

            let timestamp = data["creationDate"] as? Timestamp
        else {
            print("❌ Failed to parse Donation1:", document.documentID)
            return nil
        }

        self.firestoreID = document.documentID
        self.donationID = donationID
        self.category = category
        self.status = status
        self.quantity = quantity
        self.creationDate = timestamp.dateValue()
        self.weight = weight

    }
}

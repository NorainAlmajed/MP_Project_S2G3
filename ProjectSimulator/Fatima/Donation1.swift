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

    // ✅ NEW (FOR IMPACT STATS)
    let donorUserID: String
    let ngoUserID: String

    // MARK: - UI helpers
    var donorDisplayName: String { "You" }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: creationDate)
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()

        guard
            let donationID = data["donationID"] as? Int,
            let category = data["Category"] as? String,
            let status = data["status"] as? Int,
            let quantity = data["quantity"] as? Int,
            let timestamp = data["creationDate"] as? Timestamp,
            let donorRef = data["donor"] as? DocumentReference,
            let ngoRef = data["ngo"] as? DocumentReference
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
        self.weight = data["weight"] as? Int ?? 0

        // ✅ Extract IDs safely
        self.donorUserID = donorRef.documentID
        self.ngoUserID = ngoRef.documentID
    }
}

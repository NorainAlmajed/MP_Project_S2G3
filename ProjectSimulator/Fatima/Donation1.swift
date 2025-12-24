import FirebaseFirestore

struct Donation1 {

    let firestoreID: String
    let donationID: Int
    let category: String
    let status: Int
    let creationDate: Date

    // MARK: - Derived / UI-safe values

    /// Donor dashboard → always the logged-in user
    var donorDisplayName: String {
        return "You"
    }

    /// Formatted date for UI
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: creationDate)
    }

    // MARK: - Firestore Init
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()

        guard
            let donationID = data["donationID"] as? Int,
            let category = data["Category"] as? String,
            let status = data["status"] as? Int,
            let timestamp = data["creationDate"] as? Timestamp
        else {
            return nil
        }

        self.firestoreID = document.documentID
        self.donationID = donationID
        self.category = category
        self.status = status
        self.creationDate = timestamp.dateValue()
    }
}

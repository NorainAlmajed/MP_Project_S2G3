import FirebaseFirestore

struct Donation1 {

    let id: String
    let category: String
    let donationID: Int
    let creationDate: Date
    let quantity: Int
    let status: Int
    let donorRef: DocumentReference

    init?(document: QueryDocumentSnapshot) {

        let data = document.data()

        guard
            let category = data["Category"] as? String,
            let donationID = data["donationID"] as? Int,
            let timestamp = data["creationDate"] as? Timestamp,
            let quantity = data["quantity"] as? Int,
            let status = data["status"] as? Int,
            let donorRef = data["donor"] as? DocumentReference
        else {
            return nil
        }

        self.id = document.documentID
        self.category = category
        self.donationID = donationID
        self.creationDate = timestamp.dateValue()
        self.quantity = quantity
        self.status = status
        self.donorRef = donorRef
    }
}

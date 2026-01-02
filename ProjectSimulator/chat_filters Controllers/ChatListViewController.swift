import UIKit
import FirebaseFirestore
import FirebaseAuth

struct SupportChat {
    let chatID: String
    let otherUserId: String
    let adminId: String?
    let senderName: String
    let senderType: String
    let chatType: ChatType
    let time: String
    var lastMessageTime: Timestamp?
    let senderProfileURL: String
    let isEnded: Bool
}

struct DateFormatterHelper {
    static func chatListTime(_ date: Date) -> String {
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            let f = DateFormatter()
            f.dateFormat = "h:mm a"
            return f.string(from: date)
        }

        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }

        if calendar.isDate(date, equalTo: Date(), toGranularity: .weekOfYear) {
            let f = DateFormatter()
            f.dateFormat = "EEEE"
            return f.string(from: date)
        }

        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f.string(from: date)
    }
}

enum ChatType: String {
    case normal
    case support
}

class ChatListViewController: UIViewController,  UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var chatType: ChatType = .normal
    
    enum CurrentUserRole {
        case admin
        case donor
        case ngo
    }
    
    var currentUserRole: CurrentUserRole = .admin
    var donorId: String?
    var ngoId: String?
    var adminId: String?
    var userNameCache: [String: String] = [:]
    
    var currentUserId: String {
        Auth.auth().currentUser?.uid ?? ""
    }
    
    
    var chatsAfterFilter: [SupportChat] = []
    var currentFilter = String ("all")
    private let db = Firestore.firestore()
    private var chatListener: ListenerRegistration?

    
    
    
    @IBOutlet weak var tableTopToSearchConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableTopToFilterConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterStackView: UIStackView!
    @IBOutlet weak var ChatSearch: UISearchBar!
    @IBOutlet weak var ngoButton: UIButton!
    @IBOutlet weak var donorButton: UIButton!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var ChatTable: UITableView!
  

    @IBAction func allButton(_ sender: UIButton) {
        currentFilter = "all"
        setSelectedFilterButton(sender)
        applyFilter(type: currentFilter)
        
        
    }
    @IBAction func donorButton(_ sender: UIButton) {
        currentFilter = "donor"
        setSelectedFilterButton(sender)
        applyFilter(type: currentFilter)
    }
    @IBAction func ngoButton(_ sender: UIButton) {
        currentFilter = "ngo"
        setSelectedFilterButton(sender)
        applyFilter(type: currentFilter)
    }
    
    func configureUIForRole() {
        switch currentUserRole {
        case .admin:
            filterStackView.isHidden = false
            
        case .donor, .ngo:
            filterStackView.isHidden = true
            currentFilter = "all"
            applyFilter(type: "all")
        }
    }
    func configureLayoutForRole() {
        switch currentUserRole {
        case .admin:
            tableTopToFilterConstraint.isActive = true
            tableTopToSearchConstraint.isActive = false
            
        case .donor, .ngo:
            tableTopToFilterConstraint.isActive = false
            tableTopToSearchConstraint.isActive = true
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func loadCurrentUserAndStart() {
        let userId = currentUserId
        guard !userId.isEmpty else { return }

        db.collection("users")
            .document(userId)
            .getDocument { [weak self] snapshot, _ in
                guard let self = self else { return }
                guard let data = snapshot?.data() else { return }

                let role = data["role"] as? Int ?? 0

                switch role {
                case 1:
                    self.currentUserRole = .admin
                case 2:
                    self.currentUserRole = .donor
                case 3:
                    self.currentUserRole = .ngo
                default:
                    return
                }
                self.configureUIForRole()
                self.configureLayoutForRole()

                self.listenForChats()
            }
    }
    func applyNavigationBarStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground

        if traitCollection.userInterfaceStyle == .dark {
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.tintColor =
                UIColor(red: 0.07, green: 0.39, blue: 0.07, alpha: 1.0)
        } else {
            appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
            navigationController?.navigationBar.tintColor = .black
        }

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        ChatSearch.delegate = self
        ChatSearch.backgroundImage = UIImage()
        applyNavigationBarStyle()
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            [weak self] (env: UITraitEnvironment, previous: UITraitCollection) in
            guard let self = self else { return }

            self.refreshFilterUIAfterTraitChange()
        }

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        ChatTable.dataSource = self
        ChatTable.delegate = self

        navigationItem.backButtonDisplayMode = .minimal
      
        setupFilterButtonsInitialState()


        loadCurrentUserAndStart()
        
    }

    
    //search bar shows cancel when clicked
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    //hiding cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        
        visibleChats = chatsAfterFilter
        ChatTable.reloadData()
    }
    //dismiss keyboard function
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // color initial unselected buttons
    func setupFilterButtonsInitialState() {
        let buttons = [allButton, donorButton, ngoButton]
        let isDarkMode = traitCollection.userInterfaceStyle == .dark

        for button in buttons {
            button?.configuration = nil
            button?.layer.cornerRadius = 16
            button?.layer.borderWidth = 1

            if isDarkMode {
                button?.backgroundColor = .white
                button?.setTitleColor(.black, for: .normal)
                button?.layer.borderColor = UIColor.black.cgColor
            } else {
                button?.backgroundColor = .clear
                button?.setTitleColor(.label, for: .normal)
                button?.layer.borderColor = UIColor.systemGray3.cgColor
            }
        }
    }

    
    func refreshFilterUIAfterTraitChange() {
        setupFilterButtonsInitialState()
        restoreSelectedFilterButton()
        applyFilter(type: currentFilter)
    }


    
    // change color of button when selected/unselected
    func setSelectedFilterButton(_ selected: UIButton) {
        setupFilterButtonsInitialState()

        selected.backgroundColor =
            UIColor(red: 0.07, green: 0.39, blue: 0.07, alpha: 1.0)
        selected.setTitleColor(.white, for: .normal)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
          navigationItem.largeTitleDisplayMode = .never
        refreshFilterUIAfterTraitChange()

        
    }
    
    var allChats: [SupportChat] = []
    var visibleChats: [SupportChat] = []
    
    //table function
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleChats.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "Chatcell",
            for: indexPath
        ) as? Chatcell else {
            return UITableViewCell()
        }

        let chat = visibleChats[indexPath.row]
        if let timestamp = chat.lastMessageTime {
            cell.timeStamp.text = formatTimestampForChatList(timestamp.dateValue())
        } else {
            cell.timeStamp.text = ""
        }
        

        if chat.chatType == .support && currentUserRole != .admin {
            cell.nameLabel.text = "Live support chat"
        } else {
            cell.nameLabel.text = chat.senderName
        }
        cell.configure(with: chat)

        return cell
    }

    
    
    //filtering chats
    func applyFilter(type: String) {

        if currentUserRole != .admin {
            chatsAfterFilter = allChats
            visibleChats = chatsAfterFilter
            ChatTable.reloadData()
            return
        }

        switch type {
        case "all":
            chatsAfterFilter = allChats

        case "donor":
            chatsAfterFilter = allChats.filter { $0.senderType == "donor" }

        case "ngo":
            chatsAfterFilter = allChats.filter { $0.senderType == "ngo" }

        default:
            chatsAfterFilter = allChats
        }

        visibleChats = chatsAfterFilter
        ChatTable.reloadData()
    }

    
    // searching by username function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchText.isEmpty {
            visibleChats = chatsAfterFilter
        }
        visibleChats = chatsAfterFilter.filter {
            $0.senderName.lowercased().contains(searchText.lowercased())
        }
        ChatTable.reloadData()
    }
    
    //time function
    func formatTimestampForChatList(_ date: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        }
        
        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }
        
        if calendar.isDate(date, equalTo: Date(), toGranularity: .weekOfYear) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE" // Saturday
            return formatter.string(from: date)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let chatVC = segue.destination as? ChatViewController else { return }
        guard let indexPath = ChatTable.indexPathForSelectedRow else { return }

        let selectedChat = visibleChats[indexPath.row]
     
        chatVC.userName = selectedChat.senderName
        chatVC.chatID = selectedChat.chatID
        if currentUserRole == .admin {

            chatVC.chatType = .support
            chatVC.adminId = currentUserId

            if selectedChat.senderType == "donor" {
                chatVC.donorId = selectedChat.otherUserId
            } else {
                chatVC.ngoId = selectedChat.otherUserId
            }

        } else if currentUserRole == .donor {

            chatVC.chatType = .normal
            chatVC.donorId = currentUserId
            chatVC.ngoId = selectedChat.otherUserId

        } else if currentUserRole == .ngo {

            chatVC.chatType = .normal
            chatVC.ngoId = currentUserId
            chatVC.donorId = selectedChat.otherUserId
        }
    }

    
    
    //Firestore methods
    func listenForChats() {
        chatListener?.remove()
        allChats.removeAll()

        let userId = currentUserId
        
        chatListener = db.collection("chats")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                guard let documents = snapshot?.documents else { return }

                var newChats: [SupportChat] = []

                for doc in documents {

                    let data = doc.data()

                    let donorId = data["donorId"] as? String
                    let ngoId = data["ngoId"] as? String
                    let adminId = data["adminId"] as? String

                    switch currentUserRole {
                    case .admin:
                        guard adminId == userId else { continue }

                    case .donor:
                        guard donorId == userId else { continue }

                    case .ngo:
                        guard ngoId == userId else { continue }
                    }

                    let typeString = data["type"] as? String ?? "normal"
                    let chatType: ChatType = (typeString == "support") ? .support : .normal

                    let isEnded = data["isEnded"] as? Bool ?? false
                    if isEnded { continue }
                    let lastMessageTime = data["lastMessageAt"] as? Timestamp


                    let otherUserId: String
                    let senderType: String

                    if chatType == .support {

                        if currentUserRole == .admin {
                            if let donorId = donorId {
                                otherUserId = donorId
                                senderType = "donor"
                            } else if let ngoId = ngoId {
                                otherUserId = ngoId
                                senderType = "ngo"
                            } else {
                                continue
                            }

                        } else {
                            guard let adminId = adminId else { continue }
                            otherUserId = adminId
                            senderType = "admin"
                        }

                    } else {
                        switch currentUserRole {

                        case .admin:
                            if let donorId = donorId {
                                otherUserId = donorId
                                senderType = "donor"
                            } else if let ngoId = ngoId {
                                otherUserId = ngoId
                                senderType = "ngo"
                            } else {
                                continue
                            }

                        case .donor:
                            guard let ngoId = ngoId else { continue }
                            otherUserId = ngoId
                            senderType = "ngo"

                        case .ngo:
                            guard let donorId = donorId else { continue }
                            otherUserId = donorId
                            senderType = "donor"
                        }
                    }

                    let chat = SupportChat(
                        chatID: doc.documentID,
                        otherUserId: otherUserId,
                        adminId: adminId, // ✅ STORE IT
                        senderName: chatType == .support && currentUserRole != .admin
                            ? "Live support chat"
                            : "Loading...",
                        senderType: senderType,
                        chatType: chatType,
                        time: "",
                        lastMessageTime: lastMessageTime,
                        senderProfileURL: "",
                        isEnded: isEnded
                    )

                    newChats.append(chat)
                }

                self.allChats = newChats
                self.applyFilter(type: self.currentFilter)
                self.resolveChatNames()
            }
    }


    func resolveChatNames() {
        for chat in allChats {

            let userIdToFetch: String

            if chat.chatType == .support {
                if currentUserRole == .admin {
                    userIdToFetch = chat.otherUserId
                } else {
                    guard let adminId = chat.adminId else { continue }
                    userIdToFetch = adminId
                }
            } else {
                userIdToFetch = chat.otherUserId
            }

            fetchUserNameAndPhoto(userId: userIdToFetch) { [weak self] name, url in
                guard let self = self else { return }

                if let idx = self.allChats.firstIndex(where: { $0.chatID == chat.chatID }) {

                    let displayName: String
                    if chat.chatType == .support && self.currentUserRole != .admin {
                        displayName = "Live support chat"
                    } else {
                        displayName = name
                    }

                    self.allChats[idx] = SupportChat(
                        chatID: chat.chatID,
                        otherUserId: chat.otherUserId,
                        adminId: chat.adminId,
                        senderName: displayName,
                        senderType: chat.senderType,
                        chatType: chat.chatType,
                        time: chat.time,
                        lastMessageTime: chat.lastMessageTime,
                        senderProfileURL: url,
                        isEnded: chat.isEnded
                    )

                    DispatchQueue.main.async {
                        self.applyFilter(type: self.currentFilter)
                    }
                }
            }
        }
    }


    func fetchUserNameAndPhoto(
        userId: String,
        completion: @escaping (String, String) -> Void
    ) {
        db.collection("users").document(userId).getDocument { snapshot, _ in
            guard let data = snapshot?.data() else {
                completion("Unknown", "")
                return
            }

            let role = data["role"] as? Int ?? 0

            let name: String

            switch role {
            case 1:
                name = "Live support chat"

            case 3:
                name = data["organization_name"] as? String ?? "NGO"

            default:
                name = data["username"] as? String ?? "User"
            }


            let url = data["profile_image_url"] as? String ?? ""

            completion(name, url)
        }
    }



    func fetchLastMessageTime(
        chatID: String,
        completion: @escaping (Timestamp?) -> Void
    ) {
        db.collection("chats")
            .document(chatID)
            .collection("messages")
            .order(by: "createdAt", descending: true)
            .limit(to: 1)
            .getDocuments { snapshot, _ in
                let ts = snapshot?.documents.first?["createdAt"] as? Timestamp
                completion(ts)
            }
    }





    func attachLastMessageTimes() {
        let group = DispatchGroup()

        for index in allChats.indices {
            group.enter()

            let chatID = allChats[index].chatID

            fetchLastMessageTime(chatID: chatID) { [weak self] timestamp in
                guard let self else {
                    group.leave()
                    return
                }

                self.allChats[index].lastMessageTime = timestamp
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.applyFilter(type: self.currentFilter)
        }
    }

    func startNewChatForTesting() {
        guard let chatVC = storyboard?.instantiateViewController(
            withIdentifier: "ChatViewController"
        ) as? ChatViewController else {
            return
        }

        chatVC.chatID = db.collection("chats").document().documentID
        chatVC.userName = "Support"
        chatVC.chatType = .support

        let currentId = currentUserId

        // Simulate Contact Us behavior
        if currentUserRole == .donor {
            chatVC.donorId = currentId
        } else if currentUserRole == .ngo {
            chatVC.ngoId = currentId
        } else if currentUserRole == .admin {
            chatVC.adminId = currentId
        }

        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            setupFilterButtonsInitialState()
            restoreSelectedFilterButton()
        }
    }


    func restoreSelectedFilterButton() {
        switch currentFilter {
        case "donor":
            setSelectedFilterButton(donorButton)
        case "ngo":
            setSelectedFilterButton(ngoButton)
        default:
            setSelectedFilterButton(allButton)
        }
    }

    }


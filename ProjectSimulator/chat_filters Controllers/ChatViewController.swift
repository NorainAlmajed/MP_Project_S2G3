
import UIKit
import FirebaseFirestore
import FirebaseAuth
class ChatViewController: UIViewController,
UICollectionViewDelegate,
UICollectionViewDataSource,
                          UITextFieldDelegate,UIGestureRecognizerDelegate {
    
    var chatType: ChatType = .normal
    
    var donorId: String?
    var ngoId: String?
    var adminId: String?
    private var myUserId = ""
    private let navProfileImageView = UIImageView()
    private let SUPPORT_ADMIN_ID = "TwWqBSGX4ec4gxCWCZcbo7WocAI2"

    
    var chatID: String = ""
    var userName: String = ""
    
    struct ChatMessage {
        let id: String
        let text: String
        let senderId: String
        let date: Date
    }
    

    enum UserRole {
        case admin
        case donor
        case ngo
    }
    
    func formatTimeForMessage(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    var messages: [ChatMessage] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var inputBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var inputBarView: UIView!
    @IBOutlet weak var endButton: UIBarButtonItem!
    
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        messages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MessageCell",
            for: indexPath
        ) as! MessageCell
        
        let msg = messages[indexPath.item]
        let isIncoming = msg.senderId != myUserId
        
        cell.configure(
            text: msg.text,
            time: formatTimeForMessage(msg.date),
            isIncoming: isIncoming
        )
        return cell
        
    }
    
    
    
    //profile photo function
    func receiverUserId() -> String? {
        let myId = Auth.auth().currentUser?.uid

        if donorId != nil && donorId != myId {
            return donorId
        }

        if ngoId != nil && ngoId != myId {
            return ngoId
        }

        if adminId != nil && adminId != myId {
            return adminId
        }

        return nil
    }

    func setupProfilePicture() {
        navProfileImageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        navProfileImageView.contentMode = .scaleAspectFill
        navProfileImageView.layer.cornerRadius = 16
        navProfileImageView.clipsToBounds = true
        navProfileImageView.image = UIImage(named: "placeholder_pp")

        let container = UIView(frame: navProfileImageView.frame)
        container.addSubview(navProfileImageView)

        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: container)
    }
    func loadReceiverProfilePhoto() {
        guard let receiverId = receiverUserId() else { return }

        Firestore.firestore()
            .collection("users")
            .document(receiverId)
            .getDocument { [weak self] snapshot, _ in
                guard
                    let self = self,
                    let data = snapshot?.data(),
                    let rawURL = data["profile_image_url"] as? String,
                    !rawURL.isEmpty
                else { return }

                let trimmed = rawURL.trimmingCharacters(in: .whitespacesAndNewlines)
                guard
                    let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                    let url = URL(string: encoded)
                else { return }

                URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data, let image = UIImage(data: data) else { return }

                    DispatchQueue.main.async {
                        self.navProfileImageView.image = image
                    }
                }.resume()
            }
    }



    
    func applyChatLayout() {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
        
        collectionView.setCollectionViewLayout(UICollectionViewCompositionalLayout(section: section), animated: false)
    }
    
    func scrollToBottom(animated: Bool) {
        collectionView.layoutIfNeeded()

        let itemCount = collectionView.numberOfItems(inSection: 0)
        guard itemCount > 0 else { return }

        let lastIndex = IndexPath(item: itemCount - 1, section: 0)

        collectionView.scrollToItem(
            at: lastIndex,
            at: .bottom,
            animated: animated
        )
    }

    
    
    // ending chat function
    @IBAction func endButtonTapped(_ sender: UIBarButtonItem) {
        showEndChatAlert()
    }
    func showEndChatAlert() {
        let alert = UIAlertController(
            title: "End chat",
            message: "Are you sure you want to end the conversation?",
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.endChat()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func showChatEndedLabel() {
        if view.viewWithTag(999) != nil { return }

        let label = UILabel()
        label.tag = 999
        label.text = "This chat has ended!"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    
    
    
    func endChat() {
        inputBarView.isHidden = true
        endButton.isEnabled = false
        showChatEndedLabel()
        
        let chatRef = Firestore.firestore()
            .collection("chats")
            .document(chatID)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            chatRef.updateData([
                "isEnded": true
            ]) { error in
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    
    
    
    // messages functions
    @objc private func didPressReturnKey() {
        sendMessage()
    }
    
    func sendMessageToFirestore(text: String, localId: String) {
        
        let now = Timestamp()
        
        let chatRef = Firestore.firestore()
            .collection("chats")
            .document(chatID)
        
        let messageData: [String: Any] = [
            "id": localId,
            "senderId": myUserId,
            "text": text,
            "createdAt": now
        ]
        
        chatRef
            .collection("messages")
            .document(localId)
            .setData(messageData)

        chatRef.updateData([
            "lastMessageAt": now,
            "lastMessageText": text
        ])

    }
    
    func sendMessage() {
        
        guard let text = messageTextField.text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return }
        
        let tempId = UUID().uuidString
        
        let localMessage = ChatMessage(
            id: tempId,
            text: text,
            senderId: myUserId,
            date: Date()
        )
        
        messages.append(localMessage)
        
        collectionView.reloadData()
        scrollToBottom(animated: true)
        
        messageTextField.text = ""
        
        sendMessageToFirestore(text: text, localId: tempId)
    }
    
    
    func createChatIfNeeded() {
        guard !chatID.isEmpty else { return }

        let chatRef = Firestore.firestore()
            .collection("chats")
            .document(chatID)

        chatRef.getDocument { snapshot, _ in
            if snapshot?.exists == true { return }

            var data: [String: Any] = [
                "type": self.chatType.rawValue,
                "createdAt": Timestamp(),
                "isEnded": false
            ]

            if let donorId = self.donorId { data["donorId"] = donorId }
            if let ngoId = self.ngoId { data["ngoId"] = ngoId }

            if self.chatType == .support {
                data["adminId"] = self.SUPPORT_ADMIN_ID
            } else if let adminId = self.adminId {
                data["adminId"] = adminId
            }

            chatRef.setData(data)
        }
    }


    func ensureChatID() {
        if chatID.isEmpty {
            chatID = Firestore.firestore()
                .collection("chats")
                .document()
                .documentID
        }
    }


    
    
    
    
    //text field functions
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
    
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let frame =
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        inputBarConstraint.constant = -frame.height
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            self.scrollToBottom(animated: true)
        }
    }
    
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        inputBarConstraint.constant = 0
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    
  

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = userName
        applyInputBarStyle()
        setupProfilePicture()
        loadReceiverProfilePhoto()
        myUserId = Auth.auth().currentUser?.uid ?? ""

        if chatID.isEmpty {
            ensureChatID()
            createChatIfNeeded()
        }
        listenForMessages()
        listenForChatEndedState()

       
        
        collectionView.dataSource = self
        collectionView.delegate = self
        messageTextField.delegate = self
        
        collectionView.contentInset = .zero
        collectionView.scrollIndicatorInsets = .zero
        collectionView.contentInsetAdjustmentBehavior = .never
        
        applyChatLayout()
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        messageTextField.returnKeyType = .send
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            [weak self] (_: UITraitEnvironment, previous: UITraitCollection) in
            guard let self else { return }

            if previous.userInterfaceStyle != self.traitCollection.userInterfaceStyle {
                self.applyInputBarStyle()
            }
        }

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        messageTextField.addTarget(
            self,
            action: #selector(textDidChange),
            for: .editingChanged
        )
        
        
        DispatchQueue.main.async {
            self.scrollToBottom(animated: false)
        }

        collectionView.reloadData()
        scrollToBottom(animated: false)

        
    }
    
    
    @objc private func textDidChange() {
        guard let text = messageTextField.text else { return }
        
        // Detect return character manually
        if text.contains("\n") {
            let cleaned = text.replacingOccurrences(of: "\n", with: "")
            messageTextField.text = cleaned
            sendMessage()
        }
    }
    
    
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        
        if touch.view?.isDescendant(of: inputBarView) == true {
            return false
        }
        
        return true
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never

        edgesForExtendedLayout = []
  

    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollToBottom(animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        inputBarView.layer.cornerRadius = inputBarView.frame.height / 2
        inputBarView.clipsToBounds = true
        messageTextField.borderStyle = .none
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func listenForMessages() {
        
        Firestore.firestore()
            .collection("chats")
            .document(chatID)
            .collection("messages")
            .order(by: "createdAt")
            .addSnapshotListener { snapshot, error in
                
                guard let documents = snapshot?.documents else { return }
                
                self.messages = documents.compactMap { doc -> ChatMessage? in
                    let data = doc.data()
                    
                    guard
                        let text = data["text"] as? String,
                        let senderId = data["senderId"] as? String,
                        let timestamp = data["createdAt"] as? Timestamp
                    else { return nil }
                    
                    let id = data["id"] as? String ?? doc.documentID
                    
                    return ChatMessage(
                        id: id,
                        text: text,
                        senderId: senderId,
                        date: timestamp.dateValue()
                    )
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.scrollToBottom(animated: true)
                }
            }
    }
    
    func listenForChatEndedState() {
        Firestore.firestore()
            .collection("chats")
            .document(chatID)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let self = self else { return }

                let isEnded = snapshot?.data()?["isEnded"] as? Bool ?? false

                if isEnded {
                    self.inputBarView.isHidden = true
                    self.endButton.isEnabled = false
                    self.showChatEndedLabel()
                } else {
                    self.inputBarView.isHidden = false
                    self.endButton.isEnabled = true
                    self.view.viewWithTag(999)?.removeFromSuperview()
                }
            }
    }
    
    func applyInputBarStyle() {
        let yellowBubble = UIColor(
            red: 1.0,
            green: 0.93,
            blue: 0.75,
            alpha: 1.0
        )

        if traitCollection.userInterfaceStyle == .dark {
            inputBarView.backgroundColor = yellowBubble
            messageTextField.backgroundColor = yellowBubble

            messageTextField.textColor = .black
            messageTextField.keyboardAppearance = .dark

            messageTextField.attributedPlaceholder = NSAttributedString(
                string: "Message",
                attributes: [.foregroundColor: UIColor.black.withAlphaComponent(0.6)]
            )

        } else {
            inputBarView.backgroundColor = .systemGray6
            messageTextField.backgroundColor = .clear

            messageTextField.textColor = .label
            messageTextField.keyboardAppearance = .default

            messageTextField.attributedPlaceholder = NSAttributedString(
                string: "Message",
                attributes: [.foregroundColor: UIColor.secondaryLabel]
            )
        }
    }



 

}



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
    func setupProfilePicture() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder_pp")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        
        let container = UIView(frame: imageView.frame)
        container.addSubview(imageView)
        
        let profileItem = UIBarButtonItem(customView: container)
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = profileItem
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
        let label = UILabel()
        label.text = "This chat has ended!"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -24
            )
        ])
    }
    
    
    
    func endChat() {
        inputBarView.isHidden = true
        endButton.isEnabled = false
        showChatEndedLabel()
        
        UserDefaults.standard.removeObject(forKey: "chatMessages_\(chatID)")
        
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
        let db = Firestore.firestore()
        let chatRef = db.collection("chats").document(chatID)
        
        chatRef.getDocument { snapshot, _ in
            if snapshot?.exists == true { return }
            
            var data: [String: Any] = [
                "type": self.chatType.rawValue,
                "createdAt": Timestamp(),
                "isEnded": false
            ]
            
            if let donorId = self.donorId { data["donorId"] = donorId }
            if let ngoId = self.ngoId { data["ngoId"] = ngoId }
            if let adminId = self.adminId { data["adminId"] = adminId }
            
            chatRef.setData(data)
        }
    }
    
    func ensureChatID() {
        if chatID.isEmpty {
            chatID = Firestore.firestore()
                .collection("chats")
                .document()
                .documentID
            
            listenForMessages()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = userName
        setupProfilePicture()
        if !chatID.isEmpty {
            listenForMessages()
        }
        myUserId = Auth.auth().currentUser?.uid ?? ""
      
        navigationController?.navigationBar.tintColor = .black
        
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
        
        let isEnded = UserDefaults.standard.bool(
            forKey: "chatEnded_\(chatID)"
        )
        func removeEndedLabelIfNeeded() {
            view.viewWithTag(999)?.removeFromSuperview()
        }
        
        if isEnded {
            inputBarView.isHidden = true
            endButton.isEnabled = false
            showChatEndedLabel()
        } else {
            inputBarView.isHidden = false
            endButton.isEnabled = true
            removeEndedLabelIfNeeded()
        }
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
}

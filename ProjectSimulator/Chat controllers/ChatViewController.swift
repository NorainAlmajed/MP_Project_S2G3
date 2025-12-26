
import UIKit

class ChatViewController: UIViewController,
UICollectionViewDelegate,
UICollectionViewDataSource,
UITextFieldDelegate,UIGestureRecognizerDelegate {


    struct ChatMessage {
        let text: String
        let isIncoming: Bool
        let date: Date
    }
    enum UserRole {
        case admin
        case donor
        case ngo
    }

    var userRole: UserRole = .admin

    var chatID: String = ""
    var userName: String = ""
    
    
 
    func formatTimeForMessage(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }

    var messages: [ChatMessage] = [
        ChatMessage(text: "Hello", isIncoming: true, date: Date()),
        ChatMessage(text: "Hi, how can I help you?", isIncoming: false, date: Date()),
        ChatMessage(text: "I'm having trouble updating.", isIncoming: true, date: Date()),
        ChatMessage(
            text: "This is a long demo message that should wrap into multiple lines once the width of the bubble reaches 280 points.",
            isIncoming: true,
            date: Date()
        )
    ]

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

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let msg = messages[indexPath.item]
        cell.configure(
            text: msg.text,
            time: formatTimeForMessage(msg.date),
            isIncoming: msg.isIncoming
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
        guard !messages.isEmpty else { return }
        let lastIndex = IndexPath(item: messages.count - 1, section: 0)
        collectionView.scrollToItem(at: lastIndex, at: .bottom, animated: animated)
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
        
        UserDefaults.standard.set(true, forKey: "chatEnded_\(chatID)")
saveMessages()
            navigationController?.popViewController(animated: true)
        showChatEndedLabel()
    }


    // messages functions
    func sendMessage() {
        guard let text = messageTextField.text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let newMessage = ChatMessage(
            text: text,
            isIncoming: false,
            date: Date()
        )

        messages.append(newMessage)
        saveMessages()

        let indexPath = IndexPath(item: messages.count - 1, section: 0)

        collectionView.performBatchUpdates({
            collectionView.insertItems(at: [indexPath])
        }) { _ in
            self.scrollToBottom(animated: true)
        }

        messageTextField.text = ""
        textFieldDidChangeSelection(messageTextField)
    }

    @IBAction func sendTapped(_ sender: UIButton) {
        sendMessage()
    }


    func saveMessages() {
        let key = "chatMessages_\(chatID)"

        let messageDicts: [[String: Any]] = messages.map {
            [
                "text": $0.text,
                "isIncoming": $0.isIncoming,
                "date": $0.date.timeIntervalSince1970
            ]
        }

        UserDefaults.standard.set(messageDicts, forKey: key)
    }


    func loadMessages() {
        let key = "chatMessages_\(chatID)"

        guard let messageDicts =
                UserDefaults.standard.array(forKey: key) as? [[String: Any]]
        else { return }

        let loaded = messageDicts.compactMap { dict -> ChatMessage? in
            guard
                let text = dict["text"] as? String,
                let isIncoming = dict["isIncoming"] as? Bool,
                let timestamp = dict["date"] as? TimeInterval
            else { return nil }

            return ChatMessage(
                text: text,
                isIncoming: isIncoming,
                date: Date(timeIntervalSince1970: timestamp)
            )
        }

        if !loaded.isEmpty {
            messages = loaded
        }
    }
   

//text field functions
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let hasText = !(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }


    @objc func keyboardWillShow(_ notification: Notification) {
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


    @objc func keyboardWillHide(_ notification: Notification) {
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
        loadMessages()
        navigationItem.title = userName
        setupProfilePicture()

 
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

        DispatchQueue.main.async {
            self.scrollToBottom(animated: false)
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
}

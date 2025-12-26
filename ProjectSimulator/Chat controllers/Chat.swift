import UIKit

struct SupportChat {
    let chatID: String
    let senderName: String
    let senderType: String
    let time: String
    let senderProfileURL: String
}


var chatsAfterFilter: [SupportChat] = []
var currentFilter = String ("all")


class Chat: UIViewController,  UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
 
    
 
    @IBOutlet weak var ChatSearch: UISearchBar!
    @IBOutlet weak var ngoButton: UIButton!
    @IBOutlet weak var donorButton: UIButton!
    @IBOutlet weak var allButton: UIButton!
   
    
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
    @IBOutlet weak var ChatTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   

        ChatSearch.delegate = self
       
        
        
        //dismiss keyboard when touching screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        //set table data and delegate
        ChatTable.dataSource = self
        ChatTable.delegate = self
        
        applyFilter(type: "all")
        
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .black

       
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

        for button in buttons {
            button?.configuration = nil
            button?.backgroundColor = .white
            button?.setTitleColor(.black, for: .normal)
            button?.layer.cornerRadius = 16
            button?.layer.borderWidth = 1
            button?.layer.borderColor = UIColor.black.cgColor
        }
    }

     // change color of button when selected/unselected
    func setSelectedFilterButton(_ selected: UIButton) {
        
        let buttons = [allButton, donorButton, ngoButton]

            for button in buttons {
                button?.configuration = nil
                button?.backgroundColor = .clear
                button?.setTitleColor(.black, for: .normal)
                button?.layer.cornerRadius = 16
                button?.layer.borderWidth = 1
                button?.layer.borderColor = UIColor.black.cgColor
                
            }

            selected.backgroundColor = UIColor(red: 0.07, green: 0.39, blue: 0.07, alpha: 1.0)
            selected.setTitleColor(.white, for: .normal)
            selected.layer.cornerRadius = 16
            selected.layer.borderColor = UIColor.black.cgColor
            selected.layer.borderWidth = 1
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupFilterButtonsInitialState()
        switch currentFilter {
            case "donor":
                setSelectedFilterButton(donorButton)
            case "ngo":
                setSelectedFilterButton(ngoButton)
            default:
                setSelectedFilterButton(allButton)
            }

            applyFilter(type: currentFilter)
    }
    
   

    //dummy data
    var allChats: [SupportChat] = [
        SupportChat(
            chatID: "chat_001",
            senderName: "Ahmed Ali",
            senderType: "donor",
            time: "10:12 AM",
            senderProfileURL: ""
        ),
        SupportChat(
            chatID: "chat_002",
            senderName: "Hope Foundation",
            senderType: "ngo",
            time: "Yesterday",
            senderProfileURL: ""
        ),
        SupportChat(
            chatID: "chat_003",
            senderName: "Sara Mohammed",
            senderType: "donor",
            time: "Monday",
            senderProfileURL: ""
        )
    ]

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

        cell.nameLabel.text = chat.senderName
        cell.timeStamp.text = chat.time

        let isEnded = UserDefaults.standard.bool(
            forKey: "chatEnded_\(chat.chatID)"
        )

        cell.EndedLabel.isHidden = !isEnded
        
        let key = "chatMessages_\(chat.chatID)"

        if let messageDicts =
            UserDefaults.standard.array(forKey: key) as? [[String: Any]],
           let lastMessage = messageDicts.last,
           let timestamp = lastMessage["date"] as? TimeInterval {

            let date = Date(timeIntervalSince1970: timestamp)
            cell.timeStamp.text = formatTimestampForChatList(date)

        } else {
            cell.timeStamp.text = ""
        }


        return cell
    }
    //passing chat ID
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chatVC = segue.destination as? ChatViewController,
           let indexPath = ChatTable.indexPathForSelectedRow {

            let chat = visibleChats[indexPath.row]

            chatVC.chatID = chat.chatID
            chatVC.userName = chat.senderName
        }
    }

    //filtering chats
    func applyFilter(type: String) {

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


}

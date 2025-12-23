//
//  NotificationViewController.swift
//  ProjectSimulator
//
//  Created by Zahraa Hubail on 29/11/2025.
//

import UIKit
import FirebaseFirestore


class NotificationsViewController: UIViewController {

    // Outlet connected to the collection view in the storyboard
    @IBOutlet weak var notificationsCollectionView: UICollectionView!
    
    

        
        private let noNotificationsLabel: UILabel = {
            let label = UILabel()
            label.text = "No notifications available"
            label.textAlignment = .center
            label.textColor = .gray
            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            label.isHidden = true
            return label
        }()
        
        var sortedNotifications: [Notification] = []
        
        let db = Firestore.firestore()
        var currentUser: User?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set the screen title
            title = "Notifications"
            
            // Set the data source and delegate for the collection view
            notificationsCollectionView.dataSource = self
            notificationsCollectionView.delegate = self
            
            // Configure the layout of the collection view
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical          // vertical scrolling
            layout.minimumLineSpacing = 10              // space between cells
            notificationsCollectionView.collectionViewLayout = layout
            
            // Adding Clear Button
            navigationItem.title = "Notifications"
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Clear",
                style: .plain,
                target: self,
                action: #selector(clearNotifications)
            )
            
            // Make Clear button red (like before)
            navigationItem.rightBarButtonItem?.tintColor = .red
            
            // Remove default shadow
            navigationController?.navigationBar.shadowImage = UIImage()
            
            // Add small grey line under navigation bar
            let bottomLine = UIView()
            bottomLine.backgroundColor = UIColor.systemGray4
            bottomLine.translatesAutoresizingMaskIntoConstraints = false
            navigationController?.navigationBar.addSubview(bottomLine)

            NSLayoutConstraint.activate([
                bottomLine.heightAnchor.constraint(equalToConstant: 1),
                bottomLine.leadingAnchor.constraint(equalTo: navigationController!.navigationBar.leadingAnchor),
                bottomLine.trailingAnchor.constraint(equalTo: navigationController!.navigationBar.trailingAnchor),
                bottomLine.bottomAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor)
            ])

            // Add the label to the view
            view.addSubview(noNotificationsLabel)
            noNotificationsLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                noNotificationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                noNotificationsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            
            // Preserve section inset like before
            if let layout = notificationsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
            }
            
            // Fetch Firebase data
            fetchCurrentUser { [weak self] success in
                guard let self = self, success else {
                    self?.updateNoNotificationsLabel()
                    return
                }
                self.fetchNotifications()
            }
        }
        
        private func updateNoNotificationsLabel() {
            let hasNotifications = !(sortedNotifications.isEmpty)
            
            noNotificationsLabel.isHidden = hasNotifications
            notificationsCollectionView.isHidden = !hasNotifications
            
            // Enable or disable Clear button based on notifications
            navigationItem.rightBarButtonItem?.isEnabled = hasNotifications
        }

        @objc func clearNotifications() {
            // Step 1: Show confirmation alert
            let confirmAlert = UIAlertController(
                title: "Clear Notifications",
                message: "Are you sure you want to clear notifications?",
                preferredStyle: .alert
            )
            
            // Cancel action (left)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            // Yes action (right)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
                guard let self = self else { return }
                
                // Step 2: Show success alert
                let successAlert = UIAlertController(
                    title: "Success",
                    message: "Notifications have been cleared successfully",
                    preferredStyle: .alert
                )
                
                // Dismiss action
                let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { _ in
                    self.sortedNotifications = [] // Clear the sorted notifications
                    self.notificationsCollectionView.reloadData()
                    self.updateNoNotificationsLabel()
                }

                successAlert.addAction(dismissAction)
                self.present(successAlert, animated: true, completion: nil)
            }
            
            confirmAlert.addAction(cancelAction)
            confirmAlert.addAction(yesAction)
            
            // Show the confirmation alert
            self.present(confirmAlert, animated: true, completion: nil)
        }
        
        
        //To hide the tab bar controller
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            tabBarController?.tabBar.isHidden = true
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            tabBarController?.tabBar.isHidden = false
        }
        
        // MARK: - Firebase
        func fetchCurrentUser(completion: @escaping (Bool) -> Void) {
            let tempUserID = "dlqHfZoVwh50p3Aexu1A" // Replace with a valid user ID

            db.collection("users").document(tempUserID).getDocument { [weak self] snapshot, error in
                if let error = error {
                    print("❌ Error fetching user:", error)
                    completion(false)
                    return
                }

                guard let data = snapshot?.data(),
                      let username = data["username"] as? String,
                      let role = data["role"] as? Int else {
                    print("❌ User data missing or invalid")
                    completion(false)
                    return
                }

                self?.currentUser = User(
                    userID: tempUserID,
                    fullName: data["fullName"] as? String,
                    username: username,
                    role: role,
                    enableNotification: data["enableNotification"] as? Bool ?? true,
                    profile_image_url: data["profile_image_url"] as? String,
                    organization_name: data["organization_name"] as? String
                )

                completion(true)
            }
        }
        
        func fetchNotifications() {
            guard let currentUser = currentUser else {
                updateNoNotificationsLabel()
                return
            }

            db.collection("Notification")
                .order(by: "date", descending: true)
                .getDocuments { [weak self] snapshot, error in
                    guard let self = self else { return }

                    if let error = error {
                        print("❌ Error fetching notifications:", error)
                        self.updateNoNotificationsLabel()
                        return
                    }

                    guard let documents = snapshot?.documents else {
                        self.sortedNotifications = []
                        self.updateNoNotificationsLabel()
                        return
                    }

                    self.sortedNotifications = documents.compactMap { doc -> Notification? in
                        let data = doc.data()
                        guard
                            let title = data["title"] as? String,
                            let description = data["description"] as? String,
                            let timestamp = data["date"] as? Timestamp
                        else {
                            print("❌ Skipped notification: \(data)")
                            return nil
                        }

                        return Notification(
                            title: title,
                            description: description,
                            date: timestamp.dateValue(),
                            userID: data["userID"] as? String ?? ""
                        )
                    }

                    self.notificationsCollectionView.reloadData()
                    self.updateNoNotificationsLabel()
                }
        }
    }

    extension NotificationsViewController: UICollectionViewDataSource {
        
        // Return number of items to display (based on notifications array)
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return sortedNotifications.count
        }

        // Configure each collection view cell
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = notificationsCollectionView.dequeueReusableCell(
                withReuseIdentifier: "NotificationsCollectionViewCell",
                for: indexPath
            ) as! NotificationsCollectionViewCell
            
            let notification = sortedNotifications[indexPath.row]
            cell.setup(with: notification)
            
            return cell
        }
    }

    extension NotificationsViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {

            let isIPad = UIDevice.current.userInterfaceIdiom == .pad
            let horizontalPadding: CGFloat = isIPad ? 80 : 16

            let width = collectionView.bounds.width - horizontalPadding
            return CGSize(width: width, height: 130)
        }
    }

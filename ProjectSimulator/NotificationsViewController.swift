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
    
        // MARK: - Properties
        let db = Firestore.firestore()
        var currentUser: User?

        var sortedNotifications: [Notification] = []

        private let noNotificationsLabel: UILabel = {
            let label = UILabel()
            label.text = "No notifications available"
            label.textAlignment = .center
            label.textColor = .gray
            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            label.isHidden = true
            return label
        }()

        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()

            title = "Notifications"

            notificationsCollectionView.dataSource = self
            notificationsCollectionView.delegate = self

            setupCollectionViewLayout()
            setupNavigationBar()
            setupNoNotificationsLabel()

            fetchCurrentUser { [weak self] success in
                guard let self = self, success else {
                    self?.updateNoNotificationsLabel()
                    return
                }
                self.fetchNotifications()
            }
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
            navigationController?.navigationBar.prefersLargeTitles = true
        }

        // MARK: - UI Setup
        private func setupCollectionViewLayout() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 12
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            notificationsCollectionView.collectionViewLayout = layout
        }

        private func setupNavigationBar() {
            let clearButton = UIBarButtonItem(
                title: "Clear",
                style: .plain,
                target: self,
                action: #selector(clearNotifications)
            )
            navigationItem.rightBarButtonItem = clearButton
        }

        private func setupNoNotificationsLabel() {
            view.addSubview(noNotificationsLabel)
            noNotificationsLabel.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                noNotificationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                noNotificationsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }

        // MARK: - Firebase
        func fetchCurrentUser(completion: @escaping (Bool) -> Void) {
            let tempUserID = "dlqHfZoVwh50p3Aexu1A" // TEMP user (same as Donation VC)

            db.collection("users").document(tempUserID).getDocument { [weak self] snapshot, error in
                if let error = error {
                    print("❌ Error fetching user:", error)
                    completion(false)
                    return
                }

                guard let data = snapshot?.data(),
                      let username = data["username"] as? String,
                      let role = data["role"] as? Int else {
                    completion(false)
                    return
                }

                self?.currentUser = User(
                    userID: tempUserID,
                    username: username,
                    role: role,
                    profile_image_url: data["profile_img"] as? String
                )

                completion(true)
            }
        }

        func fetchNotifications() {
            guard let currentUser = currentUser else {
                updateNoNotificationsLabel()
                return
            }

            db.collection("notifications")
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
                            let userID = data["userID"] as? String,
                            userID == currentUser.userID,
                            let title = data["title"] as? String,
                            let description = data["description"] as? String,
                            let timestamp = data["date"] as? Timestamp
                        else {
                            return nil
                        }

                        return Notification(
                            title: title,
                            description: description,
                            date: timestamp.dateValue(),
                            userID: userID
                        )
                    }

                    self.notificationsCollectionView.reloadData()
                    self.updateNoNotificationsLabel()
                }
        }

        // MARK: - UI Helpers
        private func updateNoNotificationsLabel() {
            if sortedNotifications.isEmpty {
                noNotificationsLabel.isHidden = false
                notificationsCollectionView.isHidden = true
            } else {
                noNotificationsLabel.isHidden = true
                notificationsCollectionView.isHidden = false
            }
        }

        // MARK: - Actions
        @objc func clearNotifications() {
            let confirmAlert = UIAlertController(
                title: "Clear Notifications",
                message: "Are you sure you want to clear notifications?",
                preferredStyle: .alert
            )

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
                guard let self = self else { return }

                let successAlert = UIAlertController(
                    title: "Success",
                    message: "Notifications have been cleared successfully",
                    preferredStyle: .alert
                )

                let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { _ in
                    self.sortedNotifications = []
                    self.notificationsCollectionView.reloadData()
                    self.updateNoNotificationsLabel()
                }

                successAlert.addAction(dismissAction)
                self.present(successAlert, animated: true)
            }

            confirmAlert.addAction(cancelAction)
            confirmAlert.addAction(yesAction)
            present(confirmAlert, animated: true)
        }
    }

    // MARK: - UICollectionViewDataSource
    extension NotificationsViewController: UICollectionViewDataSource {

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return sortedNotifications.count
        }

        func collectionView(
            _ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "NotificationCollectionViewCell",
                for: indexPath
            ) as! NotificationsCollectionViewCell

            let notification = sortedNotifications[indexPath.item]
            cell.setup(with: notification)
            return cell
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    extension NotificationsViewController: UICollectionViewDelegateFlowLayout {

        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
        ) -> CGSize {

            let width = collectionView.bounds.width - 32
            return CGSize(width: width, height: 90)
        }
    }

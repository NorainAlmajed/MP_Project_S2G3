//
//  NotificationViewController.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 29/11/2025.
//

import UIKit

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
        
        
        //Adding Clear Button
        navigationItem.title = "Notifications"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Clear",
            style: .plain,
            target: self,
            action: #selector(clearNotifications)
            )
        //Make the color of the clear button red
        navigationItem.rightBarButtonItem?.tintColor = .red
        
        //Add the lable to the view
        view.addSubview(noNotificationsLabel)
        noNotificationsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noNotificationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNotificationsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        updateNoNotificationsLabel()
        
    }
    
    private func updateNoNotificationsLabel() {
            if user.notifications.isEmpty {
                noNotificationsLabel.isHidden = false
                notificationsCollectionView.isHidden = true
            } else {
                noNotificationsLabel.isHidden = true
                notificationsCollectionView.isHidden = false
            }
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
                // Step 3: Clear notifications after success alert is dismissed
                user.notifications.removeAll()
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

    
    //Hiding the tab bar controller
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    
}

extension NotificationsViewController: UICollectionViewDataSource {
    
    // Return number of items to display (based on notifications array)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.notifications.count
    }
    
    // Configure each collection view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Dequeue a reusable cell of type NotificationCollectionViewCell
        let cell = notificationsCollectionView.dequeueReusableCell(withReuseIdentifier: "NotificationsCollectionViewCell", for: indexPath) as! NotificationsCollectionViewCell
        
        // Pass the notification data to the cell
        cell.setup(with: user.notifications[indexPath.row])
        return cell
    }
    
    
}

extension NotificationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 376, height: 124)
    }
}




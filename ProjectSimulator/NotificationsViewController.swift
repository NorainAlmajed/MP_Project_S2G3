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

        // Do any additional setup after loading the view.
    }
    
}

extension NotificationsViewController: UICollectionViewDataSource {
    
    // Return number of items to display (based on notifications array)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notifications.count
    }
    
    // Configure each collection view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Dequeue a reusable cell of type NotificationCollectionViewCell
        let cell = notificationsCollectionView.dequeueReusableCell(withReuseIdentifier: "NotificationsCollectionViewCell", for: indexPath) as! NotificationsCollectionViewCell
        
        // Pass the notification data to the cell
        cell.setup(with: notifications[indexPath.row])
        return cell
    }
}

extension NotificationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 376, height: 124)
    }
}




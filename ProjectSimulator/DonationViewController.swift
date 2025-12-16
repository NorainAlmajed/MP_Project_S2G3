//
//  DonationViewController.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 29/11/2025.
//

import UIKit

class DonationViewController: UIViewController {

    // Outlet connected to the collection view in the storyboard
    @IBOutlet weak var donationsCollectionView: UICollectionView!
    
    @IBOutlet weak var statusCollectionView: UICollectionView!
    
    let statuses = ["All", "Pending", "Accepted", "Collected", "Rejected", "Cancelled"]
    var selectedIndex = 0

    //Declaring arrays for filtering donations
    var allDonations: [Donation] = []
    var displayedDonations: [Donation] = []

    
    
    private let noDonationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No donations available"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.isHidden = true
        return label
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize fake data. Remove later !!!! ‼️‼️‼️‼️‼️‼️‼️
        user.donations = [
            Donation(donationID: 91475, ngo: ngo1, creationDate: Date(), donor: user, address: Address(building: 1311, road: 3027, block: 430, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "8AM - 9PM", foodImage: UIImage(named: "apples") ?? UIImage(), status: 1, Category: 1, quantity: 30, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor", recurrence: 1),
            
            Donation(donationID: 88888, ngo: ngo2, creationDate: Date().addingTimeInterval(-1200), donor: user, address: Address(building: 1111, road: 2222, block: 3333, flat: 402, area: "Seef", governorate: "North"), pickupDate: Date(), pickupTime: "12AM - 2PM", foodImage: UIImage(named: "apples") ?? UIImage(), status: 2, Category: 2, quantity: 88, weight: 8.8, expiryDate: Date(), rejectionReason: "The food does not meet the quality standards.", recurrence: 3),
            
            Donation(donationID: 91475, ngo: ngo2, creationDate: Date().addingTimeInterval(-350), donor: user, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 3, Category: 3, quantity: 30, weight: nil, expiryDate: Date(), description: "   ", rejectionReason: "   "),
            
            Donation(donationID: 91475, ngo: ngo1, creationDate: Date().addingTimeInterval(-300), donor: user, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 4, Category: 4, quantity: 30, weight: 18.8, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor", rejectionReason: "The food does not meet the quality standards, it's not ripe enough."),
            
            Donation(donationID: 91475, ngo: ngo2, creationDate: Date().addingTimeInterval(-200), donor: user, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 5, Category: 5, quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
            
            Donation(donationID: 91475, ngo: ngo1, creationDate: Date().addingTimeInterval(-800), donor: user, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 1, Category: 6, quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
            
            Donation(donationID: 91475, ngo: ngo1, creationDate: Date().addingTimeInterval(-500), donor: user, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 2, Category: 7, quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor")
        ]

        //Initializaing the donations list
        allDonations = user.donations ?? []
        displayedDonations = allDonations.sorted { $0.creationDate > $1.creationDate }

        
        // Sort donations by creationDate (newest first)
        user.donations?.sort { $0.creationDate > $1.creationDate }
                
        // Set the screen title
        title = "Donations"
        
        
        
        // Set the data source and delegate for the collection views
        donationsCollectionView.dataSource = self
        donationsCollectionView.delegate = self
        
        statusCollectionView.dataSource = self
        statusCollectionView.delegate = self

        
        
        // Configure the layout of the collection views
        //Donation collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical          // vertical scrolling
        layout.minimumLineSpacing = 10              // space between cells
        donationsCollectionView.collectionViewLayout = layout

        donationsCollectionView.backgroundColor = self.view.backgroundColor
        

        //Statsu collection view
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout2.minimumLineSpacing = 8
        layout2.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        // Add padding on left and right
        layout2.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

            statusCollectionView.collectionViewLayout = layout2
        

        
        
        
        //Make the navigation bar color not white while scroling
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = view.backgroundColor

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        view.addSubview(noDonationsLabel)
        noDonationsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noDonationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDonationsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        //Run the method
        updateNoDonationsLabel()

    }
    
    //Function to add a label when there are no donations available
    private func updateNoDonationsLabel() {
        if (user.donations ?? []).isEmpty {
            noDonationsLabel.isHidden = false
            donationsCollectionView.isHidden = true
        } else {
            noDonationsLabel.isHidden = true
            donationsCollectionView.isHidden = false
        }
    }


    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    
     //Prepare data for the destination VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDonationDetails" {
            if let detailsVC = segue.destination as? DonationDetailsViewController {
                if let indexPath = donationsCollectionView.indexPathsForSelectedItems?.first {
                    let donation = displayedDonations[indexPath.row]
                    detailsVC.donation = donation
                }
                
                // <-- This line hides the bottom tab bar
                detailsVC.hidesBottomBarWhenPushed = true
            }
        }
    }
    
        //To let the title appear in a big form
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
                
            navigationController?.setNavigationBarHidden(false, animated: animated)
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            title = "Donations"
            
            // ← Add this line to refresh the collection view
               donationsCollectionView.reloadData()
        }
    
    
    
    //method for filtering the donations
    private func filterDonations() {
        if selectedIndex == 0 {
            displayedDonations = allDonations.sorted { $0.creationDate > $1.creationDate }
        } else {
            let statusToFilter = selectedIndex
            displayedDonations = allDonations.filter { $0.status == statusToFilter }
                .sorted { $0.creationDate > $1.creationDate }
        }
        donationsCollectionView.reloadData()
        updateNoDonationsLabel()
    }

    
    
    
    
}

extension DonationViewController: UICollectionViewDataSource {
    
    // Return number of items to display (based on arrays)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == statusCollectionView {
            return statuses.count
        } else { // donationsCollectionView
            return displayedDonations.count
        }
    }


    
    // Configure each collection view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == statusCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusCell", for: indexPath) as! StatusCollectionViewCell
            cell.configure(title: statuses[indexPath.item], isSelected: indexPath.item == selectedIndex)

            // Handle the tap
            cell.onStatusTapped = { [weak self] in
                guard let self = self else { return }
                self.selectedIndex = indexPath.item
                self.filterDonations()
                self.statusCollectionView.reloadData()
            }


            return cell
        } else { // donationsCollectionView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DonationCollectionViewCell", for: indexPath) as! DonationCollectionViewCell
            let donation = displayedDonations[indexPath.row]
            cell.setup(with: donation)

            return cell
        }
    }
    
    
}



extension DonationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 376, height: 124)
    }
    
}





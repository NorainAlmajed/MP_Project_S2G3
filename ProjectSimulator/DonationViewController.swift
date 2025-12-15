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
            
                        Donation(donationID: 88888, ngo: ngo2, creationDate: Date(), donor: user, address: Address(building: 1111, road: 2222, block: 3333, flat: 402, area: "Seef", governorate: "North"), pickupDate: Date(), pickupTime: "12AM - 2PM", foodImage: UIImage(named: "apples") ?? UIImage(), status: 2, Category: 2, quantity: 88, weight: 8.8, expiryDate: Date(), rejectionReason: "The food does not meet the quality standards.", recurrence: 3),
            
                        Donation(donationID: 91475, ngo: ngo2, creationDate: Date(), donor: user, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 3, Category: 3, quantity: 30, weight: nil, expiryDate: Date(), description: "   ", rejectionReason: "   ", ),
            
                        Donation(donationID: 91475, ngo: ngo1, creationDate: Date(), donor: user, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 4, Category: 4, quantity: 30, weight: 18.8, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor", rejectionReason: "The food does not meet the quality standards, it's not ripe enough."),
            
                        Donation(donationID: 91475, ngo: ngo2, creationDate: Date(), donor: user, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 5, Category: 5, quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
            
                        Donation(donationID: 91475, ngo: ngo1, creationDate: Date(), donor: user, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 1, Category: 6, quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor"),
            
                        Donation(donationID: 91475, ngo: ngo1, creationDate: Date(), donor: user, address: Address(building: 1311, road: 3027, block: 430, flat: 402, area: "Karbabad", governorate: "Manama"), pickupDate: Date(), pickupTime: "12:00:00", foodImage: UIImage(named: "apples") ?? UIImage(), status: 2, Category: 7, quantity: 30, weight: nil, expiryDate: Date(), description: "Fresh red apples, locally grown and rich in flavor")
                    ]
                
        // Set the screen title
        title = "Donations"
        
        // Set the data source and delegate for the collection view
        donationsCollectionView.dataSource = self
        donationsCollectionView.delegate = self
        
        // Configure the layout of the collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical          // vertical scrolling
        layout.minimumLineSpacing = 10              // space between cells
        donationsCollectionView.collectionViewLayout = layout

        donationsCollectionView.backgroundColor = self.view.backgroundColor
        
        
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
        super.viewDidLayoutSubviews()    }
    
    
     //Prepare data for the destination VC
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showDonationDetails" {
                let detailsVC = segue.destination as! DonationDetailsViewController
    
                if let indexPath = donationsCollectionView.indexPathsForSelectedItems?.first,
                   let donation = user.donations?[indexPath.row] {
                    detailsVC.donation = donation
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
    
    
    
}

extension DonationViewController: UICollectionViewDataSource {
    
    // Return number of items to display (based on donations array)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.donations?.count ?? 0
    }

    
    // Configure each collection view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = donationsCollectionView.dequeueReusableCell(withReuseIdentifier: "DonationCollectionViewCell", for: indexPath) as! DonationCollectionViewCell

        // Optional binding to safely unwrap donation
        if let donation = user.donations?[indexPath.row] {
            cell.setup(with: donation)
        }

        return cell
    }

}

extension DonationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 376, height: 124)
    }
    
}





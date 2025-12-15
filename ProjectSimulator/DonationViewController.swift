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
        if user.donations.isEmpty {
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
    
                if let indexPath = donationsCollectionView.indexPathsForSelectedItems?.first {
                    detailsVC.donation = user.donations[indexPath.row]
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
        return user.donations.count
    }
    
    // Configure each collection view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Dequeue a reusable cell of type DonationCollectionViewCell
        let cell = donationsCollectionView.dequeueReusableCell(withReuseIdentifier: "DonationCollectionViewCell", for: indexPath) as! DonationCollectionViewCell
        
        // Pass the donation data to the cell
        cell.setup(with: user.donations[indexPath.row])
        return cell
    }
}

extension DonationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 376, height: 124)
    }
    
}





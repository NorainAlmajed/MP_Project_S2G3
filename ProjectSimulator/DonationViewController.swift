//
//  DonationViewController.swift
//  ProjectSimulator
//
//  Created by Fatema Mohamed Amin Jaafar Hasan Hubail on 29/11/2025.
//

import UIKit

class DonationViewController: UIViewController {

    
    @IBOutlet weak var donationsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Donations"
        
        donationsCollectionView.dataSource = self
        donationsCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical          // vertical scrolling
        layout.minimumLineSpacing = 10              // space between cells
        donationsCollectionView.collectionViewLayout = layout

        // Do any additional setup after loading the view.
    }
    
}

extension DonationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return donations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = donationsCollectionView.dequeueReusableCell(withReuseIdentifier: "DonationCollectionViewCell", for: indexPath) as! DonationCollectionViewCell
        cell.setup(with: donations[indexPath.row])
        return cell
    }
}

extension DonationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 376, height: 124)
    }
}




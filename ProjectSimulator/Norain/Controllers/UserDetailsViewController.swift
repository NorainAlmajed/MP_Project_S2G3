//
//  DetailsViewController.swift
//  ProjectSimulator
//
//  Created by Norain  on 21/12/2025.
//

import UIKit
import FirebaseFirestore

protocol UserUpdateDelegate: AnyObject {
    func didUpdateUser()
}

class UserDetailsViewController: UIViewController {
    var currentUser: NorainAppUser?
    weak var delegate: UserUpdateDelegate?
    private let db = Firestore.firestore()
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var bioOrDescLbl: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var bioOrDesctxt: UITextView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var userImgV: UIImageView!
    @IBOutlet weak var phoneOrStatusLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    
    @IBOutlet weak var acceptBtnWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = currentUser {
            fetchUserFromFirestore(docID: user.documentID)
        }
    }
    
    // MARK: - Firebase Read
    private func fetchUserFromFirestore(docID: String) {
        db.collection("users").document(docID).getDocument{ [weak self] (document, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Error fetching user details: \(error.localizedDescription)")
                // Fallback to local data
                if let user = self.currentUser {
                    self.configure(appUser: user)
                }
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                print("⚠️ Document does not exist")
                if let user = self.currentUser {
                    self.configure(appUser: user)
                }
                return
            }
            
            // Parse user from Firestore data
            let role = data["role"] as? Int ?? 0
            
            if role == 3 { // NGO
                let ngo = self.mapToNGO(documentID: document.documentID, data: data)
                self.currentUser = ngo
                self.configure(appUser: ngo)
            } else if role == 2 { // Donor
                let donor = self.mapToDonor(documentID: document.documentID, data: data)
                self.currentUser = donor
                self.configure(appUser: donor)
            }
            
            print("✅ User details fetched from Firestore")
        }
    }
    
    private func mapToNGO(documentID: String,data: [String: Any]) -> NorainNGO {
        return NorainNGO(documentID: documentID, dictionary: data)
    }
    
    private func mapToDonor(documentID: String,data: [String: Any]) -> NorainDonor {
        return NorainDonor(documentID: documentID, dictionary: data)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configure(appUser: NorainAppUser) {
        guard isViewLoaded else { return }
        self.currentUser = appUser
        
        nameLbl.text = appUser.name
        emailLbl.text = appUser.email
        
        bioOrDesctxt.layer.cornerRadius = 7
        bioOrDesctxt.layer.borderWidth = 1
        bioOrDesctxt.layer.borderColor = UIColor.systemGray.cgColor
        
        userImgV.layer.cornerRadius = 7
        userImgV.clipsToBounds = true
        userImgV.layer.borderWidth = 1
        userImgV.layer.borderColor = UIColor.systemGray.cgColor
        
        if !appUser.userImg.isEmpty {
                // Show a placeholder while the image loads
                self.userImgV.image = UIImage(systemName: "person.circle.fill")
                
                FetchImage.fetchImage(from: appUser.userImg) { [weak self] downloadedImage in
                    // Ensure the cell/view is still visible before setting the image
                    if let image = downloadedImage {
                        self?.userImgV.image = image
                    }
                }
            } else {
                // Fallback for users with no profile picture
                self.userImgV.image = UIImage(systemName: "person.circle.fill")
            }
        
        if let donor = appUser as? NorainDonor {
            phoneOrStatusLbl.text = donor.phoneNumber.description
            bioOrDescLbl.text = "Bio"
            bioOrDesctxt.text = donor.bio
            acceptBtn.isHidden = true
            rejectBtn.isHidden = true
            reasonLabel.isHidden = true
            
        } else if let ngo = appUser as? NorainNGO {
            bioOrDescLbl.text = "Mission"
            bioOrDesctxt.text = ngo.mission
            
            switch ngo.status {
            case .pending:
                phoneOrStatusLbl.text = "Pending"
                phoneOrStatusLbl.textColor = UIColor(named: "orangeCol")
                reasonLabel.isHidden = true
                acceptBtn.isHidden = false
                rejectBtn.isHidden = false
                
            case .rejected:
                
                phoneOrStatusLbl.text = "Rejected"
                phoneOrStatusLbl.textColor = .red
                reasonLabel.text = "Reason: \(ngo.rejectionReason ?? "None")"
                reasonLabel.isHidden = false
                acceptBtn.isHidden = true
                rejectBtn.isHidden = true
                
            case .approved:
                acceptBtnWidthConstraint.constant = 143
                phoneOrStatusLbl.text = "Approved"
                phoneOrStatusLbl.textColor = UIColor(named: "greenCol")
                reasonLabel.isHidden = true
                acceptBtn.isHidden = true
                rejectBtn.isHidden = true
                

            }
        }
    }
    
    // MARK: - Firebase Write (Accept)
    @IBAction func acceptBtn(_ sender: Any) {
        guard let ngo = currentUser as? NorainNGO else { return }
        
        acceptBtn.isEnabled = false
        acceptBtn.setTitle("Accepting...", for: .normal)
        
        db.collection("users").document(ngo.documentID).updateData([
                "status": NGOStatus.approved.rawValue,
                "rejectionReason": ""
            ]){ [weak self] error in
            guard let self = self else { return }
            
            self.acceptBtn.isEnabled = true
            self.acceptBtn.setTitle("Accept", for: .normal)
            
            if let error = error {
                print("❌ Error accepting NGO: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "Failed to accept NGO: \(error.localizedDescription)")
            } else {
                print("✅ NGO accepted successfully")
                ngo.status = .approved
                ngo.rejectionReason = nil
                self.configure(appUser: ngo)
                self.delegate?.didUpdateUser()
                self.showAlert(title: "Success", message: "NGO has been approved!")
            }
        }
    }
    
    // MARK: - Firebase Write (Reject)
    @IBAction func rejectBtn(_ sender: Any) {
        Alerts.confirmation(on: self, title: "NGO Rejection", message: "Are you sure you want to reject this NGO?") { [weak self] in
            guard let self = self, let ngo = self.currentUser as? NorainNGO else { return }
            
            // Show rejection popup to get reason
            self.showRejectionPopup()
        }
    }
    
    @IBAction func editBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "norain-admin-controls1", bundle: nil)
        
        guard let editVC = storyboard.instantiateViewController(withIdentifier: "EditUsersViewController") as? EditUsersViewController else { return }
        
        if let user = self.currentUser {
            print("Passing user: \(user.name) of type: \(type(of: user))")
            editVC.userToEdit = user
        }
        editVC.delegate = self
        let nav = UINavigationController(rootViewController: editVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func showRejectionPopup() {
        let storyboard = UIStoryboard(name: "norain-admin-controls1", bundle: nil)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: "RejectionPopupViewController") as? RejectionPopupViewController {
            popupVC.delegate = self
            popupVC.modalPresentationStyle = .overCurrentContext
            self.present(popupVC, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - RejectionDelegate
extension UserDetailsViewController: RejectionDelegate {
    func didProvideReason(_ reason: String) {
        guard let ngo = self.currentUser as? NorainNGO else { return }
        
        let finalReason = reason.isEmpty ? "No specific reason provided." : reason
        
        rejectBtn?.isEnabled = false
        rejectBtn?.setTitle("Rejecting...", for: .normal)
        
        db.collection("users").document(ngo.documentID).updateData([
                    "status": NGOStatus.rejected.rawValue,
                    "rejectionReason": finalReason
                ]) { [weak self] error in
            guard let self = self else { return }
            
            self.rejectBtn?.isEnabled = true
            self.rejectBtn?.setTitle("Reject", for: .normal)
            
            if let error = error {
                print("❌ Error rejecting NGO: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "Failed to reject NGO: \(error.localizedDescription)")
            } else {
                print("✅ NGO rejected successfully")
                ngo.status = .rejected
                ngo.rejectionReason = finalReason
                self.configure(appUser: ngo)
                self.delegate?.didUpdateUser()
                self.showAlert(title: "Rejected", message: "NGO has been rejected.")
            }
        }
    }
}
// MARK: - EditUserDelegate
extension UserDetailsViewController: EditUserDelegate {
    func didUpdateUser() {
        guard let user = currentUser else { return }
        
        // Re-fetch the latest data from Firestore to ensure the UI is in sync
        fetchUserFromFirestore(docID: user.documentID)
        
        // Notify the previous screen (the list) to refresh as well
        self.delegate?.didUpdateUser()
    }
}

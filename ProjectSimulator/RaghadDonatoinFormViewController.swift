//
//  RaghadDonatoinFormViewController.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 13/12/2025.
//

import UIKit

//class RaghadDonatoinFormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    
    
class RaghadDonatoinFormViewController: UIViewController,
                                       UITableViewDelegate,
                                       UITableViewDataSource,
                                       UIImagePickerControllerDelegate,
                                       UINavigationControllerDelegate,
                                        RaghadSection1TableViewCellDelegate,
                                        DonorSelectionDelegate {
    
    
    
    @IBOutlet weak var donationFormTableview: UITableView!
    // ✅ Stores the selected image so it doesn’t disappear when you scroll
    private var selectedDonationImage: UIImage?////new
    // ✅ NEW: store selected donor name (to show on Section2 button)
    private var selectedDonorName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        donationFormTableview.delegate = self
        donationFormTableview.dataSource = self
        
        self.title = "Donation Form"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        
        // dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // (optional but recommended)
        donationFormTableview.keyboardDismissMode = .onDrag
        
        addDoneButtonOnKeyboard()
        
        
    }
    
    
    
    func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                   target: nil,
                                   action: nil)
        
        let done = UIBarButtonItem(title: "Done",
                                   style: .done,
                                   target: self,
                                   action: #selector(doneButtonTapped))
        
        toolbar.items = [flex, done]
        
        // attach to all textfields in this view
        view.subviews.forEach { view in
            if let textField = view as? UITextField {
                textField.inputAccessoryView = toolbar
            }
        }
    }
    
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func doneButtonTapped() { //to add done in the keyboard
        view.endEditing(true)
    }
    
    
    
    
    //    func numberOfSections(in donationFormTableview: UITableView) -> Int {
    //        return 8   // or any number you want
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }//he told me to put this insatde of thr one in the tpop
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
 
    
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // ✅ Section 1 only
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Section1Cell",
                                                           for: indexPath) as? RaghadSection1TableViewCell else {
                fatalError("Section1Cell not found OR class not set to RaghadSection1TableViewCell in storyboard")
            }
            
            cell.selectionStyle = .none
            cell.delegate = self
            
            if let img = selectedDonationImage {
                cell.Donation_ImageView.image = img
            }
            
            return cell
        }
        
        
        if indexPath.section == 1 {
                 guard let cell = tableView.dequeueReusableCell(withIdentifier: "Section2Cell", for: indexPath) as? RaghadSection2TableViewCell else {
                     fatalError("Section2Cell not found OR class not set to RaghadSection2TableViewCell in storyboard")
                 }

                 cell.selectionStyle = .none

                 // ✅ NEW: show selected donor name on the button (or default)
                 cell.configure(donorName: selectedDonorName)

                 // ✅ NEW: button tap opens donor list page
                 cell.btnChooseDonor2.removeTarget(nil, action: nil, for: .allEvents) // avoids double-taps
                 cell.btnChooseDonor2.addTarget(self, action: #selector(openDonorList), for: .touchUpInside)

                 return cell
             }

        
        
        
        
        
        
        
        
        
        // ✅ Other sections (3..8)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Section\(indexPath.section + 1)Cell",
                                                 for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    
    
    
   
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 195   // Section1Cell
        case 1:
            return 94   // Section2Cell
        case 2:
            return 140   // Section3Cell
        case 3:
            return 180   // Section4Cell
        case 4:
            return 160   // Section5Cell
        case 5:
            return 220   // Section6Cell
        case 6:
            return 160   // ✅ Section7Cell (choose height)
        case 7:
            return 400  // ✅ Section8Cell (choose height)
        default:
            return 44
        }
    }
    
    // ✅ NEW: open donor list page (present as modal with nav bar)
    @objc private func openDonorList() {
        let sb = UIStoryboard(name: "Raghad1", bundle: nil)
        let vc = sb.instantiateViewController(
            withIdentifier: "RaghadDonorListViewController"
        ) as! RaghadDonorListViewController

        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }

    
    // ✅ NEW: receive chosen donor name from donor list (Done button)
               func didSelectDonor(name: String) {
                    selectedDonorName = name

                 // refresh only Section 2 so button updates
                                                   donationFormTableview.reloadSections(IndexSet(integer: 1), with: .none)
                                               }

    
    
    //  NEW: resize image (THIS is what tutors like)
    private func resizedImage(_ image: UIImage, maxWidth: CGFloat) -> UIImage {

        // If already small, don’t resize
        if image.size.width <= maxWidth { return image }

        let scale = maxWidth / image.size.width
        let newSize = CGSize(
            width: maxWidth,
            height: image.size.height * scale
        )

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resized ?? image
    }

    
    
    
    
    
    
    
    // ✅ Delegate method from Section 1 cell
    func section1DidTapUploadImage(_ cell: RaghadSection1TableViewCell) {
        
        let alert = UIAlertController(title: "Upload Image",
                                      message: "Choose a source",
                                      preferredStyle: .actionSheet)
        
        // ✅ Camera option (only shows if available)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Take Photo (Camera)", style: .default) { [weak self] _ in
                self?.openImagePicker(sourceType: .camera)
            })
        }
        
        // ✅ Photo Library option
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.openImagePicker(sourceType: .photoLibrary)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // ✅ Prevents iPad crash for actionSheet
        if let popover = alert.popoverPresentationController {
            popover.sourceView = cell
            popover.sourceRect = cell.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = true // user can crop
        present(picker, animated: true)
    }
    
    // ✅ User picked an image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let img = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        
        if let img = img {

            // ✅ NEW: resize image before saving (change 900 if you want)
            let resized = resizedImage(img, maxWidth: 900)

            selectedDonationImage = resized

            // ✅ refresh only Section 1
            donationFormTableview.reloadSections(IndexSet(integer: 0), with: .none)
        }
        
        
        
        
        
        picker.dismiss(animated: true)
    }
    
    // ✅ User cancelled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    
    
    
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    
    }*/



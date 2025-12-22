//
//  EditUsersViewController.swift
//  ProjectSimulator
//
//  Created by Norain  on 19/12/2025.
//

import UIKit

class EditUsersViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var btnCause: UIButton!
    
    @IBOutlet weak var ImagePickerEditView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let cause = UIMenu(title: "NGO Cause",children: [
            UIAction(title: "Option 1") { _ in /* Handle */ },
            UIAction(title: "Option 2") { _ in /* Handle */ }
        ])
        btnCause.menu = cause
        btnCause.showsMenuAsPrimaryAction=true
        // Do any additional setup after loading the view.
    }

    @IBAction func btnImageEditPicker(_ sender: Any) {
        showPhotoAlert()
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func showPhotoAlert(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {action
            in
            
            
        }))

        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {action in
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        ImagePickerEditView.image = image
        dismiss(animated: true)
    }
    
    @IBAction func btnCause(_ sender: Any) {
    }
   
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

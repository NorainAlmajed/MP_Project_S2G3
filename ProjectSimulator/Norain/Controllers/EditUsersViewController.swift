//
//  EditUsersViewController.swift
//  ProjectSimulator
//
//  Created by Norain  on 19/12/2025.
//

import UIKit

class EditUsersViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    @IBOutlet weak var btnCause: UIButton!
    var userToEdit:AppUser!
    
 
    @IBOutlet weak var causeStack: UIStackView!
    
    @IBOutlet weak var addressStack: UIStackView!
    
    @IBOutlet weak var govStack: UIStackView!
    
    @IBOutlet weak var statusStack: UIStackView!
    
    @IBOutlet weak var licenseBtn: UIButton!
    
    @IBOutlet weak var ImagePickerEditView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = (userToEdit is NGO) ? "NGO Profile" : "Donor Profile"
            
            // Add a 'Save' button to the right side of the bar
            let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped))
            self.navigationItem.rightBarButtonItem = saveButton

//        let cause = UIMenu(title: "NGO Cause",children: [
//            UIAction(title: "Option 1") { _ in /* Handle */ },
//            UIAction(title: "Option 2") { _ in /* Handle */ }
//        ])
//        btnCause.menu = cause
//        btnCause.showsMenuAsPrimaryAction=true
        // Do any additional setup after loading the view.
    }
    @objc func saveTapped() {
        // Your logic to save changes and then go back
        navigationController?.popViewController(animated: true)
        
        
        
        
        

    func setupView() {
        let isNGO = userToEdit is NGO
        causeStack.isHidden = !isNGO
        addressStack.isHidden = !isNGO
        govStack.isHidden = !isNGO
        statusStack.isHidden = !isNGO
        licenseBtn.isHidden = !isNGO
    }


    
    func showPhotoAlert(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {action
            in
            self.getPhoto(type: .camera)
            
            
        }))

        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {action in
            self.getPhoto(type: .photoLibrary)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func getPhoto(type:UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            print("Image not found")
            return  }
        ImagePickerEditView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
   
    
//    @IBAction func btnCause(_ sender: Any) {
    }
   
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



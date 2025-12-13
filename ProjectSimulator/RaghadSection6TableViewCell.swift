//
//  RaghadSection6TableViewCell.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 14/12/2025.
//

import UIKit
//Expiry date
class RaghadSection6TableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var txtExpiryDate: UITextField!

      private let datePicker = UIDatePicker()
      private let formatter = DateFormatter()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        formatter.dateFormat = "dd/MM/yyyy"

        setupDatePicker()
        setupToolbar()

        // ✅ start from today
        datePicker.date = Date()
        txtExpiryDate.text = formatter.string(from: Date())
    }



    
    private func setupDatePicker() {
          if #available(iOS 13.4, *) {
              datePicker.preferredDatePickerStyle = .wheels
          }
          datePicker.datePickerMode = .date
          datePicker.minimumDate = Date() // prevents past dates

          // ✅ No keyboard: show picker instead of keyboard
          txtExpiryDate.inputView = datePicker
      }

      private func setupToolbar() {
          let toolbar = UIToolbar()
          toolbar.sizeToFit()

          let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
          let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))

          toolbar.items = [flex, done]
          txtExpiryDate.inputAccessoryView = toolbar
      }

      @objc private func doneTapped() {
          txtExpiryDate.text = formatter.string(from: datePicker.date)
          txtExpiryDate.resignFirstResponder()
      }
  
     
  
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

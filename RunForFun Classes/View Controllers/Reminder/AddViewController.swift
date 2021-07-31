//
//  AddViewController.swift
//  RunForFun
//
//  Created by Константин Малков on 25.10.2020.
//  Copyright © 2020 Malkov Kostia. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!

  
  
    public var completion: ((String, String, Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        let toolBar = UIToolbar()//добавление кнопки done над клавиатурой
        toolBar.sizeToFit()
        
      
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(didTapSaveButton))
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      
        toolBar.setItems([flexSpace, doneButton], animated: true)
      
        titleField.inputAccessoryView = toolBar
        bodyField.inputAccessoryView = toolBar
      
        titleField.delegate = self
        bodyField.delegate = self
        
    }
    
  @objc func doneClicked() {
      view.endEditing(true)
  }
  
    
    @objc func didTapSaveButton() {
        if let titleText = titleField.text, !titleText.isEmpty,
            let bodyText = bodyField.text, !bodyText.isEmpty {
            
            let targetDate = datePicker.date

            completion?(titleText, bodyText, targetDate)

        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

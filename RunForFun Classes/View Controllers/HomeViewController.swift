//
//  HomeViewController.swift
//  RunForFun
//
//  Created by Константин Малков on 01.08.2020.
//  Copyright © 2020 Malkov Kostia. All rights reserved.
//

import UIKit
//import HealthKit

class HomeViewController: UIViewController {
  
 
  
  @IBAction func authorizeButton() {
    authorizeHealthKit()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  private func authorizeHealthKit() {
    HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
      guard authorized else {
        let baseMessage = "Ошибка авторизации"
        
        if let error = error {
          print("\(baseMessage). Reason: \(error.localizedDescription)" )
        } else {
          print(baseMessage)
        }
        return
      }
      print("Авторизация прошла успешно")
    }
    
  }
  
}

//
//  ProfileTableViewController.swift
//  RunForFun
//
//  Created by Константин Малков on 16.09.2020.
//  Copyright © 2020 Malkov Kostia. All rights reserved.
//


import UIKit
import HealthKit

class ProfileViewController: UITableViewController {
    
  
  
  private enum ProfileSection: Int {
    case ageSexBloodType
    case weightHeightBMI
    case readHealthKitData
    case saveBMI
  }
  
  private enum ProfileDataError: Error {
    
    case missingBodyMassIndex
    
    var localizedDescription: String {
      switch self {
      case .missingBodyMassIndex:
        return "Не удалось получить данные об индексе массы тела"
      }
    }
  }
  
  @IBOutlet private var ageLabel:UILabel!
  @IBOutlet private var bloodTypeLabel:UILabel!
  @IBOutlet private var biologicalSexLabel:UILabel!
  @IBOutlet private var weightLabel:UILabel!
  @IBOutlet private var heightLabel:UILabel!
  @IBOutlet private var bodyMassIndexLabel:UILabel!
  
  private let userHealthProfile = UserHealthProfile()
  
  private func updateHealthInfo() {
    loadAndDisplayAgeSexAndBloodType()
    loadAndDisplayMostRecentWeight()
    loadAndDisplayMostRecentHeight()
  }
  
  //метод загружает данные о возрасте, поле и группе крови пользователя
  private func loadAndDisplayAgeSexAndBloodType() {
    do{
      let userAgeSexAndBloodType = try ProfileDataStore.getAgeSexAndBloodType()
      userHealthProfile.age = userAgeSexAndBloodType.age
      userHealthProfile.biologicalSex = userAgeSexAndBloodType.biologicalSex
      userHealthProfile.bloodType = userAgeSexAndBloodType.bloodType
      updateLabels()//метод для отображения трех данных
    } catch let error {
      self.displayAlert(for: error)
    }
  }
  
  private func updateLabels() {
    if let age = userHealthProfile.age{
      ageLabel.text = "\(age)"
    }
    
    if let biologicalSex = userHealthProfile.biologicalSex {
      biologicalSexLabel.text = biologicalSex.stringRepresentation
    }
    
    if let bloodType = userHealthProfile.bloodType {
      bloodTypeLabel.text = bloodType.stringRepresentation
    }
    
    if let weight = userHealthProfile.weightInKilograms {
      let weightFormatter = MassFormatter()
      weightFormatter.isForPersonMassUse = true
      weightLabel.text = weightFormatter.string(fromKilograms: weight)
    }
    
    if let height = userHealthProfile.heightInMeters {
      let heightFormatter = LengthFormatter()
      heightFormatter.isForPersonHeightUse = true
      heightLabel.text = heightFormatter.string(fromMeters: height)
    }
    
    if let bodyMassIndex = userHealthProfile.bodyMassIndex {
      bodyMassIndexLabel.text = String(format: "%.02f", bodyMassIndex)
    }
  }
  
  private func loadAndDisplayMostRecentHeight() {
    //пишем данный метод, чтобы он не продолжал работу , если данные невозможно получить
    guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
      print("Данные роста больше не доступен в библиотеке Здоровья")
      return
    }
    
    ProfileDataStore.getMostRecentSample(for: heightSampleType) { (sample,error) in
      guard let sample = sample else {
        if let error = error {
          self.displayAlert(for: error)
        }
        return
      }
      // метод, преобразующий сэмпл в метры
      let heightInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
      self.userHealthProfile.heightInMeters = heightInMeters
      self.updateLabels()
      
    }
    
  }
  
  private func loadAndDisplayMostRecentWeight() {
    guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
      print("Данные массы больше не доступен в библиоткее Здоровья")
      return
    }
    
    ProfileDataStore.getMostRecentSample(for: weightSampleType) { (sample,error) in
      guard let sample = sample else {
        if let error = error {
          self.displayAlert(for: error)
        }
        return
      }
      
      let weightInKilograms = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
      self.userHealthProfile.weightInKilograms = weightInKilograms
      self.updateLabels()
    }
  }
  
  private func saveBodyMassIndexToHealthKit() {
    guard let bodyMassIndex = userHealthProfile.bodyMassIndex else {
      displayAlert(for: ProfileDataError.missingBodyMassIndex)
      return
    }
    ProfileDataStore.saveBodyMassIndexSample(bodyMassIndex: bodyMassIndex, date: Date())
    let alert = UIAlertController(title: nil,
                                  message: "Данные сохранены" ,
                                  preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Хорошо",
                                  style: .default,
                                  handler: nil))
    
    present(alert, animated: true, completion: nil)
  }
  
  private func displayAlert(for error: Error) {
    
    let alert = UIAlertController(title: nil,
                                  message: error.localizedDescription,
                                  preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "O.K.",
                                  style: .default,
                                  handler: nil))
    
    present(alert, animated: true, completion: nil)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let section = ProfileSection(rawValue: indexPath.section) else {
      fatalError("ProfileSection должен указывать путь к индексу")
    }
    
    switch section {
    case .saveBMI:
      saveBodyMassIndexToHealthKit()
    case .readHealthKitData:
      updateHealthInfo()
    default: break
    }
  }
}

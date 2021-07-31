//
//  ProfileDataStore.swift
//  RunForFun
//
//  Created by Константин Малков on 13.10.2020.
//  Copyright © 2020 Malkov Kostia. All rights reserved.
//

import UIKit
import HealthKit


class ProfileDataStore: UIViewController  {
  
  
  //метод делает запрос на использования данных пользователя касательно пола,возраста и группы крови
  class func getAgeSexAndBloodType() throws -> (age: Int, biologicalSex: HKBiologicalSex, bloodType: HKBloodType) {
    
    let healthKitStore = HKHealthStore()
    do {
      //метот выводящий ошибку в случае отсутствия данных
      let birthdayComponents = try healthKitStore.dateOfBirthComponents()
      let biologicalSex = try healthKitStore.biologicalSex()
      let bloodType = try healthKitStore.bloodType()
      
      //используем календарь для подсчета возраста в день авторизации
      let today = Date()
      let calendar = Calendar.current
      let todayDateComponents = calendar.dateComponents([.year], from: today)
      let thisYear = todayDateComponents.year!
      let age = thisYear - birthdayComponents.year!
      
      //разворачиваем методы для получения данных переменных
      let unwrappedBiologicalSex = biologicalSex.biologicalSex
      let unwrappedBloodType = bloodType.bloodType
      
      return (age, unwrappedBiologicalSex, unwrappedBloodType)
      
    }
  }
  
  //метод для загрузки сэмплов любого типа, который нужен для использования веса и роста
  class func getMostRecentSample( for sampleType:HKSampleType, completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
    //HKQuery создан для подгрузки последних образцов семплов
    let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate , ascending: false)
    let limit = 1
    let sampleQuery = HKSampleQuery (sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, samples,error) in
      //указанный ниже метод отправляет сэмплы в основной поток после завершения
      DispatchQueue.main.async {
        guard let samples = samples ,
              let mostRecentSample = samples.first as? HKQuantitySample else {
          completion(nil, error)
          return
        }
        completion(mostRecentSample,nil)
      }
    }
    HKHealthStore().execute(sampleQuery)
  }
  
  class func saveBodyMassIndexSample(bodyMassIndex: Double, date: Date) {
    //проверка на наличие данного типа веса тела
    guard let bodyMassIndexType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex) else {
      fatalError("Индекс массы тела больше не доступен")
    }
    
    let bodyMassQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: bodyMassIndex)
    let bodyMassIndexSample = HKQuantitySample(type: bodyMassIndexType, quantity: bodyMassQuantity, start: date , end: date)
    
    HKHealthStore().save(bodyMassIndexSample) { (success, error) in
      if let error = error {
        print("Ошибка сохранения : \(error.localizedDescription)")
        } else {
          print("ИМТ успешно сохранен")
        }
      }
    }
    
  
}

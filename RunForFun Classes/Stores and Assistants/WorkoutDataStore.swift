//
//  WorkoutDataStore.swift
//  RunForFun
//
//  Created by Константин Малков on 15.10.2020.
//  Copyright © 2020 Malkov Kostia. All rights reserved.
//

import HealthKit

class WorkoutDataStore {
  
  //данный метод нужен для отображения тренировки в программе здоровья
  class func save(fitnessWorkout: FitnessWorkout,
                  completion: @escaping ((Bool, Error?) -> Swift.Void)) {
    let healthStore = HKHealthStore()
    let workoutConfiguration = HKWorkoutConfiguration()
    workoutConfiguration.activityType = .other
    
    let builder = HKWorkoutBuilder(healthStore: healthStore, configuration: workoutConfiguration, device: .local())
    builder.beginCollection(withStart: fitnessWorkout.start) { (success,error) in
      guard success else {
        completion(false, error)
        return
      }
    }
    
    let samples = self.samples(for: fitnessWorkout)
    builder.add(samples) { (success,error) in
      guard success else {
      completion(false,error)
      return
    }
    
    builder.endCollection(withEnd: fitnessWorkout.end) { (success, error) in
      guard success else {
        completion(false,error)
        return
      }
      
      builder.finishWorkout { (workout,error) in
        let success = error == nil
        completion(success,error)
      }
    }
  }
}
  private class func samples(for workout: FitnessWorkout) -> [HKSample] {
    guard let energyQuantityType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else {
      fatalError("Тип Энергосжигания недоступен")
    }
    
    let samples: [HKSample] = workout.intervals.map { interval in
      let calorieQuantity = HKQuantity(unit: .kilocalorie(), doubleValue: interval.totalEnergyBurned)
      return HKCumulativeQuantitySample(type: energyQuantityType, quantity: calorieQuantity, start: interval.start, end: interval.end)
    }
    return samples
  }
  
  //этот метод предназначен для загрузки данных из приложения Здоровья
  class func loadFitnessWorkouts(completion: @escaping ([HKWorkout]?, Error?) -> Void){
    let workoutPredicate = HKQuery.predicateForWorkouts(with: .other)
    let sourcePredicate = HKQuery.predicateForObjects(from: .default())
    let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [workoutPredicate, sourcePredicate])
    
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
    
    let query = HKSampleQuery(sampleType: .workoutType(), predicate: compound, limit: 0, sortDescriptors: [sortDescriptor]) { (query,samples,error) in
      DispatchQueue.main.async {
        guard
          let samples = samples as? [HKWorkout],
          error == nil
          else {
            completion(nil,error)
            return
        }
        completion(samples,nil)
      }
    }
    
    HKHealthStore().execute(query)
  }
  
}

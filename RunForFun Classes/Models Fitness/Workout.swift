//
//  Workout.swift
//  RunForFun
//
//  Created by Константин Малков on 11.10.2020.
//  Copyright © 2020 Malkov Kostia. All rights reserved.
//

import Foundation

struct FitnessWorkoutInterval  {

  var start: Date
  var end: Date
  
  init(start: Date, end: Date) {
    self.start = start
    self.end = end
  }
  
  var duration: TimeInterval {
    return end.timeIntervalSince(start)
  }
  
  var totalEnergyBurned: Double {
    
    let fitnessCaloriesPerHour: Double = 450
    
    let hours: Double = duration/3600
    
    let totalCalories = fitnessCaloriesPerHour*hours
    
    return totalCalories
  }
}

struct FitnessWorkout {
  
  var start: Date
  var end: Date
  var intervals: [FitnessWorkoutInterval]
  
  init(with intervals: [FitnessWorkoutInterval]) {
    self.start = intervals.first!.start
    self.end = intervals.last!.end
    self.intervals = intervals
  }
  
  var totalEnergyBurned: Double {
    return intervals.reduce(0) { (result, interval) in
      result + interval.totalEnergyBurned
    }
  }
  
  var duration: TimeInterval {
    return intervals.reduce(0) { (result,interval) in
      result + interval.duration
    }
  }
}



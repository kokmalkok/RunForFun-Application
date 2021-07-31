//
//  WorkoutSession.swift
//  RunForFun
//
//  Created by Константин Малков on 11.10.2020.
//  Copyright © 2020 Malkov Kostia. All rights reserved.
//

import Foundation

enum WorkoutSessionState {
  case notStarted
  case active
  case finished
}

class WorkoutSession {
  
  private (set) var startDate: Date!
  private (set) var endDate: Date!
  
  var state: WorkoutSessionState = .notStarted
  
  var intervals: [FitnessWorkoutInterval] = []
  
  func start() {
    startDate = Date()
    state = .active
  }
  
  func end() {
    endDate = Date()
    addNewInterval()
    state = .finished
  }
  
  func clear() {
    startDate = nil
    endDate = nil
    state = .notStarted
    intervals.removeAll()
  }
  
  private func addNewInterval() {
    let interval = FitnessWorkoutInterval(start: startDate, end: endDate)
    intervals.append(interval)
  }
  
  var completeWorkout: FitnessWorkout? {
    guard state == .finished, intervals.count > 0 else {
      return nil
    }
    return FitnessWorkout(with: intervals)
  }
  
}

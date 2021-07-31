//
//  WorkoutsTableViewController.swift
//  RunForFun
//
//  Created by Константин Малков on 15.10.2020.
//  Copyright © 2020 Malkov Kostia. All rights reserved.
//

import UIKit
import HealthKit

class WorkoutsTableViewController: UITableViewController {
  

  
  private enum WorkoutsSegues: String {
    case showCreateWorkout
    case finishedCreatingWorkout
  }
  
  private var workouts: [HKWorkout]?
  
  private let fitnessWorkoutCellID = "FitnessWorkoutCell"
  
  lazy var dateFormatter:DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    
    return formatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.clearsSelectionOnViewWillAppear = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reloadWorkouts()
  }
  
  func reloadWorkouts() {
    WorkoutDataStore.loadFitnessWorkouts { (workouts, error) in
      self.workouts = workouts
      self.tableView.reloadData()
    }
  }
  
  func removeItemAt(at index: Int) {
    workouts?.remove(at: index)
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      removeItemAt(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {}
    
  }
  
}

extension WorkoutsTableViewController {
  override func tableView(_ tableVIew: UITableView, numberOfRowsInSection section: Int) -> Int {
    return workouts?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let workouts = workouts else {
      fatalError("""
        CellForRowAtIndexPath should \
        not get called if there are no workouts
        """)
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: fitnessWorkoutCellID, for: indexPath)
    let workout = workouts[indexPath.row]
    cell.textLabel?.text = dateFormatter.string(from: workout.startDate)
    
    if let caloriesBurned = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) {
      let formattedCalories = String(format: "Энергия активности: %.2f",caloriesBurned)
      cell.detailTextLabel?.text = formattedCalories
    } else {
      cell.detailTextLabel?.text = nil
    }
    return cell
  }
}

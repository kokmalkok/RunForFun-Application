//
//  ReminderViewController.swift
//  RunForFun
//
//  Created by Константин Малков on 25.10.2020.
//  Copyright © 2020 Malkov Kostia. All rights reserved.
//


import UserNotifications
import UIKit

class ReminderViewController: UIViewController {

    @IBOutlet var table: UITableView!

    var models = [MyReminder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
      
    }

    @IBAction func didTapAdd() {
        // show add vc
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
            return
        }

        vc.title = ""
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                let new = MyReminder(title: title, date: date, identifier: "id_\(title)")
                self.models.append(new)
                self.table.reloadData()
                
                
                let content = UNMutableNotificationContent()
                content.title = "Не забудьте про тренировку"
                content.sound = .default
                content.body = "У вас сегодня запланирована \(title) длинною в \(body) минут."

                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                            from: targetDate),
                                                            repeats: false)

                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("Что-то пошло не так")
                    }
                })
            }
        }
        navigationController?.pushViewController(vc, animated: true)

    }
  
  func saveData() {
    UserDefaults.standard.set(models, forKey: "models")
    UserDefaults.standard.synchronize()
  }
  func loadData() {
    if let array = UserDefaults.standard.array(forKey: "models") as? [MyReminder]{
      models = array
    } else {
      models = []
    }
  }

}

extension ReminderViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}


extension ReminderViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let date = models[indexPath.row].date

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, YYYY"
        cell.detailTextLabel?.text = formatter.string(from: date)

        cell.textLabel?.font = UIFont(name: "Arial", size: 22)
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 22)
        return cell
    }

}


struct MyReminder {
    let title: String
    let date: Date
    let identifier: String
}


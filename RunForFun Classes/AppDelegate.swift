//
//  AppDelegate.swift
//  RunForFun
//
//  Created by Константин Малков on 01.08.2020.
//  Copyright © 2020 Malkov Kostia. All rights reserved.
//
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    UINavigationBar.appearance().tintColor = .white
//    UINavigationBar.appearance().barTintColor = .blue
    let locationManager = LocationManager.shared
    locationManager.requestWhenInUseAuthorization()
    
    
    
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    registerForPushNotifications()
    return true
  }
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      // Called when a new scene session is being created.
      // Use this method to select a configuration to create the new scene with.
      return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    CoreDataStack.saveContext()
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    CoreDataStack.saveContext()
  }
  //функция уведомления
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      print("Received local notification \(notification)")
  }
  func registerForPushNotifications() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
      (granted, error) in
      print("Permission granted: \(granted)")
    }
  }
}



//
//  HapticsManager.swift
//  RunForFun
//
//  Created by Константин Малков on 06.11.2020.
//  Copyright © 2020 Malkov Kostia. All rights reserved.
//

import UIKit

final class HapticsManager {
  static let shared = HapticsManager()
  
  private init() {}
  
  public func selectionVibrate() {
    DispatchQueue.main.async {
      let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
      selectionFeedbackGenerator.prepare()
      selectionFeedbackGenerator.selectionChanged()
    }
  }
  
  public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
    DispatchQueue.main.async {
      let notificationGenerator = UINotificationFeedbackGenerator()
      notificationGenerator.prepare()
      notificationGenerator.notificationOccurred(type)
    }
  }
}

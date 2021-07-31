//
//  HKBiologicalSex.swift
//  RunForFun
//
//  Created by Константин Малков on 20.09.2020.
//  Copyright © 2020 Malkov Kostia. All rights reserved.
//

import HealthKit

extension HKBiologicalSex {
  
  var stringRepresentation: String {
    switch self {
    case .notSet: return "Не указано"
    case .female: return "Женский"
    case .male: return "Мужской"
    case .other: return "Не указан"
    
    @unknown default:
      fatalError("Приложению необходим доступ к вашему приложению Здоровье")
    }
  }
}

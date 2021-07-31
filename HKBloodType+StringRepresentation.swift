//
//  HKBloodType.swift
//  RunForFun
//
//  Created by Константин Малков on 20.09.2020.
//  Copyright © 2020 Malkov Kostia. All rights reserved.
//

import HealthKit

extension HKBloodType {

  var stringRepresentation: String {
    switch self {
    case .notSet: return "Не указано"
    case .aPositive: return "A+"
    case .aNegative: return "A-"
    case .bPositive: return "B+"
    case .bNegative: return "B-"
    case .abPositive: return "AB+"
    case .abNegative: return "AB-"
    case .oPositive: return "O+"
    case .oNegative: return "O-"
    
    @unknown default:
      fatalError("Приложению необходим доступ к вашему приложению Здоровье")    }
  }
}

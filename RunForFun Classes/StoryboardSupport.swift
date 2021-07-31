//
//  StoryboardSupport.swift
//  RunForFun
//
//  Created by Константин Малков on 11.08.2020.
//  Copyright © 2020 Malkov Kostia. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
  static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
  static var storyboardIdentifier: String {
    return String(describing: self)
  }
}

extension StoryboardIdentifiable where Self: UITableViewCell {
  static var storyboardIdentifier: String {
    return String(describing: self)
  }
}



extension UIViewController: StoryboardIdentifiable { }
extension UITableViewCell: StoryboardIdentifiable { }


extension UITableView {
  func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: T.storyboardIdentifier, for: indexPath) as? T else {
      fatalError("Не удалось найти ячейку таблицы с идентификатором \(T.storyboardIdentifier)")
    }
    return cell
  }
  
  func cellForRow<T: UITableViewCell>(at indexPath: IndexPath) -> T {
    guard let cell = cellForRow(at: indexPath) as? T else {
      fatalError("Не удалось получить доступ к ячейке \(T.self)")
    }
    return cell
  }
}


protocol SegueHandlerType {
  associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
  
  func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
    performSegue(withIdentifier: identifier.rawValue, sender: sender)
  }
  
  func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier {
    guard
      let identifier = segue.identifier,
      let segueIdentifier = SegueIdentifier(rawValue: identifier)
      else {
        fatalError("Неверный переход идентификатора: \(String(describing: segue.identifier))")
    }
    
    return segueIdentifier
  }
  
}




/*
Malkov K.S.

Graduation Work

*/

import CoreData

class CoreDataStack {
  
  static let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "RunForFun")
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        fatalError("Неизвестная ошибка \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  static var context: NSManagedObjectContext { return persistentContainer.viewContext }
  
  class func saveContext () {
    let context = persistentContainer.viewContext
    
    guard context.hasChanges else {
      return
    }
    
    do {
      try context.save()
    } catch {
      let nserror = error as NSError
      fatalError("Неизвестная ошибка \(nserror), \(nserror.userInfo)")
    }
  }
}

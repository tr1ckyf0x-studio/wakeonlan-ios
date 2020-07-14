//
//  PersistentCoreDataService.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 20.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import CoreData

final class PersistentCoreDataService {
    
    typealias SaveCompletionHandler = () -> Void
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HostsDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func createChildConcurrentContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        return context
    }

    // MARK: - Core Data Saving support
    
    func saveContext(_ context: NSManagedObjectContext, completionHandler: SaveCompletionHandler? = nil) {
        switch context.concurrencyType {
        case .privateQueueConcurrencyType:
            context.performAndWait {
                guard context.hasChanges else {
                    completionHandler?()
                    return
                }
                
                do {
                    try context.save()
                    if let parent = context.parent {
                        parent.perform {
                            self.saveContext(parent, completionHandler: completionHandler)
                        }
                    } else {
                        completionHandler?()
                    }
                } catch {
                    print(error)
                    // TODO: Обработка ошибок
                }
            }
            
        case .mainQueueConcurrencyType:
            do {
                guard context.hasChanges else {
                    completionHandler?()
                    return
                }
                try context.save()
                completionHandler?()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
        default: break
        }
    }
}

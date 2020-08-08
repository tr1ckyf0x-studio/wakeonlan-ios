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
    
    func saveContext(_ context: NSManagedObjectContext,
                     completionHandler: SaveCompletionHandler? = nil) {
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
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            default:
                break
        }
    }

}

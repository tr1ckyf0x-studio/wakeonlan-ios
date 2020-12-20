//
//  CoreDataService.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 02.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import CocoaLumberjackSwift
import CoreData

protocol CoreDataServiceProtocol {
    typealias SaveCompletionHandler = () -> Void

    var persistentContainer: NSPersistentContainer { get }

    var mainContext: NSManagedObjectContext { get }

    func createHostContainer(completion: @escaping () -> Void)

    func createChildConcurrentContext() -> NSManagedObjectContext

    func saveContext(_ context: NSManagedObjectContext, completionHandler: SaveCompletionHandler?)
}

extension CoreDataServiceProtocol {

    var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func createHostContainer(completion: @escaping () -> Void) {
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                DDLogError("Persistent stores were not loaded due to error: \(error)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            DDLogDebug("Persistent stores were loaded")
            DispatchQueue.main.async { completion() }
        }
    }

    func createChildConcurrentContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        DDLogVerbose("Child concurrent context was created")
        return context
    }

    // MARK: - Core Data Saving support

    func saveContext(
        _ context: NSManagedObjectContext,
        completionHandler: SaveCompletionHandler? = nil
    ) {
        switch context.concurrencyType {
        case .privateQueueConcurrencyType:
            context.performAndWait {
                guard context.hasChanges else {
                    DDLogDebug("Context does not contain any changes. Save will not be performed")
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
                    DDLogDebug("Context was saved")
                } catch {
                    DDLogError("Context was not saved due to error: \(error)")
                    // TODO: Maybe there must be throw
                    // TODO: Error handling
                }
            }

        case .mainQueueConcurrencyType:
            do {
                guard context.hasChanges else {
                    DDLogDebug("Context does not contain any changes. Save will not be performed")
                    completionHandler?()
                    return
                }
                try context.save()
                DDLogDebug("Main context was saved")
                completionHandler?()
            } catch {
                let nsError = error as NSError
                DDLogError("Main context was not saved due to error: \(error)")
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }

        default:
            break
        }
    }
}

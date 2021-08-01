//
//  CoreDataServiceProtocol.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 02.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import CocoaLumberjackSwift
import CoreData

public protocol CoreDataServiceProtocol {
    typealias SaveCompletionHandler = () -> Void

    var persistentContainer: NSPersistentCloudKitContainer { get }

    var mainContext: NSManagedObjectContext { get }

    func createHostContainer(completion: @escaping () -> Void)

    func createChildConcurrentContext() -> NSManagedObjectContext

    func saveContext(_ context: NSManagedObjectContext, completionHandler: SaveCompletionHandler?)
}

extension CoreDataServiceProtocol {

    public var mainContext: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }

    public func createHostContainer(completion: @escaping () -> Void) {
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                DDLogError("Persistent stores were not loaded due to error: \(error)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            DDLogDebug("Persistent stores were loaded")

//            #if DEBUG
//            do {
//                // Use the container to initialize the development schema.
//                try persistentContainer.initializeCloudKitSchema(options: [])
//            } catch {
//                print(error)
//            }
//            #endif

            DispatchQueue.main.async { completion() }
        }
    }

    public func createChildConcurrentContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        DDLogVerbose("Child concurrent context was created")
        return context
    }

    // MARK: - Core Data Savingpublic  support

    public func saveContext(
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

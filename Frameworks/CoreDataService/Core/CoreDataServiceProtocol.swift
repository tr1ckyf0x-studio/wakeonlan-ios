//
//  CoreDataServiceProtocol.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 02.11.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import CocoaLumberjack
import CoreData

public protocol CoreDataServiceProtocol: AnyObject {
    typealias SaveCompletionHandler = () -> Void

    var persistentContainer: NSPersistentContainer { get }

    var persistentStoreCoordinator: NSPersistentStoreCoordinator { get }

    var mainContext: NSManagedObjectContext { get }

    /// Method has completion handler inside, but it is sync until shouldAddStoreAsynchronously equals true
    func createHostContainer()

    func createChildConcurrentContext() -> NSManagedObjectContext

    func saveContext(_ context: NSManagedObjectContext, completionHandler: SaveCompletionHandler?)
}

extension CoreDataServiceProtocol {

    public var mainContext: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }

    public func createHostContainer() {
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                DDLogError("Persistent stores were not loaded due to error: \(error)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }

            DDLogDebug("Persistent stores were loaded")
        }
    }

    public func createChildConcurrentContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        DDLogVerbose("Child concurrent context was created")
        return context
    }

    // MARK: - Core Data Saving

    public func saveContext(
        _ context: NSManagedObjectContext,
        completionHandler: SaveCompletionHandler? = nil
    ) {
        switch context.concurrencyType {
        case .privateQueueConcurrencyType:
            context.performAndWait {
                guard context.hasChanges else {
                    DDLogDebug("Context does not contain any changes. Save will not be performed")
                    DispatchQueue.main.async { completionHandler?() }
                    return
                }
                do {
                    try context.save()
                    if let parent = context.parent {
                        parent.perform {
                            self.saveContext(parent, completionHandler: completionHandler)
                        }
                    } else {
                        DispatchQueue.main.async { completionHandler?() }
                    }
                    DDLogDebug("Context was saved")
                } catch {
                    DDLogError("Context was not saved due to error: \(error)")
                }
            }

        case .mainQueueConcurrencyType:
            do {
                guard
                    context.hasChanges
                else {
                    DDLogDebug("Context does not contain any changes. Save will not be performed")
                    DispatchQueue.main.async {
                        completionHandler?()
                    }
                    return
                }
                try context.save()
                DDLogDebug("Main context was saved")
                DispatchQueue.main.async {
                    completionHandler?()
                }
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

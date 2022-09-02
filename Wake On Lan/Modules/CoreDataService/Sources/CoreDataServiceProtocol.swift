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

protocol CoreDataServiceInternalProtocol: AnyObject {
    var managedObjectModel: NSManagedObjectModel { get }

    var hasLoadedStores: Bool { get set }
}

public protocol CoreDataServiceProtocol {
    typealias SaveCompletionHandler = () -> Void

    var persistentContainer: NSPersistentCloudKitContainer { get }

    var mainContext: NSManagedObjectContext { get }

    func createHostContainer(completion: @escaping () -> Void)

    func createHostContainer() async

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
        let internalPointer = self as? CoreDataServiceInternalProtocol
        if let internalPointer = internalPointer, internalPointer.hasLoadedStores {
            completion()
            return
        }
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                DDLogError("Persistent stores were not loaded due to error: \(error)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            DDLogDebug("Persistent stores were loaded")
            internalPointer?.hasLoadedStores = true
            completion()
        }
    }

    public func createHostContainer() async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            createHostContainer {
                continuation.resume()
            }
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

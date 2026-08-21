//
//  HostCRUDWorker.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 07.12.2023.
//  Copyright © 2023 Vladislav Lisianskii. All rights reserved.
//

import CocoaLumberjackSwift
import CoreData
import PersistenceCore
import SharedProtocolsAndModels
import WOLSharedProtocolsAndModels

public struct HostCRUDWorker {
    public typealias ManagedObject = Host
    public typealias Model = HostFormValues

    // MARK: - Properties

    private let coreDataService: CoreDataServiceProtocol

    // MARK: - Init

    public init(coreDataService: CoreDataServiceProtocol = CoreDataService.shared) {
        self.coreDataService = coreDataService
    }
}

// MARK: - PerformsCRUDOperation

extension HostCRUDWorker: PerformsCRUDOperation {
    public func create(
        from model: Model,
        in context: NSManagedObjectContext,
        completion: CompletionHandler?
    ) {
        // NOTE: Every touch of `context` must happen on its own queue. `insertObject`, `update` and
        // `saveRecursively` used to run on the caller's thread — the main one — while `context` is a
        // private-queue child context. That is a queue confinement violation: it traps under
        // `-com.apple.CoreData.ConcurrencyDebug 1` and races on the context's registry otherwise.
        // The `update` and `delete` paths below already do this correctly.
        context.perform {
            do {
                let hosts = try context.fetch(Host.sortedFetchRequest)
                hosts.forEach {
                    $0.order += 1
                }
            } catch {
                DDLogError("Failed to fetch hosts due to error: \(error)")
            }

            let host: Host = context.insertObject()
            host.update(from: model, in: context)
            context.saveRecursively { error in
                // NOTE: `saveRecursively` documents that it calls back on the main queue; this makes
                // that promise legible to the compiler instead of hopping and changing the ordering.
                MainActor.assumeIsolated {
                    if let error {
                        completion?(.failure(error))
                        return
                    }

                    completion?(.success(Void()))
                }
            }
        }
    }

    public func update(
        objectID: NSManagedObjectID,
        in context: NSManagedObjectContext,
        with model: Model,
        completion: CompletionHandler?
    ) {
        context.perform {
            guard let host = try? context.existingObject(with: objectID) as? Host else {
                DDLogWarn("Host to update no longer exists")
                return
            }
            host.update(from: model, in: context)
            context.saveRecursively { error in
                MainActor.assumeIsolated {
                    if let error {
                        completion?(.failure(error))
                        return
                    }

                    completion?(.success(Void()))
                }
            }
        }
    }

    public func delete(objectID: NSManagedObjectID, in context: NSManagedObjectContext) {
        context.perform {
            guard let host = try? context.existingObject(with: objectID) else {
                DDLogDebug("Nothing to delete")
                return
            }
            context.delete(host)
            context.saveRecursively()
            DDLogDebug("Host deleted")
        }
    }
}

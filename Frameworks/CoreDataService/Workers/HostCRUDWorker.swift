//
//  HostCRUDWorker.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 07.12.2023.
//  Copyright © 2023 Vladislav Lisianskii. All rights reserved.
//

import CocoaLumberjack
import CoreData
import SharedProtocolsAndModels

public struct HostCRUDWorker {
    public typealias ManagedObject = Host
    public typealias Model = any AddHostFormRepresentable

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
        context.performAndWait {
            do {
                let hosts = try context.fetch(Host.sortedFetchRequest)
                hosts.forEach {
                    $0.order += 1
                }
            } catch {
                DDLogError("Failed to fetch hosts due to error: \(error)")
            }
        }
        let host: Host = context.insertObject()
        host.update(from: model, in: context)
        coreDataService.saveContext(context) {
            completion?(.success(Void()))
        }
    }

    public func update(
        object: Host,
        in context: NSManagedObjectContext,
        with model: Model,
        completion: CompletionHandler?
    ) {
        context.perform { [weak coreDataService] in
            object.update(from: model, in: context)
            coreDataService?.saveContext(context) {
                completion?(.success(Void()))
            }
        }
    }

    public func delete(object: ManagedObject, in context: NSManagedObjectContext) {
        context.perform {
            context.delete(object)
            coreDataService.saveContext(context)
            DDLogDebug("Host deleted")
        }
    }
}

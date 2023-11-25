//
//  HostCRUDWorker.swift
//  CoreDataService
//
//  Created by Vladislav Lisianskii on 21.11.2023.
//

import CocoaLumberjack
import CoreData
import SharedProtocolsAndModels

public protocol PerformsHostCRUD {
    func move(
        from sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath,
        in fetchedObjects: [Host],
        context: NSManagedObjectContext
    )

    func delete(
        host: Host,
        context: NSManagedObjectContext
    )

    func create<T: AddHostFormRepresentable>(
        from form: T,
        in context: NSManagedObjectContext,
        completion: ((Result<Void, Swift.Error>) -> Void)?
    )

    func update<T: AddHostFormRepresentable>(
        host: Host,
        in context: NSManagedObjectContext,
        with form: T,
        completion: ((Result<Void, Swift.Error>) -> Void)?
    )
}

public struct HostCRUDWorker: PerformsHostCRUD {

    private let coreDataService: CoreDataServiceProtocol

    public init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }

    public func move(
        from sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath,
        in fetchedObjects: [Host],
        context: NSManagedObjectContext
    ) {
        guard
            sourceIndexPath != destinationIndexPath
        else {
            return
        }

        var fetchedObjects = fetchedObjects

        let host = fetchedObjects.remove(at: sourceIndexPath.item)
        fetchedObjects.insert(host, at: destinationIndexPath.item)
        context.performAndWait {
            fetchedObjects.enumerated().forEach { (index: Int, host: Host) in
                host.order = index
            }
        }
        coreDataService.saveContext(context)
    }

    public func delete(
        host: Host,
        context: NSManagedObjectContext
    ) {
        context.perform {
            context.delete(host)
            coreDataService.saveContext(context)
            DDLogDebug("Host deleted")
        }
    }

    public func create<T: AddHostFormRepresentable>(
        from form: T,
        in context: NSManagedObjectContext,
        completion: ((Result<Void, Swift.Error>) -> Void)?
    ) {
        guard
            let macAddress = form.macAddress,
            let title = form.title,
            let iconName = form.iconModel?.sfSymbol
        else {
            DispatchQueue.main.async {
                completion?(.failure(Error.formIsNotValid))
            }
            return
        }

        context.performAndWait {
            do {
                let hosts = try context.fetch(Host.sortedFetchRequest)
                hosts.forEach { (host: Host) in
                    host.order += 1
                }
            } catch {
                DDLogError("Failed to fetch hosts due to error: \(error)")
            }
        }

        let host: Host = context.insertObject()
        host.iconName = iconName.systemName
        host.title = title
        host.macAddress = macAddress
        host.destination = form.destination
        host.port = form.port

        coreDataService.saveContext(context) {
            DispatchQueue.main.async {
                completion?(.success(Void()))
            }
        }
    }

    public func update<T: AddHostFormRepresentable>(
        host: Host,
        in context: NSManagedObjectContext,
        with form: T,
        completion: ((Result<Void, Swift.Error>) -> Void)?
    ) {

        // swiftlint:disable:next closure_body_length
        context.perform {
            guard
                let macAddress = form.macAddress,
                let title = form.title,
                let iconName = form.iconModel?.sfSymbol,
                let updateObject = context.object(with: host.objectID) as? Host
            else {
                DispatchQueue.main.async {
                    completion?(.failure(Error.hostNotFound))
                }
                return
            }

            updateObject.title = title
            updateObject.iconName = iconName.systemName
            updateObject.macAddress = macAddress
            updateObject.destination = form.destination
            updateObject.port = form.port

            coreDataService.saveContext(context) {
                DispatchQueue.main.async {
                    completion?(.success(Void()))
                }
            }
        }
    }
}

// MARK: - Error

extension HostCRUDWorker {
    enum Error: LocalizedError {
        case hostNotFound
        case formIsNotValid

        var errorDescription: String? {
            switch self {
            case .hostNotFound:
                "Host not found."

            case .formIsNotValid:
                "Form is not valid. Some fields are nil."
            }
        }
    }
}

//
//  MoveHostWorker.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 07.12.2023.
//  Copyright © 2023 Владислав Лисянский. All rights reserved.
//

import CoreData
import SharedProtocolsAndModels

public struct MoveHostWorker {
    public typealias CoreDataObject = Host

    // MARK: - Properties

    private let coreDataService: CoreDataServiceProtocol

    // MARK: - Init

    public init(coreDataService: CoreDataServiceProtocol = CoreDataService.shared) {
        self.coreDataService = coreDataService
    }
}

// MARK: - PerformsMoveOperation

extension MoveHostWorker: PerformsMoveOperation {
    public func move(
        from sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath,
        among fetchedObjects: inout [Host],
        context: NSManagedObjectContext
    ) {
        let host = fetchedObjects.remove(at: sourceIndexPath.item)
        fetchedObjects.insert(host, at: destinationIndexPath.item)
        context.performAndWait {
            fetchedObjects.enumerated().forEach { index, host in
                host.order = index
            }
        }
        coreDataService.saveContext(context)
    }
}

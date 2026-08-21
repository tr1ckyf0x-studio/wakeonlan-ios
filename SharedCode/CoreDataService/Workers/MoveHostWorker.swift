//
//  MoveHostWorker.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 07.12.2023.
//  Copyright © 2023 Vladislav Lisianskii. All rights reserved.
//

import CoreData
import PersistenceCore
import SharedProtocolsAndModels
import WOLSharedProtocolsAndModels

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

        // NOTE: Only object IDs cross into the context's queue. `NSManagedObjectID` is thread-safe,
        // whereas `[Host]` is not Sendable and `fetchedObjects` is an `inout` parameter — capturing
        // either in the `@Sendable` block would be a data race.
        let orderedObjectIDs = fetchedObjects.map(\.objectID)
        context.performAndWait {
            for (index, objectID) in orderedObjectIDs.enumerated() {
                guard let host = try? context.existingObject(with: objectID) as? Host else { continue }
                host.order = index
            }
        }
        context.saveRecursively()
    }
}

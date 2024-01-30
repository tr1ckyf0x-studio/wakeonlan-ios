//
//  HostV4Mapping.swift
//  CoreDataService
//
//  Created by Vladislav Lisianskii on 30.01.2024.
//

import CoreData

final class HostV4Mapping: NSEntityMigrationPolicy {

    override func createDestinationInstances(
        forSource sourceInstance: NSManagedObject,
        in mapping: NSEntityMapping,
        manager: NSMigrationManager
    ) throws {
        try super.createDestinationInstances(forSource: sourceInstance, in: mapping, manager: manager)

        guard let destinationInstance = manager.destinationInstances(
            forEntityMappingName: mapping.name,
            sourceInstances: [sourceInstance]
        ).first
        else {
            fatalError("Must return host")
        }

        destinationInstance.setValue(Date(), forKey: Constants.createdAt)

        manager.sourceContext.delete(sourceInstance)
    }
}

// MARK: - Constants

extension HostV4Mapping {
    private enum Constants {
        static let createdAt = "createdAt"
    }
}

//
//  HostV2Mapping.swift
//  
//
//  Created by Vladislav Lisianskii on 26.05.2023.
//

import CoreData

// NOTE: Core Data instantiates and drives migration policies on its own migration thread, so
// they must opt out of the module's MainActor default isolation.
nonisolated final class HostV2Mapping: NSEntityMigrationPolicy {
    override func createDestinationInstances(
        forSource sourceInstance: NSManagedObject,
        in mapping: NSEntityMapping,
        manager: NSMigrationManager
    ) throws {
        guard sourceInstance.entity.name == Constants.entityName else { return }

        try super.createDestinationInstances(forSource: sourceInstance, in: mapping, manager: manager)

        let ipAddressData = sourceInstance.primitiveValue(forKey: Constants.ipAddressData) as? Data

        let ipAddress = ipAddressData.map { (data: Data) -> String in
            CoreDataHostFormatter.decompress(data: data, ofType: .ipAddress)
        }

        guard let destinationInstance = manager.destinationInstances(
            forEntityMappingName: mapping.name,
            sourceInstances: [sourceInstance]
        ).first
        else {
            fatalError("Must return host")
        }

        destinationInstance.setValue(ipAddress, forKey: Constants.destination)

        manager.sourceContext.delete(sourceInstance)
    }
}

// MARK: - Constants

nonisolated extension HostV2Mapping {
    private enum Constants {
        static let entityName = "Host"
        static let ipAddressData = "ipAddressData"
        static let destination = "destination"
    }
}

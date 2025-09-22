//
//  HostV3Mapping.swift
//  CoreDataService
//
//  Created by Vladislav Lisianskii on 20.11.2023.
//

import CoreData

final class HostV3Mapping: NSEntityMigrationPolicy {

    private var oldHostCreationDates: [Date] = []

    override func begin(_ mapping: NSEntityMapping, with manager: NSMigrationManager) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Host")
        request.sortDescriptors = [NSSortDescriptor(key: Constants.createdAt, ascending: false)]
        oldHostCreationDates = try manager.sourceContext.fetch(request)
            .compactMap { (host: NSManagedObject) -> Date? in
                host.value(forKey: Constants.createdAt) as? Date
            }

        try super.begin(mapping, with: manager)
    }

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

        let createdAt = sourceInstance.value(forKey: Constants.createdAt) as? Date

        let index = createdAt.flatMap { (date: Date) -> Int? in
            oldHostCreationDates.firstIndex { (oldHostDate: Date) -> Bool in
                oldHostDate == date
            }
        }

        destinationInstance.setValue(index ?? 0, forKey: Constants.order)

        manager.sourceContext.delete(sourceInstance)
    }
}

// MARK: - Constants

extension HostV3Mapping {
    private enum Constants {
        static let createdAt = "createdAt"
        static let order = "order"
    }
}

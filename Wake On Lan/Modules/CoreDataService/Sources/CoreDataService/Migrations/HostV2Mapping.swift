//
//  HostV2Mapping.swift
//  
//
//  Created by Vladislav Lisianskii on 26.05.2023.
//

import CoreData

final class HostV2Mapping: NSEntityMigrationPolicy {
    override func createDestinationInstances(
        forSource sInstance: NSManagedObject,
        in mapping: NSEntityMapping,
        manager: NSMigrationManager
    ) throws {
        guard sInstance.entity.name == Constants.entityName else { return }

        guard let createdAt = sInstance.primitiveValue(forKey: Constants.createdAt) as? Date,
              let title = sInstance.primitiveValue(forKey: Constants.title) as? String,
              let iconName = sInstance.primitiveValue(forKey: Constants.iconName) as? String
        else { return }

        let macAddressData = sInstance.primitiveValue(forKey: Constants.macAddressData) as? Data
        let ipAddressData = sInstance.primitiveValue(forKey: Constants.ipAddressData) as? Data
        let port = sInstance.primitiveValue(forKey: Constants.port) as? String

        let ipAddress = ipAddressData.map { data in
            CoreDataHostFormatter.decompress(data: data, ofType: .ipAddress)
        }

        let host = NSEntityDescription.insertNewObject(
            forEntityName: Constants.entityName,
            into: manager.destinationContext
        )
        host.setValue(createdAt, forKey: Constants.createdAt)
        host.setValue(title, forKey: Constants.title)
        host.setValue(iconName, forKey: Constants.iconName)
        host.setValue(macAddressData, forKey: Constants.macAddressData)
        host.setValue(port, forKey: Constants.port)
        host.setValue(ipAddress, forKey: Constants.destination)
    }
}

// MARK: - Constants

extension HostV2Mapping {
    private enum Constants {
        static let entityName = "Host"
        static let createdAt = "createdAt"
        static let title = "title"
        static let iconName = "iconName"
        static let macAddressData = "macAddressData"
        static let ipAddressData = "ipAddressData"
        static let port = "port"
        static let destination = "destination"
    }
}

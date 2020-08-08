//
//  Host+CoreDataClass.swift
//  
//
//  Created by Владислав Лисянский on 20.05.2020.
//
//

import CoreData

final class Host: NSManagedObject {
    @NSManaged private(set) var createdAt: Date
    @NSManaged private(set) var title: String
    @NSManaged private(set) var iconName: String
    @NSManaged private(set) var macAddress: String
    @NSManaged private(set) var ipAddress: String?
    @NSManaged private(set) var port: String?

}

// MARK: - CRUD
extension Host {

    static func insert(into context: NSManagedObjectContext, form: AddHostForm) {
        guard let macAddress = form.macAddress,
            let title = form.title,
            let iconName = form.iconModel?.pictureName
            else { return }
        let host: Host = context.insertObject()
        host.createdAt = Date()
        host.iconName = iconName
        host.title = title
        host.macAddress = macAddress
        host.ipAddress = form.ipAddress
        host.port = form.port
    }

    static func update(object: Host,
                       into context: NSManagedObjectContext,
                       with form: AddHostForm) {
        guard let macAddress = form.macAddress,
            let title = form.title,
            let iconName = form.iconModel?.pictureName,
            let updateObject = context.object(with: object.objectID) as? Self else { return }
        updateObject.title = title
        updateObject.iconName = iconName
        updateObject.macAddress = macAddress
        if let ipAddress = form.ipAddress {
            updateObject.ipAddress = ipAddress
        }
        if let port = form.port {
            updateObject.port = port
        }
    }

}

// MARK: - Managed
extension Host: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        [NSSortDescriptor(key: #keyPath(createdAt), ascending: false)]
    }

}

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
    @NSManaged private var macAddressData: Data
    @NSManaged private var ipAddressData: Data?
    @NSManaged private(set) var port: String?
    
    private(set) var macAddress: String {
        get {
            return HostCoreDataFormatter.decompress(data: macAddressData, ofType: .macAddress)
        }
        set {
            macAddressData = HostCoreDataFormatter.compress(string: newValue, ofType: .macAddress)
        }
    }
    
    private(set) var ipAddress: String? {
        get {
            guard let ipAddressData = ipAddressData else { return nil }
            return HostCoreDataFormatter.decompress(data: ipAddressData, ofType: .ipAddress)
        }
        set {
            guard let ipAddress = newValue else { ipAddressData = nil; return }
            ipAddressData = HostCoreDataFormatter.compress(string: ipAddress, ofType: .ipAddress)
        }
    }
    
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

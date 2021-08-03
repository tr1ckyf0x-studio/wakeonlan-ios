//
//  Host+CoreDataClass.swift
//
//
//  Created by Владислав Лисянский on 20.05.2020.
//
//

import CoreData
import SharedProtocols

public final class Host: NSManagedObject, HostRepresentable {
    @NSManaged public private(set) var createdAt: Date
    @NSManaged public private(set) var title: String
    @NSManaged public private(set) var iconName: String
    @NSManaged public private(set) var port: String?
    @NSManaged private var macAddressData: Data?
    @NSManaged private var ipAddressData: Data?

    public private(set) var macAddress: String? {
        get {
            macAddressData.map { data in
                CoreDataHostFormatter.decompress(data: data, ofType: .macAddress)
            }
        }
        set {
            macAddressData = newValue.map { value in
                CoreDataHostFormatter.compress(string: value, ofType: .macAddress)
            }
        }
    }

    public private(set) var ipAddress: String? {
        get {
            guard let ipAddressData = ipAddressData else { return nil }
            return CoreDataHostFormatter.decompress(data: ipAddressData, ofType: .ipAddress)
        }
        set {
            guard let ipAddress = newValue else { ipAddressData = nil; return }
            ipAddressData = CoreDataHostFormatter.compress(string: ipAddress, ofType: .ipAddress)
        }
    }

    override public func awakeFromInsert() {
        super.awakeFromInsert()
        primitiveCreatedAt = Date()
    }

    // MARK: - Private

    @NSManaged private var primitiveCreatedAt: Date

}

// MARK: - CRUD

public extension Host {

    static func insert<T: AddHostFormRepresentable>(into context: NSManagedObjectContext, form: T) {
        guard
            let macAddress = form.macAddress,
            let title = form.title,
            let iconName = form.iconModel?.sfSymbol else { return }
        let host: Host = context.insertObject()
        host.iconName = iconName.systemName
        host.title = title
        host.macAddress = macAddress
        host.ipAddress = form.ipAddress
        host.port = form.port
    }

    static func update<T: AddHostFormRepresentable>(
        object: Host,
        into context: NSManagedObjectContext,
        with form: T
    ) {
        guard
            let macAddress = form.macAddress,
            let title = form.title,
            let iconName = form.iconModel?.sfSymbol,
            let updateObject = context.object(with: object.objectID) as? Self else { return }
        updateObject.title = title
        updateObject.iconName = iconName.systemName
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
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        [NSSortDescriptor(key: #keyPath(createdAt), ascending: false)]
    }
}

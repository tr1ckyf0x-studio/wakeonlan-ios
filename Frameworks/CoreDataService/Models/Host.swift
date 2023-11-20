//
//  Host+CoreDataClass.swift
//
//
//  Created by Владислав Лисянский on 20.05.2020.
//
//

import CoreData
import SharedProtocolsAndModels

public final class Host: NSManagedObject, HostRepresentable {

    @NSManaged public private(set) var id: UUID
    @NSManaged public private(set) var order: Int
    @NSManaged public private(set) var title: String
    @NSManaged public private(set) var iconName: String
    @NSManaged public private(set) var port: String?
    @NSManaged public private(set) var destination: String?
    @NSManaged private var macAddressData: Data?

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

    override public func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }

}

// MARK: - CRUD

public extension Host {

    static func insert<T: AddHostFormRepresentable>(into context: NSManagedObjectContext, form: T) {
        guard
            let macAddress = form.macAddress,
            let title = form.title,
            let iconName = form.iconModel?.sfSymbol
        else {
            return
        }
        let host: Host = context.insertObject()
        host.iconName = iconName.systemName
        host.title = title
        host.macAddress = macAddress
        host.destination = form.destination
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
        if let destination = form.destination {
            updateObject.destination = destination
        }
        if let port = form.port {
            updateObject.port = port
        }
    }

}

// MARK: - Managed

extension Host: Managed {
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        [NSSortDescriptor(key: #keyPath(order), ascending: true)]
    }
}

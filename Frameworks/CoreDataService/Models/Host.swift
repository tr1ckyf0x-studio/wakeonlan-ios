//
//  Host+CoreDataClass.swift
//
//
//  Created by Vladislav Lisianskii on 20.05.2020.
//
//

import CocoaLumberjack
import CoreData
import SharedProtocolsAndModels

public final class Host: NSManagedObject, HostRepresentable {
    @NSManaged public internal(set) var order: Int
    @NSManaged public internal(set) var title: String
    @NSManaged public internal(set) var iconName: String
    @NSManaged public internal(set) var port: String?
    @NSManaged public internal(set) var destination: String?
    @NSManaged public internal(set) var createdAt: Date

    public internal(set) var macAddress: String? {
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

    @NSManaged private var macAddressData: Data?

    override public func awakeFromInsert() {
        super.awakeFromInsert()
        createdAt = Date()
    }
}

// MARK: - Managed

extension Host: Managed {
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        [NSSortDescriptor(key: #keyPath(order), ascending: true)]
    }
}

// MARK: - UpdatesManagedObject

extension Host: UpdatesManagedObject {
    public typealias Model = any AddHostFormRepresentable
    public typealias ManagedObject = Host

    public func update(from model: Model, in context: NSManagedObjectContext) {
        guard let object = context.object(with: self.objectID) as? Self else { return }
        object.title = model.title
        object.iconName = model.iconModel.sfSymbol.systemName
        object.macAddress = model.macAddress
        object.destination = model.destination
        object.port = model.port
    }
}

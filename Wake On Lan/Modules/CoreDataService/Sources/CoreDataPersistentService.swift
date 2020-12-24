//
//  PersistentCoreDataService.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 20.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CoreData
import CocoaLumberjackSwift

// MARK: - PersistentContainer

public enum PersistentContainer {
    public struct SQLite: PersistentContainerType {
        public static let store = NSSQLiteStoreType
        public static let persistentStoreDescriptions: [NSPersistentStoreDescription]? = nil
    }

    public struct InMemory: PersistentContainerType {
        public static let store = NSInMemoryStoreType
        public static let persistentStoreDescriptions: [NSPersistentStoreDescription]? = {
            let description = NSPersistentStoreDescription()
            description.type = store
            return [description]
        }()
    }
}

// MARK: - PersistentContainerType

public protocol PersistentContainerType {
    static var store: String { get }
    static var persistentStoreDescriptions: [NSPersistentStoreDescription]? { get }
}

// MARK: - CoreDataService

public struct CoreDataService<T: PersistentContainerType>: CoreDataServiceProtocol {

    public var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.persistentContainerName)
        if let persistentStoreDescriptions = T.self.persistentStoreDescriptions {
            container.persistentStoreDescriptions = persistentStoreDescriptions
        }

        return container
    }()

    // MARK: - Init

    public init() { }

}

// MARK: - Private

private enum Constants {
    static let persistentContainerName = "HostsDataModel"
}

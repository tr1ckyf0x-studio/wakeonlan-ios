//
//  PersistentCoreDataService.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 20.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CoreData
import CocoaLumberjackSwift

private enum Constants {
    static let persistentContainerName = "HostsDataModel"
}

// MARK: - PersistentContainer

enum PersistentContainer {
    struct SQLite: PersistentContainerType {
        static let store = NSSQLiteStoreType
        static let persistentStoreDescriptions: [NSPersistentStoreDescription]? = nil
    }

    struct InMemory: PersistentContainerType {
        static let store = NSInMemoryStoreType
        static let persistentStoreDescriptions: [NSPersistentStoreDescription]? = {
            let description = NSPersistentStoreDescription()
            description.type = store
            return [description]
        }()
    }
}

// MARK: - PersistentContainerType

protocol PersistentContainerType {
    static var store: String { get }
    static var persistentStoreDescriptions: [NSPersistentStoreDescription]? { get }
}

// MARK: - CoreDataService

struct CoreDataService<T: PersistentContainerType>: CoreDataServiceProtocol {

    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.persistentContainerName)
        if let persistentStoreDescriptions = T.self.persistentStoreDescriptions {
            container.persistentStoreDescriptions = persistentStoreDescriptions
        }

        return container
    }()

}

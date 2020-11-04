//
//  PersistentCoreDataService.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 20.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CoreData
import CocoaLumberjackSwift

private let persistentContainerName = "HostsDataModel"

// MARK: - PersistentContainer

enum PersistentContainer {
    struct SQLite: PersistentContainerType {
        static var store = NSSQLiteStoreType
        static var persistentStoreDescriptions: [NSPersistentStoreDescription]? = nil
    }

    struct InMemory: PersistentContainerType {
        static var store = NSInMemoryStoreType
        static var persistentStoreDescriptions: [NSPersistentStoreDescription]? = {
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

// MARK: - PersistentCoreDataService

struct PersistentCoreDataService<T: PersistentContainerType>: CoreDataService {

    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistentContainerName)
        if let persistentStoreDescriptions = T.self.persistentStoreDescriptions {
            container.persistentStoreDescriptions = persistentStoreDescriptions
        }

        return container
    }()

}

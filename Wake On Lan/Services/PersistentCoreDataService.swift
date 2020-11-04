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
        static var store: StoreType { .sqLite }
    }

    struct InMemory: PersistentContainerType {
        static var store: StoreType { .inMemory }
    }
}

// MARK: - PersistentContainerType

protocol PersistentContainerType {
    static var store: StoreType { get }
}

// MARK: - StoreType

enum StoreType {
    case inMemory
    case sqLite
}

// MARK: - PersistentCoreDataService

struct PersistentCoreDataService<T: PersistentContainerType>: CoreDataService {

    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistentContainerName)
        switch T.self.store {
        case .sqLite:
            return container

        case .inMemory:
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        return container
    }()

}

//
//  PersistentCoreDataService.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 20.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import CocoaLumberjack
import CoreData
import SharedProtocolsAndModels

// MARK: - PersistentContainer

public enum StoreType {
    case sqlite(URL)
    case inMemory
}

// MARK: - CoreDataService

public final class CoreDataService: CoreDataServiceProtocol {

    public private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()

    public private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(
            name: CoreDataConstants.persistentContainerName,
            managedObjectModel: managedObjectModel
        )

        let descriptions = PersistentStoreDescriptionFactory().descriptions(for: storeType)
        container.persistentStoreDescriptions = descriptions

        return container
    }()

    private lazy var managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle.resourcesBundle
        let modelURL = bundle.url(
            forResource: CoreDataConstants.persistentContainerName,
            withExtension: CoreDataConstants.persistentContainerExtension
        )
        let model = modelURL.flatMap { NSManagedObjectModel(contentsOf: $0) }
        guard let model else { fatalError("\(self) : Cannot load Core Data model") }

        return model
    }()

    private let storeType: StoreType

    // MARK: - Init

    public init(storeType: StoreType) {
        self.storeType = storeType
        createHostContainer()
    }
}

// MARK: - ProvidesWeakSharedInstanceTrait

extension CoreDataService: ProvidesWeakSharedInstanceTrait {
    public static weak var weakSharedInstance: CoreDataService?

    public convenience init() {
        guard let persistentContainerURL = CoreDataConstants.persistentContainerURL else {
            fatalError("Persistent container URL is unavailable")
        }
        self.init(storeType: .sqlite(persistentContainerURL))
    }
}

private struct PersistentStoreDescriptionFactory {
    func descriptions(for storeType: StoreType) -> [NSPersistentStoreDescription] {
        switch storeType {
        case let .sqlite(url):
            sqliteDescriptions(url: url)

        case .inMemory:
            inMemoryDescriptions()
        }
    }

    private func sqliteDescriptions(url: URL) -> [NSPersistentStoreDescription] {
        let description = NSPersistentStoreDescription(url: url)
        description.type = NSSQLiteStoreType
        return [description]
    }

    private func inMemoryDescriptions() -> [NSPersistentStoreDescription] {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        return [description]
    }
}

//
//  CoreDataService+Init.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 13. 4. 2025..
//

import PersistenceCore
import SharedProtocolsAndModels
import WOLSharedProtocolsAndModels

// MARK: - ProvidesWeakSharedInstanceTrait

extension CoreDataService: @retroactive ProvidesSharedInstance { }
extension CoreDataService: @retroactive ProvidesWeakSharedInstanceTrait {
    public static weak var weakSharedInstance: CoreDataService?

    public convenience init() {
        guard let persistentContainerURL = CoreDataConstants.persistentContainerURL else {
            fatalError("Persistent container URL is unavailable")
        }

        guard let managedModelURL = CoreDataConstants.managedModelURL else {
            fatalError("Managed model URL is unavailable")
        }

        self.init(
            storeType: .sqlite(persistentContainerURL),
            persistentContainerName: CoreDataConstants.persistentContainerName,
            managedObjectModelURL: managedModelURL
        )
    }
}

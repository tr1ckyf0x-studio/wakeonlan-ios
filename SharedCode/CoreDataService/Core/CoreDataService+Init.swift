//
//  CoreDataService+Init.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 13. 4. 2025..
//

import CocoaLumberjackSwift
import PersistenceCore
import SharedProtocolsAndModels
import WOLSharedProtocolsAndModels

// MARK: - ProvidesWeakSharedInstanceTrait

extension CoreDataService: @retroactive ProvidesSharedInstance { }
extension CoreDataService: @retroactive ProvidesWeakSharedInstanceTrait {
    // NOTE: `nonisolated(unsafe)` because the trait's `shared` getter is nonisolated and the
    // Siri extension reaches for it outside the main actor. The instance is created once per
    // process through a lazy global, so there is no realistic race — but the compiler cannot
    // prove it. Replacing this weak-singleton trait with injected dependencies would.
    nonisolated(unsafe) public static weak var weakSharedInstance: CoreDataService?

    public convenience init() {
        guard let persistentContainerURL = CoreDataConstants.persistentContainerURL else {
            fatalError("Persistent container URL is unavailable")
        }

        guard let managedModelURL = CoreDataConstants.managedModelURL else {
            fatalError("Managed model URL is unavailable")
        }

        // NOTE: must run before the container opens the store — see `HostStoreMigrator`.
        // The failure is swallowed on purpose: the migrator leaves the store at the version it
        // already had, so the container below opens exactly what was there before.
        do {
            try HostStoreMigrator.migrateIfNeeded(storeURL: persistentContainerURL, modelURL: managedModelURL)
        } catch {
            DDLogError("HostStoreMigrator: \(error)")
        }

        self.init(
            storeType: .sqlite(persistentContainerURL),
            persistentContainerName: CoreDataConstants.persistentContainerName,
            managedObjectModelURL: managedModelURL
        )
    }
}

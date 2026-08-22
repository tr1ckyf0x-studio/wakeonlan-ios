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
        //
        // A failure here cannot simply be logged and stepped over. `PersistenceCore` hands Core Data
        // a bare `NSPersistentStoreDescription`, leaving `shouldMigrateStoreAutomatically` and
        // `shouldInferMappingModelAutomatically` at their `true` default, so the container built
        // below would run exactly the single-hop inferred migration that `HostMigrationStages` exists
        // to replace: the one that drops the host address and the list order. The result is a list
        // that still looks right and wakes nothing.
        //
        // Discarding the store is the lesser loss. The user sees an empty list — obvious, and fixed
        // by re-adding hosts — rather than entries that quietly point at the wrong machine.
        do {
            try HostStoreMigrator.migrateIfNeeded(storeURL: persistentContainerURL, modelURL: managedModelURL)
        } catch {
            DDLogError("HostStoreMigrator: migration failed, discarding the store: \(error)")
            HostStoreMigrator.discardStore(at: persistentContainerURL)
        }

        self.init(
            storeType: .sqlite(persistentContainerURL),
            persistentContainerName: CoreDataConstants.persistentContainerName,
            managedObjectModelURL: managedModelURL
        )
    }
}

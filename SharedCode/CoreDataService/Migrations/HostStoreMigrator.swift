//
//  HostStoreMigrator.swift
//  CoreDataService
//
//  Created by Vladislav Lisianskii on 22. 8. 2026..
//

import CocoaLumberjackSwift
import CoreData

/// Brings the host store up to the current model version before anything else opens it.
///
/// - Note: this exists as a separate pass rather than an option on the app's own container because
///   `PersistenceCore.CoreDataService` builds its store descriptions privately and exposes no seam to
///   attach anything to them. Migrating here first is enough: by the time the real container opens
///   the file it is already current and has nothing to do.
enum HostStoreMigrator {
    /// Runs the staged migration. Safe to call when the store is already current, or absent.
    ///
    /// - Throws: ``Failure`` when the model cannot be loaded or a stage fails.
    ///   `NSStagedMigrationManager` leaves the store untouched at its original version in that case,
    ///   so a caller that swallows the error goes on to open exactly what was there before — no
    ///   half-written state either way. Reporting it rather than swallowing it here is what lets the
    ///   tests tell a failed migration apart from one that succeeded and produced the wrong rows.
    static func migrateIfNeeded(storeURL: URL, modelURL: URL) throws {
        guard FileManager.default.fileExists(atPath: storeURL.path) else { return }

        // Detached from `Host` for the same reason the stages are — see `HostMigrationStages`.
        guard let model = HostMigrationStages.detachedModel(at: modelURL) else {
            throw Failure.modelUnavailable(modelURL)
        }

        let description = NSPersistentStoreDescription(url: storeURL)
        description.type = NSSQLiteStoreType
        description.setOption(
            try NSStagedMigrationManager(HostMigrationStages.all(modelURL: modelURL)),
            forKey: NSPersistentStoreStagedMigrationManagerOptionKey
        )

        let container = NSPersistentContainer(name: storeURL.deletingPathExtension().lastPathComponent, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]

        let outcome = Outcome()
        container.loadPersistentStores { _, error in
            outcome.error = error
        }

        if let error = outcome.error {
            throw Failure.migrationFailed(error)
        }

        // Hand the file back before the app's own container opens it.
        let coordinator = container.persistentStoreCoordinator
        coordinator.persistentStores.forEach { try? coordinator.remove($0) }
    }
}

// MARK: - Outcome

extension HostStoreMigrator {
    /// `loadPersistentStores` calls back synchronously for a SQLite store, but its handler still
    /// escapes, so the result comes back through a reference rather than a captured `var`.
    private final class Outcome {
        var error: Error?
    }
}

// MARK: - Discarding

extension HostStoreMigrator {
    /// Deletes the store so the next container opens on an empty one at the current model version.
    ///
    /// Only ever called after ``migrateIfNeeded(storeURL:modelURL:)`` has failed. Leaving the file in
    /// place is the worse option: `PersistenceCore` builds a bare `NSPersistentStoreDescription`, so
    /// the container that opens next would run Core Data's inferred single-hop migration over it and
    /// produce a host list whose addresses are silently wrong — hosts that look right and wake
    /// nothing. An empty list is at least honest about having lost something.
    static func discardStore(at storeURL: URL) {
        // The journal files are part of the store; leaving them behind resurrects pages of the old
        // one when SQLite next opens the path.
        let files = [storeURL]
            + ["-wal", "-shm"].map { URL(fileURLWithPath: storeURL.path + $0) }

        for file in files where FileManager.default.fileExists(atPath: file.path) {
            do {
                try FileManager.default.removeItem(at: file)
            } catch {
                DDLogError("HostStoreMigrator: could not remove \(file.lastPathComponent): \(error)")
            }
        }
    }
}

// MARK: - Failure

extension HostStoreMigrator {
    enum Failure: Error {
        /// The compiled model could not be read from the bundle.
        case modelUnavailable(URL)
        /// A stage failed. The store is left at the version it already had.
        case migrationFailed(any Error)
    }
}

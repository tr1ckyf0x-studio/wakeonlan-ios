//
//  HostMigrationStages.swift
//  CoreDataService
//
//  Created by Vladislav Lisianskii on 22. 8. 2026..
//

import CoreData

/// The ordered v1 → v2 → v3 → v4 migration of the host store.
///
/// - Note: `NSStagedMigrationManager` is what finally walks the version chain. Core Data's automatic
///   migration never did: it is single-hop, so a store at v1 got an *inferred* v1→v4 mapping that
///   matched attributes by name and silently dropped everything it could not place — every host lost
///   its address, because v1 keeps it as packed bytes under `ipAddressData` while v2 onwards keeps a
///   string in `destination`, and the whole list lost its ordering, because `order` did not exist
///   before v3.
///
/// - Important: never give this type or its members an actor. The stage handlers are plain
///   non-`@Sendable` closures, so they inherit the isolation of wherever they are written, and Core
///   Data calls them synchronously on the coordinator's own queue. Under `@MainActor` they would
///   compile clean and trap in `_dispatch_assert_queue_fail` the first time the Siri extension opened
///   the store off the main thread.
enum HostMigrationStages {
    /// - Parameter modelURL: the `.momd` bundle holding every version.
    static func all(modelURL: URL) throws -> [NSMigrationStage] {
        // Carried between stages: the values a schema step is about to destroy.
        let scratch = Scratch()
        let checksums = try checksums(modelURL: modelURL)

        // NOTE: one reference per version, shared by the stages on either side of it. Handing Core
        // Data two distinct model objects for the same version — one as a stage's `nextModel` and
        // another as the following stage's `currentModel` — corrupts its migrator's heap and traps
        // inside `saveMetadata:`.
        let v1 = try reference(modelURL, .v1, checksums)
        let v2 = try reference(modelURL, .v2, checksums)
        let v3 = try reference(modelURL, .v3, checksums)
        let v4 = try reference(modelURL, .v4, checksums)

        return [
            addressStage(from: v1, to: v2, scratch: scratch),
            orderStage(from: v2, to: v3, scratch: scratch),
            creationDateStage(from: v3, to: v4, scratch: scratch)
        ]
    }
}

// MARK: - Stages

extension HostMigrationStages {
    /// v1 → v2: `ipAddressData` (packed bytes) becomes `destination` (a string).
    ///
    /// The two attributes never coexist, so the value has to be read before the schema step and
    /// written after it. Rows are matched by object ID, which survives an in-place migration.
    private static func addressStage(
        from current: NSManagedObjectModelReference,
        to next: NSManagedObjectModelReference,
        scratch: Scratch
    ) -> NSCustomMigrationStage {
        let stage = NSCustomMigrationStage(migratingFrom: current, to: next)
        stage.label = "Host v1 to v2: unpack the address"

        stage.willMigrateHandler = { manager, _ in
            try manager.eachHost { host, key in
                guard let data = host.value(forKey: Key.ipAddressData) as? Data else { return }
                scratch.addresses[key] = CoreDataHostFormatter.decompress(data: data, ofType: .ipAddress)
            }
        }
        stage.didMigrateHandler = { manager, _ in
            try manager.eachHost { host, key in
                guard let address = scratch.addresses[key] else { return }
                host.setValue(address, forKey: Key.destination)
            }
        }
        return stage
    }

    /// v2 → v3: `order` appears and `createdAt` disappears.
    ///
    /// The ordering the list has always shown is newest first, which is also what
    /// `HostCRUDWorker.create` maintains by pushing every existing row down. `createdAt` is stashed
    /// here so the next stage can put it back instead of inventing a new date.
    private static func orderStage(
        from current: NSManagedObjectModelReference,
        to next: NSManagedObjectModelReference,
        scratch: Scratch
    ) -> NSCustomMigrationStage {
        let stage = NSCustomMigrationStage(migratingFrom: current, to: next)
        stage.label = "Host v2 to v3: derive the list order"

        stage.willMigrateHandler = { manager, _ in
            var dates: [(key: String, date: Date)] = []
            try manager.eachHost { host, key in
                // NOTE: v3 makes `iconName` mandatory with no default, so a row that still has the
                // nil it was allowed at v2 aborts the whole schema step with a validation error.
                // Backfilling has to happen here, while the attribute is still optional.
                if host.value(forKey: Key.iconName) as? String == nil {
                    host.setValue(Constants.fallbackIconName, forKey: Key.iconName)
                }
                if let date = host.value(forKey: Key.createdAt) as? Date {
                    dates.append((key, date))
                }
            }
            scratch.creationDates = Dictionary(dates.map { ($0.key, $0.date) }) { first, _ in first }
            for (index, entry) in dates.sorted(by: { $0.date > $1.date }).enumerated() {
                scratch.orders[entry.key] = index
            }
        }
        stage.didMigrateHandler = { manager, _ in
            try manager.eachHost { host, key in
                host.setValue(scratch.orders[key] ?? .zero, forKey: Key.order)
            }
        }
        return stage
    }

    /// v3 → v4: `createdAt` comes back.
    ///
    /// Restored from what the previous stage stashed, falling back to now for a store that was
    /// already at v3 and never had one.
    private static func creationDateStage(
        from current: NSManagedObjectModelReference,
        to next: NSManagedObjectModelReference,
        scratch: Scratch
    ) -> NSCustomMigrationStage {
        let stage = NSCustomMigrationStage(migratingFrom: current, to: next)
        stage.label = "Host v3 to v4: restore the creation date"

        stage.didMigrateHandler = { manager, _ in
            try manager.eachHost { host, key in
                host.setValue(scratch.creationDates[key] ?? Date(), forKey: Key.createdAt)
            }
        }
        return stage
    }

    private static func reference(
        _ modelURL: URL,
        _ version: Version,
        _ checksums: [String: String]
    ) throws -> NSManagedObjectModelReference {
        let url = modelURL.appendingPathComponent(version.fileName)
        guard let model = detachedModel(at: url) else {
            // No silent fallback to `NSManagedObjectModelReference(fileURL:)`: it would give up the
            // detaching that `detachedModel` exists for, and the crash that costs lands on the *next*
            // launch, far from here.
            throw Failure.modelUnreadable(url)
        }
        guard let checksum = checksums[version.modelName] else {
            throw Failure.checksumsMissing([version.modelName])
        }
        return NSManagedObjectModelReference(model: model, versionChecksum: checksum)
    }

    /// A copy of the model whose entities are plain `NSManagedObject` rather than `Host`.
    ///
    /// - Note: this is not tidiness, it is the difference between launching and crashing. Core Data
    ///   binds a subclass to whichever loaded model claims it first, process-wide. The migration holds
    ///   four versions open, all naming `CoreDataService.Host`; leaving them bound left `Host.entity()`
    ///   pointing at a migration model that no longer exists, and the app died on the next launch in
    ///   `Managed.entityName` before the host list ever appeared. Migration only reads and writes by
    ///   key, so it has no use for the subclass.
    ///
    /// - Note: detaching does not change `versionChecksum`, so the stage still resolves. Verified
    ///   against all four versions.
    static func detachedModel(at url: URL) -> NSManagedObjectModel? {
        guard
            let model = NSManagedObjectModel(contentsOf: url),
            // A model compiled into a `.momd` is immutable; only a copy can be re-pointed.
            let editable = model.copy() as? NSManagedObjectModel
        else {
            return nil
        }
        editable.entities.forEach { entity in
            entity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        }
        return editable
    }
}

// MARK: - Failure

extension HostMigrationStages {
    enum Failure: Error {
        /// `VersionInfo.plist` is missing, unreadable, or not shaped the way `momc` writes it.
        case checksumsUnavailable(URL)
        /// The plist parsed but does not describe every version the chain walks.
        case checksumsMissing([String])
        /// A `.mom` could not be loaded, so it could not be detached from `Host` either.
        case modelUnreadable(URL)
    }
}

// MARK: - Scratch

extension HostMigrationStages {
    /// Values handed from one stage to the next, keyed by object ID.
    ///
    /// Core Data drives every handler synchronously on the coordinator's own queue, one after the
    /// other, so this is only ever touched from a single thread.
    private final class Scratch {
        var addresses: [String: String] = [:]
        var orders: [String: Int] = [:]
        var creationDates: [String: Date] = [:]
    }
}

// MARK: - Versions

extension HostMigrationStages {
    private enum Version: CaseIterable {
        case v1, v2, v3, v4

        /// The name Core Data knows the version by: the `.mom` basename, and the key under
        /// `NSManagedObjectModel_VersionChecksums` in `HostsDataModel.momd/VersionInfo.plist`.
        var modelName: String {
            switch self {
            case .v1: return "HostsDataModel"
            case .v2: return "HostsDataModel v2"
            case .v3: return "HostsDataModel v3"
            case .v4: return "HostsDataModel v4"
            }
        }

        var fileName: String { "\(modelName).mom" }
    }

    /// Version checksums, read from the compiled model rather than copied into source.
    ///
    /// `momc` writes them into `HostsDataModel.momd/VersionInfo.plist`, which ships inside the
    /// framework, so the values cannot drift from the models the way four hardcoded strings could —
    /// and a checksum that no longer matches its model does not fail loudly, it makes
    /// `NSStagedMigrationManager` skip the stage.
    ///
    /// Note this is `NSManagedObjectModel.versionChecksum`, **not** the entity version hash under
    /// `NSManagedObjectModel_VersionHashes`, which is a different value entirely.
    private static func checksums(modelURL: URL) throws -> [String: String] {
        let plistURL = modelURL.appendingPathComponent("VersionInfo.plist")
        let data = try Data(contentsOf: plistURL)
        let plist = try PropertyListSerialization.propertyList(from: data, format: nil)

        guard
            let root = plist as? [String: Any],
            let checksums = root["NSManagedObjectModel_VersionChecksums"] as? [String: String]
        else {
            throw Failure.checksumsUnavailable(plistURL)
        }

        let missing = Version.allCases.map(\.modelName).filter { checksums[$0] == nil }
        guard missing.isEmpty else {
            throw Failure.checksumsMissing(missing)
        }

        return checksums
    }

    private enum Key {
        static let ipAddressData = "ipAddressData"
        static let destination = "destination"
        static let iconName = "iconName"
        static let createdAt = "createdAt"
        static let order = "order"
    }

    private enum Constants {
        static let entityName = "Host"
        /// The same icon a freshly added host gets.
        static let fallbackIconName = "desktopcomputer"
    }
}

// MARK: - UncheckedSendable

/// Carries a non-`Sendable` value into `performAndWait`.
///
/// Core Data imports it as `performAndWait<T>(_ block: @Sendable () throws -> T) rethrows -> T`, so
/// the block may not capture the caller's visitor closure — even though the block is non-escaping
/// and runs to completion before `performAndWait` returns, meaning nothing ever crosses a thread
/// boundary. The annotation is what is being worked around here, not the guarantee behind it.
private struct UncheckedSendable<Value>: @unchecked Sendable {
    let value: Value

    init(_ value: Value) {
        self.value = value
    }
}

// MARK: - NSStagedMigrationManager

extension NSStagedMigrationManager {
    /// Visits every host in the store the migration currently has open.
    ///
    /// The key is the object ID URI, which an in-place migration preserves across a schema step, so
    /// it is what lets one handler hand a value to the next.
    ///
    /// - Note: this deliberately does **not** use `container.viewContext`. Core Data runs the stage
    ///   handlers on its own migration thread, so touching a main-queue context here is a
    ///   concurrency violation, and a quiet one: the fetched rows get registered in a context whose
    ///   queue is the main queue, so Core Data schedules `_forgetObject:` for them there. The
    ///   migration then finishes and releases the model, and the main queue drains afterwards into a
    ///   freed entity — a `SIGSEGV` in `_PFObjectIDFastHash64`, landing far from this code and on
    ///   whatever happened to run next. A private-queue context of our own keeps the registry on the
    ///   thread that fills it, and the reset empties it while the model is still alive.
    fileprivate func eachHost(_ body: (NSManagedObject, String) throws -> Void) throws {
        guard let container else { return }
        let context = container.newBackgroundContext()
        try withoutActuallyEscaping(body) { body in
            let visit = UncheckedSendable(body)
            try context.performAndWait {
                defer { context.reset() }
                try autoreleasepool {
                    let request = NSFetchRequest<NSManagedObject>(entityName: "Host")
                    for host in try context.fetch(request) {
                        try visit.value(host, host.objectID.uriRepresentation().absoluteString)
                    }
                    if context.hasChanges {
                        try context.save()
                    }
                }
            }
        }
    }
}

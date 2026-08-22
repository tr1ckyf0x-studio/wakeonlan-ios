//
//  HostStoreFixture.swift
//  SharedCodeTests
//
//  Created by Vladislav Lisianskii on 22. 8. 2026..
//

import CoreData
import Foundation

@testable import CoreDataService

/// A throwaway host store seeded with one of the shipped model versions.
///
/// Seeding through the real `.momd` rather than a checked-in binary is deliberate: the fixture then
/// tracks the models, and a future edit to an old version cannot leave the tests passing against a
/// shape that no longer exists.
struct HostStoreFixture {
    enum Version: String {
        case v1 = "HostsDataModel.mom"
        case v2 = "HostsDataModel v2.mom"
        case v3 = "HostsDataModel v3.mom"
        case current = "HostsDataModel v4.mom"
    }

    /// What a row looks like once it has been read back with the current model.
    struct Row {
        let title: String
        let iconName: String?
        let destination: String?
        let order: Int?
        let createdAt: Date?
    }

    let storeURL: URL
    private let modelURL: URL

    // MARK: - Init

    init(version: Version, count: Int = 3, seed: (NSManagedObject, Int) -> Void) throws {
        let bundle = Bundle(for: Host.self)
        guard let modelURL = bundle.url(forResource: "HostsDataModel", withExtension: "momd") else {
            throw Failure.modelMissing
        }
        self.modelURL = modelURL
        storeURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(UUID().uuidString).sqlite")

        guard let model = Self.genericModel(at: modelURL.appendingPathComponent(version.rawValue)) else {
            throw Failure.modelVersionMissing(version)
        }

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        _ = try coordinator.addPersistentStore(type: .sqlite, at: storeURL)
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator

        try withoutActuallyEscaping(seed) { seed in
            let seed = UncheckedSendable(seed)
            try context.performAndWait {
                defer { context.reset() }
                for index in 0..<count {
                    seed.value(
                        NSEntityDescription.insertNewObject(forEntityName: "Host", into: context),
                        index
                    )
                }
                try context.save()
            }
        }
        try coordinator.persistentStores.forEach(coordinator.remove)
    }

    // MARK: - Internal

    /// Runs the migrator and reads the store back with the current model.
    func migrateAndRead() throws -> [Row] {
        try HostStoreMigrator.migrateIfNeeded(storeURL: storeURL, modelURL: modelURL)

        guard let current = Self.genericModel(at: modelURL) else { throw Failure.modelMissing }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: current)
        _ = try coordinator.addPersistentStore(type: .sqlite, at: storeURL)
        defer { try? coordinator.persistentStores.forEach(coordinator.remove) }

        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator

        return try context.performAndWait {
            defer { context.reset() }
            // NOTE: read as raw values, not as `Host`. `Host.createdAt` is a non-optional `Date`, so
            // a store that came out of migration without one would trap here instead of failing the
            // test.
            return try context.fetch(NSFetchRequest<NSManagedObject>(entityName: "Host")).map { row in
                Row(
                    title: row.value(forKey: "title") as? String ?? .init(),
                    iconName: row.value(forKey: "iconName") as? String,
                    destination: row.value(forKey: "destination") as? String,
                    order: row.value(forKey: "order") as? Int,
                    createdAt: row.value(forKey: "createdAt") as? Date
                )
            }
        }
    }

    /// Loads a model with its entities detached from `Host`, for the same reason `HostStoreMigrator`
    /// does: two versions are open at once here and Core Data would bind the subclass to whichever
    /// claimed it first.
    private static func genericModel(at url: URL) -> NSManagedObjectModel? {
        guard
            let model = NSManagedObjectModel(contentsOf: url),
            let editable = model.copy() as? NSManagedObjectModel
        else {
            return nil
        }
        editable.entities.forEach { $0.managedObjectClassName = NSStringFromClass(NSManagedObject.self) }
        return editable
    }

    func modificationDate() throws -> Date? {
        try FileManager.default.attributesOfItem(atPath: storeURL.path)[.modificationDate] as? Date
    }
}

// MARK: - Failure

extension HostStoreFixture {
    enum Failure: Error {
        case modelMissing
        case modelVersionMissing(Version)
    }
}

// MARK: - UncheckedSendable

/// Carries a non-`Sendable` value into `performAndWait`, which Core Data imports with a `@Sendable`
/// block even though it runs that block synchronously and does not let it escape.
private struct UncheckedSendable<Value>: @unchecked Sendable {
    let value: Value

    init(_ value: Value) {
        self.value = value
    }
}

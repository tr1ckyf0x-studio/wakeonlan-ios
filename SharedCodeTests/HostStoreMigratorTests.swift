//
//  HostStoreMigratorTests.swift
//  SharedCodeTests
//
//  Created by Vladislav Lisianskii on 22. 8. 2026..
//

import CoreData
import Testing

@testable import CoreDataService

/// Covers the store rewrite that replaced Core Data's automatic lightweight migration.
///
/// Every case seeds a store with a real historical model version out of the shipped `.momd`, runs the
/// migrator, and reads the result back with the current model — the same sequence a user's app goes
/// through on first launch after updating.
///
/// Every case also asserts the row count outright. Without it a dropped row surfaces only as a set
/// one element short, which reads like a wrong value rather than a missing host — the exact
/// ambiguity that made the first CI failure here hard to place.
// NOTE: `.serialized` is load-bearing. Core Data binds the `@NSManaged` accessors of a subclass to
// whichever model claims it first, process-wide, and every case here opens a different version of the
// same `Host` entity. Run in parallel they corrupt each other's bindings and crash the test host.
@Suite("Host store migration", .serialized)
struct HostStoreMigratorTests {
    @Test("A v1 store keeps the address that used to be packed into ipAddressData")
    func migratesV1Address() throws {
        let store = try HostStoreFixture(version: .v1) { row, index in
            row.setValue("Host \(index)", forKey: "title")
            row.setValue("desktopcomputer", forKey: "iconName")
            row.setValue(Data([192, 168, 1, UInt8(10 + index)]), forKey: "ipAddressData")
            row.setValue(Date(timeIntervalSince1970: TimeInterval(1_600_000_000 + index)), forKey: "createdAt")
        }

        let hosts = try store.migrateAndRead()

        #expect(hosts.count == 3)
        #expect(Set(hosts.map(\.destination)) == ["192.168.1.10", "192.168.1.11", "192.168.1.12"])
    }

    @Test("A v1 store is ordered newest first rather than collapsed onto one position")
    func migratesV1Order() throws {
        let store = try HostStoreFixture(version: .v1) { row, index in
            row.setValue("Host \(index)", forKey: "title")
            row.setValue("desktopcomputer", forKey: "iconName")
            row.setValue(Date(timeIntervalSince1970: TimeInterval(1_600_000_000 + index)), forKey: "createdAt")
        }

        let hosts = try store.migrateAndRead()

        #expect(hosts.count == 3)
        // Seeded oldest first, so the newest — "Host 2" — has to end up on top.
        #expect(hosts.sorted { ($0.order ?? .max) < ($1.order ?? .max) }.map(\.title) == ["Host 2", "Host 1", "Host 0"])
        #expect(Set(hosts.map(\.order)) == [0, 1, 2])
    }

    @Test("A v2 store keeps its address and gains an ordering")
    func migratesV2() throws {
        let store = try HostStoreFixture(version: .v2) { row, index in
            row.setValue("Host \(index)", forKey: "title")
            row.setValue("desktopcomputer", forKey: "iconName")
            row.setValue("10.0.0.\(index)", forKey: "destination")
            row.setValue(Date(timeIntervalSince1970: TimeInterval(1_600_000_000 + index)), forKey: "createdAt")
        }

        let hosts = try store.migrateAndRead()

        #expect(hosts.count == 3)
        #expect(Set(hosts.map(\.destination)) == ["10.0.0.0", "10.0.0.1", "10.0.0.2"])
        #expect(Set(hosts.map(\.order)) == [0, 1, 2])
    }

    @Test("A v3 store keeps the order it already had and gets a creation date")
    func migratesV3() throws {
        let store = try HostStoreFixture(version: .v3) { row, index in
            row.setValue("Host \(index)", forKey: "title")
            row.setValue("desktopcomputer", forKey: "iconName")
            row.setValue("10.0.0.\(index)", forKey: "destination")
            row.setValue(index, forKey: "order")
        }

        let hosts = try store.migrateAndRead()

        #expect(hosts.count == 3)
        #expect(hosts.sorted { ($0.order ?? .max) < ($1.order ?? .max) }.map(\.title) == ["Host 0", "Host 1", "Host 2"])
        // v3 has no createdAt at all; reading it back must not trap on the non-optional property.
        #expect(hosts.allSatisfy { $0.createdAt != nil })
    }

    @Test("A store already at the current version is left alone")
    func leavesCurrentVersionAlone() throws {
        let store = try HostStoreFixture(version: .current) { row, index in
            row.setValue("Host \(index)", forKey: "title")
            row.setValue("desktopcomputer", forKey: "iconName")
            row.setValue("10.0.0.\(index)", forKey: "destination")
            row.setValue(index, forKey: "order")
            row.setValue(Date(timeIntervalSince1970: 1_600_000_000), forKey: "createdAt")
        }

        let before = try store.modificationDate()
        let hosts = try store.migrateAndRead()

        #expect(hosts.count == 3)
        #expect(try store.modificationDate() == before)
    }

    @Test("A v1 store keeps the creation dates it already had")
    func preservesV1CreationDates() throws {
        let dates = (0..<3).map { Date(timeIntervalSince1970: TimeInterval(1_600_000_000 + $0)) }
        let store = try HostStoreFixture(version: .v1) { row, index in
            row.setValue("Host \(index)", forKey: "title")
            row.setValue("desktopcomputer", forKey: "iconName")
            row.setValue(dates[index], forKey: "createdAt")
        }

        let hosts = try store.migrateAndRead()

        #expect(hosts.count == 3)
        // v3 drops createdAt entirely, so surviving the chain means the stages carried it across.
        #expect(Set(hosts.compactMap(\.createdAt)) == Set(dates))
    }

    @Test("A host saved without an icon survives the step that makes the icon mandatory")
    func backfillsMissingIconName() throws {
        let store = try HostStoreFixture(version: .v2, count: 1) { row, _ in
            row.setValue("No icon", forKey: "title")
            row.setValue("10.0.0.1", forKey: "destination")
            row.setValue(Date(), forKey: "createdAt")
            // iconName is left nil, which v2 allows and v3 does not.
        }

        let hosts = try store.migrateAndRead()

        #expect(hosts.count == 1)
        #expect(hosts.first?.iconName?.isEmpty == false)
    }

    @Test("Migrating an empty store is a no-op rather than a failure")
    func migratesEmptyStore() throws {
        let store = try HostStoreFixture(version: .v1, count: 0) { _, _ in }
        #expect(try store.migrateAndRead().isEmpty)
    }
}

// MARK: - Discarding

@Suite("Discarding a store", .serialized)
struct HostStoreDiscardTests {
    @Test("Discarding removes the store together with its journal files")
    func discardRemovesJournalFiles() throws {
        let store = try HostStoreFixture(version: .current, count: 1) { row, _ in
            row.setValue("Host", forKey: "title")
            row.setValue("desktopcomputer", forKey: "iconName")
            row.setValue("10.0.0.1", forKey: "destination")
            row.setValue(0, forKey: "order")
            row.setValue(Date(timeIntervalSince1970: 1_600_000_000), forKey: "createdAt")
        }

        // Journal files only exist while SQLite has the store open, so seed them by hand: the point
        // of the test is that `discardStore` does not leave a `-wal` behind for the next open to
        // resurrect pages from.
        let journals = ["-wal", "-shm"].map { URL(fileURLWithPath: store.storeURL.path + $0) }
        for journal in journals {
            try Data().write(to: journal)
        }

        HostStoreMigrator.discardStore(at: store.storeURL)

        #expect(!FileManager.default.fileExists(atPath: store.storeURL.path))
        for journal in journals {
            #expect(!FileManager.default.fileExists(atPath: journal.path))
        }
    }

    @Test("Discarding a store that is not there is not an error")
    func discardMissingStoreIsHarmless() throws {
        let absent = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(UUID().uuidString).sqlite")

        HostStoreMigrator.discardStore(at: absent)

        #expect(!FileManager.default.fileExists(atPath: absent.path))
    }
}

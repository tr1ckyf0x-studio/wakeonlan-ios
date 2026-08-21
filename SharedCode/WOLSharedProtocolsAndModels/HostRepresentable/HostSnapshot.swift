//
//  HostSnapshot.swift
//
//
//  Created by Vladislav Lisianskii on 21. 8. 2026..
//

/// Value-type copy of the fields a magic packet needs.
///
/// - Important: A Core Data managed object is confined to its context's queue, so it must never be
///   handed to an `async` API: awaiting a nonisolated async function hops onto the cooperative pool,
///   and any property read there is a concurrency violation that traps under
///   `-com.apple.CoreData.ConcurrencyDebug 1`. Snapshot the values on the context's queue first and
///   pass the snapshot instead.
public struct HostSnapshot: HostRepresentable, Sendable {
    // MARK: - Properties

    public let macAddress: String?
    public let destination: String?
    public let port: String?

    // MARK: - Init

    public init(macAddress: String?, destination: String?, port: String?) {
        self.macAddress = macAddress
        self.destination = destination
        self.port = port
    }

    public init(host: HostRepresentable) {
        self.init(
            macAddress: host.macAddress,
            destination: host.destination,
            port: host.port
        )
    }
}

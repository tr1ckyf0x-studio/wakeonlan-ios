import CoreData
import CoreDataService
import Intents
import PersistenceCore
import WakeOnLanService
import WOLSharedProtocolsAndModels

final class WOLIntentHandler: NSObject, WOLIntentHandling {
    private let wakeOnLanService: WakeOnLanServiceProtocol
    private let coreDataService: CoreDataServiceProtocol

    init(
        wakeOnLanService: WakeOnLanServiceProtocol,
        coreDataService: CoreDataServiceProtocol
    ) {
        self.wakeOnLanService = wakeOnLanService
        self.coreDataService = coreDataService
    }

    func resolveHostname(for intent: WOLIntent) async -> INStringResolutionResult {
        guard let hostname = intent.hostname else {
            return INStringResolutionResult.needsValue()
        }
        do {
            let availableHostnames = try fetchHostnames()
            // NOTE: With nothing saved there is nothing to disambiguate between, and handing an
            // empty list to the Intents runtime leaves the shortcut stuck in resolution.
            guard !availableHostnames.isEmpty else {
                return INStringResolutionResult.unsupported()
            }
            // NOTE: Matched case-insensitively — Siri transcribes "wake my pc" as "my pc" while the
            // host is titled "My PC", which used to fall through to disambiguation every time. The
            // stored title is returned, not the transcription, so `handle(intent:)` can look the
            // host up by its exact name.
            let match = availableHostnames.first { (title: String) -> Bool in
                title.caseInsensitiveCompare(hostname) == .orderedSame
            }
            guard let match else {
                return INStringResolutionResult.disambiguation(with: availableHostnames)
            }

            return INStringResolutionResult.success(with: match)
        } catch {
            return INStringResolutionResult.unsupported()
        }
    }

    func handle(intent: WOLIntent) async -> WOLIntentResponse {
        guard let hostname = intent.hostname else {
            return WOLIntentResponse(code: .failure, userActivity: nil)
        }
        do {
            guard let host = try fetchHostSnapshot(with: hostname) else {
                return WOLIntentResponse(code: .failure, userActivity: nil)
            }
            try await wakeOnLanService.sendMagicPacket(to: host)
            return WOLIntentResponse.success(hostname: hostname)
        } catch {
            return WOLIntentResponse(code: .failure, userActivity: nil)
        }
    }

    func provideHostnameOptionsCollection(
        for intent: WOLIntent,
        searchTerm: String?
    ) async throws -> INObjectCollection<NSString> {
        var availableHostnames = try fetchHostnames()

        if let searchTerm, !searchTerm.isEmpty {
            availableHostnames = availableHostnames.filter { (hostname: String) -> Bool in
                hostname.contains(searchTerm)
            }
        }

        return INObjectCollection(items: availableHostnames as [NSString])
    }
}

// MARK: - Private methods

extension WOLIntentHandler {
    // NOTE: The generated `WOLIntentHandling` methods run off the main thread while `mainContext` is
    // a main-queue context, so both the fetch and every property read have to happen inside the
    // context's own queue. Managed objects deliberately do not escape these methods — only values.

    private func fetchHostnames() throws -> [String] {
        let context = coreDataService.mainContext
        // NOTE: The request is built inside the block — `NSFetchRequest` is not Sendable and must
        // not be captured by the `@Sendable` closure.
        return try context.performAndWait {
            try context.fetch(Host.sortedFetchRequest).map(\.title)
        }
    }

    private func fetchHostSnapshot(with name: String) throws -> HostSnapshot? {
        let context = coreDataService.mainContext
        return try context.performAndWait {
            let fetchRequest = Host.sortedFetchRequest
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "title == %@", name)

            return try context.fetch(fetchRequest).first.map(HostSnapshot.init(host:))
        }
    }
}

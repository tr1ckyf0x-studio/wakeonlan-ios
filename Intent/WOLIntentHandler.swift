import Intents
import WakeOnLanService
import CoreDataService

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
            let availableHostnames = try fetchHosts().map(\.title)
            let hostnameExists = availableHostnames.contains(hostname)
            if hostnameExists {
                return INStringResolutionResult.success(with: hostname)
            } else {
                return INStringResolutionResult.disambiguation(with: availableHostnames)
            }
        } catch {
            return INStringResolutionResult.unsupported()
        }
    }

    func handle(intent: WOLIntent) async -> WOLIntentResponse {
        guard let hostname = intent.hostname else {
            return WOLIntentResponse(code: .failure, userActivity: nil)
        }
        do {
            guard let host = try fetchHost(with: hostname) else {
                return WOLIntentResponse(code: .failure, userActivity: nil)
            }
            try wakeOnLanService.sendMagicPacket(to: host)
            return WOLIntentResponse.success(hostname: hostname)
        } catch {
            return WOLIntentResponse(code: .failure, userActivity: nil)
        }
    }
}

// MARK: - Private methods
extension WOLIntentHandler {
    private func fetchHosts() throws -> [Host] {
        let fetchRequest = Host.sortedFetchRequest
        let context = coreDataService.mainContext
        let objects = try context.fetch(fetchRequest)
        return objects
    }

    private func fetchHost(with name: String) throws -> Host? {
        let fetchRequest = Host.sortedFetchRequest
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "title == %@", name)
        let context = coreDataService.mainContext
        let host = try context.fetch(fetchRequest).first
        return host
    }
}

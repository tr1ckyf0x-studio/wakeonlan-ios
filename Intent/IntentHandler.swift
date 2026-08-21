import CoreDataService
import Intents
import PersistenceCore
import WakeOnLanService

final class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        guard intent is WOLIntent else {
            fatalError("Unhandled Intent error: \(intent)")
        }

        // NOTE: Built per request rather than held in static properties. The system retains the
        // handler for the duration of the request, and statics holding non-Sendable services are not
        // concurrency-safe in Swift 6.
        return WOLIntentHandler(
            wakeOnLanService: WakeOnLanService.shared,
            coreDataService: CoreDataService.shared
        )
    }
}

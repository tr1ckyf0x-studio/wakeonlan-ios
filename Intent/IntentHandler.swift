import Intents
import WakeOnLanService
import CoreDataService

final class IntentHandler: INExtension {

    private lazy var coreDataService: CoreDataServiceProtocol = CoreDataService<PersistentContainer.SQLite>()

    override func handler(for intent: INIntent) -> Any {
        guard intent is WOLIntent else {
            fatalError("Unhandled Intent error: \(intent)")
        }

        return WOLIntentHandler(
            wakeOnLanService: WakeOnLanService(),
            coreDataService: coreDataService
        )
    }
}

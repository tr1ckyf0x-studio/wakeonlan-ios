import Intents
import WakeOnLanService
import CoreDataService

final class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        guard intent is WOLIntent else {
            fatalError("Unhandled Intent error: \(intent)")
        }

        return Self.wolIntentHandler
    }
}

extension IntentHandler {
    private static var wakeOnLanService: WakeOnLanServiceProtocol = WakeOnLanService()

    private static var coreDataService: CoreDataServiceProtocol = {
        let coreDataService = CoreDataService<PersistentContainer.SQLite>()
        coreDataService.createHostContainer { }
        return coreDataService
    }()

    private static var wolIntentHandler: WOLIntentHandling = WOLIntentHandler(
        wakeOnLanService: wakeOnLanService,
        coreDataService: coreDataService
    )
}

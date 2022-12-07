import CoreDataService
import Intents
import WakeOnLanService

final class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        guard intent is WOLIntent else {
            fatalError("Unhandled Intent error: \(intent)")
        }

        return Self.wolIntentHandler
    }
}

extension IntentHandler {
    private static let wakeOnLanService: WakeOnLanServiceProtocol = WakeOnLanService(
        magicPacketBuilder: MagicPacketBuilder(),
        udpService: UDPService()
    )

    private static let coreDataService: CoreDataServiceProtocol = CoreDataService.shared

    private static let wolIntentHandler: WOLIntentHandling = WOLIntentHandler(
        wakeOnLanService: wakeOnLanService,
        coreDataService: coreDataService
    )
}

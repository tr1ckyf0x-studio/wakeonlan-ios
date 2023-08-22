import Foundation
import SharedProtocolsAndModels

// sourcery: AutoMockable
public protocol WakeOnLanServiceProtocol {
    func sendMagicPacket(to host: HostRepresentable) throws
}

import WOLSharedProtocolsAndModels

public protocol WakeOnLanServiceProtocol {
    func sendMagicPacket(to host: HostRepresentable) async throws
}

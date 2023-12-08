import SharedProtocolsAndModels

public protocol WakeOnLanServiceProtocol {
    func sendMagicPacket(to host: HostRepresentable) async throws
}

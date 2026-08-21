//
//  WakeOnLanService.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 23.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import SharedProtocolsAndModels
import WOLSharedProtocolsAndModels

public final class WakeOnLanService {
    private let magicPacketBuilder: BuildsMagicPacket
    private let udpService: UDPService

    public init(magicPacketBuilder: BuildsMagicPacket, udpService: UDPService) {
        self.magicPacketBuilder = magicPacketBuilder
        self.udpService = udpService
    }
}

// MARK: - WakeOnLanServiceProtocol

extension WakeOnLanService: WakeOnLanServiceProtocol {
    public func sendMagicPacket(to host: HostRepresentable) async throws {
        let destination = host.destination.defaultIfEmpty(Constants.broadcastIPAddress)
        let port = host.port.flatMap(UInt16.init) ?? Constants.magicPocketDefaultPort
        let packet = try magicPacketBuilder.build(for: host.macAddress)
        try await udpService.send(packet, to: destination, port: port)
    }
}

// MARK: - ProvidesWeakSharedInstanceTrait

extension WakeOnLanService: ProvidesWeakSharedInstanceTrait {
    // NOTE: `nonisolated(unsafe)` because the trait's `shared` getter is nonisolated and the
    // Siri extension reaches for it outside the main actor. The instance is created once per
    // process through a lazy global, so there is no realistic race — but the compiler cannot
    // prove it. Replacing this weak-singleton trait with injected dependencies would.
    nonisolated(unsafe) public static weak var weakSharedInstance: WakeOnLanService?

    public convenience init() {
        self.init(magicPacketBuilder: MagicPacketBuilder(), udpService: NWUDPService())
    }
}

// MARK: - Constants

extension WakeOnLanService {
    private enum Constants {
        static let broadcastIPAddress = "255.255.255.255"
        static let magicPocketDefaultPort: UInt16 = 9
    }
}

extension Optional where Wrapped == String {
    fileprivate func defaultIfEmpty(_ value: Wrapped) -> Wrapped {
        let existingValue = self ?? Wrapped()

        if existingValue.isEmpty {
            return value
        }

        return existingValue
    }
}

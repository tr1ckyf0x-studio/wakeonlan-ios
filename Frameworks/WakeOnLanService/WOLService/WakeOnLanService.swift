//
//  WakeOnLanService.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 23.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import SharedProtocolsAndModels

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
    public static weak var weakSharedInstance: WakeOnLanService?

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

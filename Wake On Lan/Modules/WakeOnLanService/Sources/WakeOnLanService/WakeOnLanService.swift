//
//  WakeOnLanService.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 23.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import SharedProtocolsAndModels

// sourcery: AutoMockable
public protocol WakeOnLanServiceProtocol {
    func sendMagicPacket(to host: HostRepresentable) throws
}

public final class WakeOnLanService {
    public init() { }
}

extension WakeOnLanService: WakeOnLanServiceProtocol {
    public func sendMagicPacket(to host: HostRepresentable) throws {
        var udpSocket: Int32
        var target = sockaddr_in()

        let ipAddress = host.ipAddress ?? Constants.broadcastIPAddress
        let port = host.port.flatMap(UInt16.init) ?? Constants.magicPocketDefaultPort
        let addressFamily = AF_INET

        target.sin_family = sa_family_t(addressFamily)
        target.sin_addr.s_addr = inet_addr(ipAddress)

        let isLittleEndian = Int(OSHostByteOrder()) == OSLittleEndian
        target.sin_port = isLittleEndian ? _OSSwapInt16(port) : port

        udpSocket = socket(addressFamily, SOCK_DGRAM, IPPROTO_UDP)
        guard udpSocket >= 0 else {
            let error = String(utf8String: strerror(errno)) ?? ""
            throw Self.Error.socketSetup(reason: error)
        }

        defer {
            close(udpSocket)
        }

        let intLen = socklen_t(MemoryLayout<Int>.stride)
        var broadcast = 1
        guard setsockopt(udpSocket, SOL_SOCKET, SO_BROADCAST, &broadcast, intLen) == 0 else {
            let error = String(utf8String: strerror(errno)) ?? ""
            throw Self.Error.socketSetup(reason: error)
        }

        var packet = try MagicPacketBuilder.build(for: host.macAddress)
        let sockaddrLen = socklen_t(MemoryLayout<sockaddr>.stride)
        var targetCast = unsafeBitCast(target, to: sockaddr.self)

        guard sendto(
            udpSocket,
            &packet,
            packet.count,
            0,
            &targetCast,
            sockaddrLen
        ) == packet.count else {
            let error = String(utf8String: strerror(errno)) ?? ""
            throw Self.Error.send(reason: error)
        }
    }
}

// MARK: - Error
extension WakeOnLanService {
    public enum Error: LocalizedError {
        case socketSetup(reason: String)
        case send(reason: String)

        public var errorDescription: String? {
            switch self {
            case .socketSetup, .send:
                return "Unexpected error occured"
            }
        }

        public var failureReason: String? {
            switch self {
            case let .socketSetup(reason), let .send(reason):
                return reason
            }
        }
    }
}

// MARK: - Constants
extension WakeOnLanService {
    private enum Constants {
        static let broadcastIPAddress = "255.255.255.255"
        static let magicPocketDefaultPort: UInt16 = 9
    }
}

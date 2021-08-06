//
//  WakeOnLanService.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 23.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import WOLResources
import SharedProtocols

public final class WakeOnLanService {

    private enum Constants {
        static let magicPocketHeaderLength = 6
        static let magicPocketHeaderByte: UInt8 = 0xFF
        static let magicPocketBodyLength = 16
        static let macAddressDigitSeparator = ":"
        static let macAddressBytesCount = 6
        static let macAddressRadix = 16
        static let broadcastIPAddress = "255.255.255.255"
        static let magicPocketDefaultPort = "9"
    }

    public enum Error: LocalizedError {
        case wrongMacAddressLength
        case socketSetup(reason: String)
        case send(reason: String)

        public var errorDescription: String? {
            switch self {
            case .wrongMacAddressLength:
                return L10n.WakeOnLan.wrongMacAddressLength("\(Constants.macAddressBytesCount)")

            case .socketSetup, .send:
                return L10n.WakeOnLan.wakeOnLanUnexpectedError
            }
        }

        public var failureReason: String? {
            switch self {
            case let .socketSetup(reason), let .send(reason):
                return reason

            default:
                return nil
            }
        }
    }

    public init() { }

    public func sendMagicPacket(to host: HostRepresentable) throws {
        var udpSocket: Int32
        var target = sockaddr_in()

        let ipAddress = host.ipAddress ?? Constants.broadcastIPAddress
        let port = UInt16(host.port ?? Constants.magicPocketDefaultPort)!
        let addressFamily = AF_INET

        target.sin_family = sa_family_t(addressFamily)
        target.sin_addr.s_addr = inet_addr(ipAddress)

        let isLittleEndian = Int(OSHostByteOrder()) == OSLittleEndian
        target.sin_port = isLittleEndian ? _OSSwapInt16(port): port

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

        var packet = try createMagicPacket(for: host.macAddress)
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

    private func createMagicPacket(for macAddress: String?) throws -> [UInt8] {
        guard let macAddress = macAddress else { throw Self.Error.wrongMacAddressLength }

        let header = [UInt8](
            repeating: Constants.magicPocketHeaderByte,
            count: Constants.magicPocketHeaderLength
        )
        let macComponents = macAddress
            .components(separatedBy: Constants.macAddressDigitSeparator)
            .compactMap { digit -> UInt8? in
                UInt8(digit, radix: Constants.macAddressRadix)
            }

        guard macComponents.count == Constants.macAddressBytesCount else {
            throw Self.Error.wrongMacAddressLength
        }

        let body = Array(
            repeating: macComponents,
            count: Constants.magicPocketBodyLength
        ).flatMap { $0 }

        let magicPacketBytes = header + body

        return magicPacketBytes
    }
}

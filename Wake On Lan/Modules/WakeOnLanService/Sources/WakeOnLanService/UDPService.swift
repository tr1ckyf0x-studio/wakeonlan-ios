import Foundation

public final class UDPService {
    public init() { }
}

// MARK: - UDPServiceProtocol
extension UDPService: UDPServiceProtocol {
    public func send(_ packet: [UInt8], to ipAddress: String, port: UInt16) throws {
        var udpSocket: Int32
        var target = sockaddr_in()

        let addressFamily = AF_INET

        target.sin_family = sa_family_t(addressFamily)
        target.sin_addr.s_addr = inet_addr(ipAddress)

        let isLittleEndian = Int(OSHostByteOrder()) == OSLittleEndian
        target.sin_port = isLittleEndian ? _OSSwapInt16(port) : port

        udpSocket = socket(addressFamily, SOCK_DGRAM, IPPROTO_UDP)
        guard udpSocket >= 0 else {
            let error = String(utf8String: strerror(errno)) ?? ""
            throw UDPError.socketSetup(reason: error)
        }

        defer {
            close(udpSocket)
        }

        let intLen = socklen_t(MemoryLayout<Int>.stride)
        var broadcast = 1
        guard setsockopt(udpSocket, SOL_SOCKET, SO_BROADCAST, &broadcast, intLen) == 0 else {
            let error = String(utf8String: strerror(errno)) ?? ""
            throw UDPError.socketSetup(reason: error)
        }

        let sockaddrLen = socklen_t(MemoryLayout<sockaddr>.stride)
        var targetCast = unsafeBitCast(target, to: sockaddr.self)

        var packet = packet

        guard sendto(
            udpSocket,
            &packet,
            packet.count,
            0,
            &targetCast,
            sockaddrLen
        ) == packet.count else {
            let error = String(utf8String: strerror(errno)) ?? ""
            throw UDPError.send(reason: error)
        }
    }
}

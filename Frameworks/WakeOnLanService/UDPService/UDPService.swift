import Foundation

// sourcery: AutoMockable
public protocol UDPService {
    /**
     Sends UDP packet to specified address

     - Parameters:
        - packet: Byte array of the packet.
        - to: Target host.
        - port: Target port
     - Throws: `UDPError.socketSetup` if socket is unable to setup.
               `UDPError.send` if error occured during packet sending
     */
    func send(_ packet: [UInt8], to destination: String, port: UInt16) async throws
}

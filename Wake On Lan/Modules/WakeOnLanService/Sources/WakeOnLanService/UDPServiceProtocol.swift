import Foundation

// sourcery: AutoMockable
public protocol UDPServiceProtocol {
    /**
     Sends UDP packet to specified address

     - Parameters:
        - packet: Byte array of the packet.
        - to: Target IP address.
        - port: Target port
     - Throws: `UDPError.socketSetup` if socket is unable to setup.
               `UDPError.send` if error occured during packet sending
     */
    func send(_ packet: [UInt8], to ipAddress: String, port: UInt16) throws
}

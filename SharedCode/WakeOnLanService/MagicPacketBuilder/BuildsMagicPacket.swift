import Foundation

public protocol BuildsMagicPacket {
    /**
     Builds magic packet for specified macAddress.

     - Parameter macAddress: MAC address the magic packet building for.
     Must consist of 6 bytes in hex format, separated by colons.
     - Throws: `MagicPacketError.wrongMacAddressFormat` if `macAddress` has wrong format.
     - Returns: Byte array of the magic packet

     - Note: Magic packet consists of header - 6 times repeated 0xFF
     and body - 16 times repeated MAC address
     in the following order:

     `[header][body]`
     */
    func build(for macAddress: String?) throws -> [UInt8]
}

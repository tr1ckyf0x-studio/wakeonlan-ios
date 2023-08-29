import Network

enum NWConnectionBuilder {
    /**
     Builds NWConnection for given IP address and port
     - Parameters:
     - with: Target host
     - port: Target port
     */
    static func build(with destination: String, port: UInt16) -> NWConnection? {
        guard let codedPort = NWEndpoint.Port(rawValue: port) else {
            return nil
        }

        let host = NWEndpoint.Host(destination)

        return NWConnection(host: host, port: codedPort, using: .udp)
    }
}

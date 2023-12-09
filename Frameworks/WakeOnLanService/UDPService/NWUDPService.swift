import Network

public final class NWUDPService {
    public init() { }
}

// MARK: - UDPService

extension NWUDPService: UDPService {
    public func send(_ packet: [UInt8], to destination: String, port: UInt16) async throws {
        guard let connection = NWConnectionBuilder.build(with: destination, port: port)
        else {
            throw UDPError.socketSetup(reason: "Wrong address or port \(destination):\(port)")
        }

        connection.start(queue: .global())

        Task {
            try await connection.send(content: packet, contentContext: .finalMessage)
            connection.cancel()
        }
    }
}

extension NWConnection {
    fileprivate func send<Content: DataProtocol>(
        content: Content,
        contentContext: NWConnection.ContentContext = .defaultMessage,
        isComplete: Bool = true
    ) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            send(
                content: content,
                contentContext: contentContext,
                isComplete: isComplete,
                completion: SendCompletion.contentProcessed({ (error: NWError?) in
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                })
            )
        }
    }
}
